// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/math/Math.sol";
import "@openzeppelin/contracts/utils/EnumerableSet.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "./libraries/DecimalsConverter.sol";

import "./interfaces/IContractsRegistry.sol";
import "./interfaces/helpers/IPriceFeed.sol";
import "./interfaces/IClaimVoting.sol";
import "./interfaces/IPolicyBookRegistry.sol";
import "./interfaces/IReputationSystem.sol";
import "./interfaces/IReinsurancePool.sol";
import "./interfaces/IPolicyBook.sol";
import "./interfaces/IStkBMIStaking.sol";

import "./interfaces/tokens/IVBMI.sol";

import "./abstract/AbstractDependant.sol";

import "./Globals.sol";

contract ClaimVoting is IClaimVoting, Initializable, AbstractDependant {
    using SafeMath for uint256;
    using Math for uint256;
    using EnumerableSet for EnumerableSet.UintSet;

    IPriceFeed public priceFeed;

    IERC20 public bmiToken;
    IReinsurancePool public reinsurancePool;
    IVBMI public vBMI;
    IClaimingRegistry public claimingRegistry;
    IPolicyBookRegistry public policyBookRegistry;
    IReputationSystem public reputationSystem;

    uint256 public stblDecimals;

    uint256 public constant PERCENTAGE_50 = 50 * PRECISION;

    uint256 public constant APPROVAL_PERCENTAGE = 66 * PRECISION;
    uint256 public constant PENALTY_THRESHOLD = 11 * PRECISION;
    uint256 public constant QUORUM = 10 * PRECISION;
    uint256 public constant CALCULATION_REWARD_PER_DAY = PRECISION;

    // claim index -> info
    mapping(uint256 => VotingResult) internal _votings;

    // voter -> claim indexes
    mapping(address => EnumerableSet.UintSet) internal _myNotReceivedVotes;

    // voter -> voting indexes
    mapping(address => EnumerableSet.UintSet) internal _myVotes;

    // voter -> claim index -> vote index
    mapping(address => mapping(uint256 => uint256)) internal _allVotesToIndex;

    // vote index -> voting instance
    mapping(uint256 => VotingInst) internal _allVotesByIndexInst;

    EnumerableSet.UintSet internal _allVotesIndexes;

    uint256 private _voteIndex;

    IStkBMIStaking public stkBMIStaking;

    // vote index -> results of calculation
    mapping(uint256 => VotesUpdatesInfo) public override voteResults;

    event AnonymouslyVoted(uint256 claimIndex);
    event VoteExposed(uint256 claimIndex, address voter, uint256 suggestedClaimAmount);
    event VoteCalculated(uint256 claimIndex, address voter, VoteStatus status);
    event RewardsForVoteCalculationSent(address voter, uint256 bmiAmount);
    event RewardsForClaimCalculationSent(address calculator, uint256 bmiAmount);
    event ClaimCalculated(uint256 claimIndex, address calculator);

    modifier onlyPolicyBook() {
        require(policyBookRegistry.isPolicyBook(msg.sender), "CV: Not a PolicyBook");
        _;
    }

    modifier onlyClaimingRegistry() {
        require(msg.sender == address(claimingRegistry), "CV: Not ClaimingRegistry");
        _;
    }

    function _isVoteAwaitingExposure(uint256 index) internal view returns (bool) {
        uint256 claimIndex = _allVotesByIndexInst[index].claimIndex;

        return (_allVotesByIndexInst[index].status == VoteStatus.ANONYMOUS_PENDING &&
            claimingRegistry.isClaimExposablyVotable(claimIndex));
    }

    function _isVoteExpired(uint256 index) internal view returns (bool) {
        uint256 claimIndex = _allVotesByIndexInst[index].claimIndex;

        return (_allVotesByIndexInst[index].status == VoteStatus.ANONYMOUS_PENDING &&
            !claimingRegistry.isClaimVotable(claimIndex));
    }

    function __ClaimVoting_init() external initializer {
        _voteIndex = 1;
    }

    function setDependencies(IContractsRegistry _contractsRegistry)
        external
        override
        onlyInjectorOrZero
    {
        priceFeed = IPriceFeed(_contractsRegistry.getPriceFeedContract());
        claimingRegistry = IClaimingRegistry(_contractsRegistry.getClaimingRegistryContract());
        policyBookRegistry = IPolicyBookRegistry(
            _contractsRegistry.getPolicyBookRegistryContract()
        );
        reputationSystem = IReputationSystem(_contractsRegistry.getReputationSystemContract());
        reinsurancePool = IReinsurancePool(_contractsRegistry.getReinsurancePoolContract());
        bmiToken = IERC20(_contractsRegistry.getBMIContract());
        stkBMIStaking = IStkBMIStaking(_contractsRegistry.getStkBMIStakingContract());

        stblDecimals = ERC20(_contractsRegistry.getUSDTContract()).decimals();
    }

    /// @notice this function needs user's BMI approval of this address (check policybook)
    function initializeVoting(
        address claimer,
        string calldata evidenceURI,
        uint256 coverTokens,
        bool appeal
    ) external override onlyPolicyBook {
        require(coverTokens > 0, "CV: Claimer has no coverage");

        // this checks claim duplicate && appeal logic
        uint256 claimIndex =
            claimingRegistry.submitClaim(claimer, msg.sender, evidenceURI, coverTokens, appeal);

        uint256 onePercentInBMIToLock =
            priceFeed.howManyBMIsInUSDT(
                DecimalsConverter.convertFrom18(coverTokens.div(100), stblDecimals)
            );

        bmiToken.transferFrom(claimer, address(this), onePercentInBMIToLock); // needed approval

        IPolicyBook.PolicyHolder memory policyHolder = IPolicyBook(msg.sender).userStats(claimer);
        uint256 reinsuranceTokensAmount = policyHolder.reinsurancePrice;
        reinsuranceTokensAmount = Math.min(reinsuranceTokensAmount, coverTokens.div(100));

        _votings[claimIndex].withdrawalAmount = coverTokens;
        _votings[claimIndex].lockedBMIAmount = onePercentInBMIToLock;
        _votings[claimIndex].reinsuranceTokensAmount = reinsuranceTokensAmount;
    }

    /// @dev check if no vote or vote pending reception, if true -> can vote
    /// @dev Voters can vote on other Claims only when they updated their reputation and received outcomes for all Resolved Claims.
    /// @dev _myNotReceivedVotes represent list of vote pending calculation or calculated but not received
    function canVote(address user) public view override returns (bool) {
        return _myNotReceivedVotes[user].length() == 0;
    }

    /// @dev check in StkBMIStaking when withdrawing, if true -> can withdraw
    /// @dev Voters can unstake stkBMI only when there are no voted Claims
    function canUnstake(address user) external view override returns (bool) {
        uint256 voteLength = _myVotes[user].length();

        for (uint256 i = 0; i < voteLength; i++) {
            if (voteStatus(_myVotes[user].at(i)) != VoteStatus.RECEIVED) {
                return false;
            }
        }
        return true;
    }

    function countVoteOnClaim(uint256 claimIndex) external view override returns (uint256) {
        return _votings[claimIndex].voteIndexes.length();
    }

    function lockedBMIAmount(uint256 claimIndex) public view override returns (uint256) {
        return _votings[claimIndex].lockedBMIAmount;
    }

    function countVotes(address user) external view override returns (uint256) {
        return _myVotes[user].length();
    }

    function voteIndex(uint256 claimIndex, address user) external view returns (uint256) {
        return _allVotesToIndex[user][claimIndex];
    }

    function getVotingPower(uint256 index) external view returns (uint256) {
        return
            _allVotesByIndexInst[index].voterReputation.mul(
                _allVotesByIndexInst[index].stakedStkBMIAmount
            );
    }

    function voteIndexByClaimIndexAt(uint256 claimIndex, uint256 orderIndex)
        external
        view
        override
        returns (uint256)
    {
        return _votings[claimIndex].voteIndexes.at(orderIndex);
    }

    function voteStatus(uint256 index) public view override returns (VoteStatus) {
        require(_allVotesIndexes.contains(index), "CV: Vote doesn't exist");

        if (_isVoteAwaitingExposure(index)) {
            return VoteStatus.AWAITING_EXPOSURE;
        } else if (_isVoteExpired(index)) {
            return VoteStatus.EXPIRED;
        }

        return _allVotesByIndexInst[index].status;
    }

    /// @dev use with claimingRegistry.countPendingClaims()
    function whatCanIVoteFor(uint256 offset, uint256 limit)
        external
        view
        override
        returns (uint256 _claimsCount, PublicClaimInfo[] memory _votablesInfo)
    {
        uint256 to = (offset.add(limit)).min(claimingRegistry.countPendingClaims()).max(offset);
        bool trustedVoter = reputationSystem.isTrustedVoter(msg.sender);

        _claimsCount = 0;

        _votablesInfo = new PublicClaimInfo[](to - offset);

        for (uint256 i = offset; i < to; i++) {
            uint256 index = claimingRegistry.pendingClaimIndexAt(i);

            if (
                _allVotesToIndex[msg.sender][index] == 0 &&
                claimingRegistry.claimOwner(index) != msg.sender &&
                claimingRegistry.isClaimAnonymouslyVotable(index) &&
                (!claimingRegistry.isClaimAppeal(index) || trustedVoter)
            ) {
                IClaimingRegistry.ClaimInfo memory claimInfo = claimingRegistry.claimInfo(index);

                _votablesInfo[_claimsCount].claimIndex = index;
                _votablesInfo[_claimsCount].claimer = claimInfo.claimer;
                _votablesInfo[_claimsCount].policyBookAddress = claimInfo.policyBookAddress;
                _votablesInfo[_claimsCount].evidenceURI = claimInfo.evidenceURI;
                _votablesInfo[_claimsCount].appeal = claimInfo.appeal;
                _votablesInfo[_claimsCount].claimAmount = claimInfo.claimAmount;
                _votablesInfo[_claimsCount].time = claimInfo.dateSubmitted;

                _votablesInfo[_claimsCount].time = _votablesInfo[_claimsCount]
                    .time
                    .add(claimingRegistry.anonymousVotingDuration(index))
                    .sub(block.timestamp);

                _claimsCount++;
            }
        }
    }

    /// @dev use with claimingRegistry.countClaims()
    function allClaims(uint256 offset, uint256 limit)
        external
        view
        override
        returns (AllClaimInfo[] memory _allClaimsInfo)
    {
        uint256 to = (offset.add(limit)).min(claimingRegistry.countClaims()).max(offset);

        _allClaimsInfo = new AllClaimInfo[](to - offset);

        for (uint256 i = offset; i < to; i++) {
            uint256 index = claimingRegistry.claimIndexAt(i);

            IClaimingRegistry.ClaimInfo memory claimInfo = claimingRegistry.claimInfo(index);

            _allClaimsInfo[i - offset].publicClaimInfo.claimIndex = index;
            _allClaimsInfo[i - offset].publicClaimInfo.claimer = claimInfo.claimer;
            _allClaimsInfo[i - offset].publicClaimInfo.policyBookAddress = claimInfo
                .policyBookAddress;
            _allClaimsInfo[i - offset].publicClaimInfo.evidenceURI = claimInfo.evidenceURI;
            _allClaimsInfo[i - offset].publicClaimInfo.appeal = claimInfo.appeal;
            _allClaimsInfo[i - offset].publicClaimInfo.claimAmount = claimInfo.claimAmount;
            _allClaimsInfo[i - offset].publicClaimInfo.time = claimInfo.dateSubmitted;

            _allClaimsInfo[i - offset].finalVerdict = claimInfo.status;

            if (
                _allClaimsInfo[i - offset].finalVerdict == IClaimingRegistry.ClaimStatus.ACCEPTED
            ) {
                _allClaimsInfo[i - offset].finalClaimAmount = _votings[index]
                    .votedAverageWithdrawalAmount;
            }

            if (claimingRegistry.canClaimBeCalculatedByAnyone(index)) {
                _allClaimsInfo[i - offset].bmiCalculationReward = _getBMIRewardForCalculation(
                    index
                );
            }
        }
    }

    /// @dev use with claimingRegistry.countPolicyClaimerClaims()
    function myClaims(uint256 offset, uint256 limit)
        external
        view
        override
        returns (MyClaimInfo[] memory _myClaimsInfo)
    {
        uint256 to =
            (offset.add(limit)).min(claimingRegistry.countPolicyClaimerClaims(msg.sender)).max(
                offset
            );

        _myClaimsInfo = new MyClaimInfo[](to - offset);

        for (uint256 i = offset; i < to; i++) {
            uint256 index = claimingRegistry.claimOfOwnerIndexAt(msg.sender, i);

            IClaimingRegistry.ClaimInfo memory claimInfo = claimingRegistry.claimInfo(index);

            _myClaimsInfo[i - offset].index = index;
            _myClaimsInfo[i - offset].policyBookAddress = claimInfo.policyBookAddress;
            _myClaimsInfo[i - offset].evidenceURI = claimInfo.evidenceURI;
            _myClaimsInfo[i - offset].appeal = claimInfo.appeal;
            _myClaimsInfo[i - offset].claimAmount = claimInfo.claimAmount;
            _myClaimsInfo[i - offset].finalVerdict = claimInfo.status;

            if (_myClaimsInfo[i - offset].finalVerdict == IClaimingRegistry.ClaimStatus.ACCEPTED) {
                _myClaimsInfo[i - offset].finalClaimAmount = _votings[index]
                    .votedAverageWithdrawalAmount;
            } else if (
                _myClaimsInfo[i - offset].finalVerdict ==
                IClaimingRegistry.ClaimStatus.AWAITING_CALCULATION
            ) {
                _myClaimsInfo[i - offset].bmiCalculationReward = _getBMIRewardForCalculation(
                    index
                );
            }
        }
    }

    /// @dev use with countVotes()
    function myVotes(uint256 offset, uint256 limit)
        external
        view
        override
        returns (MyVoteInfo[] memory _myVotesInfo)
    {
        uint256 to = (offset.add(limit)).min(_myVotes[msg.sender].length()).max(offset);

        _myVotesInfo = new MyVoteInfo[](to - offset);

        for (uint256 i = offset; i < to; i++) {
            uint256 voteIndex = _myVotes[msg.sender].at(i);
            uint256 claimIndex = _allVotesByIndexInst[voteIndex].claimIndex;

            IClaimingRegistry.ClaimInfo memory claimInfo = claimingRegistry.claimInfo(claimIndex);

            _myVotesInfo[i - offset].allClaimInfo.publicClaimInfo.claimIndex = claimIndex;
            _myVotesInfo[i - offset].allClaimInfo.publicClaimInfo.claimer = claimInfo.claimer;
            _myVotesInfo[i - offset].allClaimInfo.publicClaimInfo.policyBookAddress = claimInfo
                .policyBookAddress;
            _myVotesInfo[i - offset].allClaimInfo.publicClaimInfo.evidenceURI = claimInfo
                .evidenceURI;
            _myVotesInfo[i - offset].allClaimInfo.publicClaimInfo.appeal = claimInfo.appeal;
            _myVotesInfo[i - offset].allClaimInfo.publicClaimInfo.claimAmount = claimInfo
                .claimAmount;
            _myVotesInfo[i - offset].allClaimInfo.publicClaimInfo.time = claimInfo.dateSubmitted;

            _myVotesInfo[i - offset].allClaimInfo.finalVerdict = claimInfo.status;

            if (
                _myVotesInfo[i - offset].allClaimInfo.finalVerdict ==
                IClaimingRegistry.ClaimStatus.ACCEPTED
            ) {
                _myVotesInfo[i - offset].allClaimInfo.finalClaimAmount = _votings[claimIndex]
                    .votedAverageWithdrawalAmount;
            }

            _myVotesInfo[i - offset].suggestedAmount = _allVotesByIndexInst[voteIndex]
                .suggestedAmount;
            _myVotesInfo[i - offset].status = voteStatus(voteIndex);

            if (_myVotesInfo[i - offset].status == VoteStatus.ANONYMOUS_PENDING) {
                _myVotesInfo[i - offset].time = claimInfo
                    .dateSubmitted
                    .add(claimingRegistry.anonymousVotingDuration(claimIndex))
                    .sub(block.timestamp);
            } else if (_myVotesInfo[i - offset].status == VoteStatus.AWAITING_EXPOSURE) {
                _myVotesInfo[i - offset].encryptedVote = _allVotesByIndexInst[voteIndex]
                    .encryptedVote;
                _myVotesInfo[i - offset].time = claimInfo
                    .dateSubmitted
                    .add(claimingRegistry.votingDuration(claimIndex))
                    .sub(block.timestamp);
            }
        }
    }

    function myNotReceivesVotes(address user)
        public
        view
        override
        returns (uint256[] memory claimIndexes, VotesUpdatesInfo[] memory voteRewardInfo)
    {
        uint256 notReceivedCount = _myNotReceivedVotes[user].length();
        claimIndexes = new uint256[](notReceivedCount);
        voteRewardInfo = new VotesUpdatesInfo[](notReceivedCount);

        for (uint256 i = 0; i < notReceivedCount; i++) {
            uint256 claimIndex = _myNotReceivedVotes[user].at(i);
            uint256 voteIndex = _allVotesToIndex[user][claimIndex];
            claimIndexes[i] = claimIndex;
            voteRewardInfo[i].bmiReward = voteResults[voteIndex].bmiReward;
            voteRewardInfo[i].stblReward = voteResults[voteIndex].stblReward;
            voteRewardInfo[i].reputationChange = voteResults[voteIndex].reputationChange;
            voteRewardInfo[i].stakeChange = voteResults[voteIndex].stakeChange;
        }
    }

    function _calculateAverages(
        uint256 claimIndex,
        uint256 stakedStkBMI,
        uint256 suggestedClaimAmount,
        uint256 reputationWithPrecision,
        bool votedFor
    ) internal {
        VotingResult storage info = _votings[claimIndex];

        if (votedFor) {
            uint256 votedPower = info.votedYesStakedStkBMIAmountWithReputation;
            uint256 voterPower = stakedStkBMI.mul(reputationWithPrecision);
            uint256 totalPower = votedPower.add(voterPower);

            uint256 votedSuggestedPrice = info.votedAverageWithdrawalAmount.mul(votedPower);
            uint256 voterSuggestedPrice = suggestedClaimAmount.mul(voterPower);
            if (totalPower > 0) {
                info.votedAverageWithdrawalAmount = votedSuggestedPrice
                    .add(voterSuggestedPrice)
                    .div(totalPower);
            }
            info.votedYesStakedStkBMIAmountWithReputation = totalPower;
        } else {
            info.votedNoStakedStkBMIAmountWithReputation = info
                .votedNoStakedStkBMIAmountWithReputation
                .add(stakedStkBMI.mul(reputationWithPrecision));
        }

        info.allVotedStakedStkBMIAmount = info.allVotedStakedStkBMIAmount.add(stakedStkBMI);
    }

    function _modifyExposedVote(
        address voter,
        uint256 claimIndex,
        uint256 suggestedClaimAmount,
        bool accept
    ) internal {
        uint256 index = _allVotesToIndex[voter][claimIndex];

        _allVotesByIndexInst[index].finalHash = 0;
        delete _allVotesByIndexInst[index].encryptedVote;

        _allVotesByIndexInst[index].suggestedAmount = suggestedClaimAmount;
        _allVotesByIndexInst[index].accept = accept;
        _allVotesByIndexInst[index].status = VoteStatus.EXPOSED_PENDING;
    }

    function _addAnonymousVote(
        address voter,
        uint256 claimIndex,
        bytes32 finalHash,
        string memory encryptedVote,
        uint256 stakedStkBMI
    ) internal {
        _myVotes[voter].add(_voteIndex);

        _allVotesByIndexInst[_voteIndex].claimIndex = claimIndex;
        _allVotesByIndexInst[_voteIndex].finalHash = finalHash;
        _allVotesByIndexInst[_voteIndex].encryptedVote = encryptedVote;
        _allVotesByIndexInst[_voteIndex].voter = voter;
        _allVotesByIndexInst[_voteIndex].voterReputation = reputationSystem.reputation(voter);
        _allVotesByIndexInst[_voteIndex].stakedStkBMIAmount = stakedStkBMI;
        // No need to set default ANONYMOUS_PENDING status

        _allVotesToIndex[voter][claimIndex] = _voteIndex;
        _allVotesIndexes.add(_voteIndex);

        _votings[claimIndex].voteIndexes.add(_voteIndex);

        _voteIndex++;
    }

    function anonymouslyVoteBatch(
        uint256[] calldata claimIndexes,
        bytes32[] calldata finalHashes,
        string[] calldata encryptedVotes
    ) external override {
        require(canVote(msg.sender), "CV: There are reception awaiting votes");
        require(
            claimIndexes.length == finalHashes.length &&
                claimIndexes.length == encryptedVotes.length,
            "CV: Length mismatches"
        );

        uint256 stakedStkBMI = stkBMIStaking.stakedStkBMI(msg.sender);
        require(stakedStkBMI > 0, "CV: 0 staked StkBMI");

        for (uint256 i = 0; i < claimIndexes.length; i++) {
            uint256 claimIndex = claimIndexes[i];

            require(
                claimingRegistry.isClaimAnonymouslyVotable(claimIndex),
                "CV: Anonymous voting is over"
            );
            require(
                claimingRegistry.claimOwner(claimIndex) != msg.sender,
                "CV: Voter is the claimer"
            );
            require(
                !claimingRegistry.isClaimAppeal(claimIndex) ||
                    reputationSystem.isTrustedVoter(msg.sender),
                "CV: Not a trusted voter"
            );
            require(
                _allVotesToIndex[msg.sender][claimIndex] == 0,
                "CV: Already voted for this claim"
            );

            _addAnonymousVote(
                msg.sender,
                claimIndex,
                finalHashes[i],
                encryptedVotes[i],
                stakedStkBMI
            );

            emit AnonymouslyVoted(claimIndex);
        }
    }

    function exposeVoteBatch(
        uint256[] calldata claimIndexes,
        uint256[] calldata suggestedClaimAmounts,
        bytes32[] calldata hashedSignaturesOfClaims
    ) external override {
        require(
            claimIndexes.length == suggestedClaimAmounts.length &&
                claimIndexes.length == hashedSignaturesOfClaims.length,
            "CV: Length mismatches"
        );

        for (uint256 i = 0; i < claimIndexes.length; i++) {
            uint256 claimIndex = claimIndexes[i];
            uint256 voteIndex = _allVotesToIndex[msg.sender][claimIndex];

            require(_allVotesIndexes.contains(voteIndex), "CV: Vote doesn't exist");
            require(_isVoteAwaitingExposure(voteIndex), "CV: Vote is not awaiting");

            bytes32 finalHash =
                keccak256(
                    abi.encodePacked(
                        hashedSignaturesOfClaims[i],
                        _allVotesByIndexInst[voteIndex].encryptedVote,
                        suggestedClaimAmounts[i]
                    )
                );

            require(_allVotesByIndexInst[voteIndex].finalHash == finalHash, "CV: Data mismatches");
            require(
                _votings[claimIndex].withdrawalAmount >= suggestedClaimAmounts[i],
                "CV: Amount exceeds coverage"
            );

            bool voteFor = (suggestedClaimAmounts[i] > 0);

            _calculateAverages(
                claimIndex,
                _allVotesByIndexInst[voteIndex].stakedStkBMIAmount,
                suggestedClaimAmounts[i],
                _allVotesByIndexInst[voteIndex].voterReputation,
                voteFor
            );

            _modifyExposedVote(msg.sender, claimIndex, suggestedClaimAmounts[i], voteFor);

            emit VoteExposed(claimIndex, msg.sender, suggestedClaimAmounts[i]);
        }
    }

    function _getRewardRatio(
        uint256 claimIndex,
        address voter,
        uint256 votedStakedStkBMIAmountWithReputation
    ) internal view returns (uint256) {
        if (votedStakedStkBMIAmountWithReputation < 0) return 0;

        uint256 voteIndex = _allVotesToIndex[voter][claimIndex];

        uint256 voterBMI = _allVotesByIndexInst[voteIndex].stakedStkBMIAmount;
        uint256 voterReputation = _allVotesByIndexInst[voteIndex].voterReputation;

        return
            voterBMI.mul(voterReputation).mul(PERCENTAGE_100).div(
                votedStakedStkBMIAmountWithReputation
            );
    }

    function _calculateMajorityYesVote(
        uint256 claimIndex,
        address voter,
        uint256 oldReputation
    )
        internal
        view
        returns (
            uint256 _stblAmount,
            uint256 _bmiAmount,
            uint256 _newReputation
        )
    {
        VotingResult storage info = _votings[claimIndex];

        uint256 voterRatio =
            _getRewardRatio(claimIndex, voter, info.votedYesStakedStkBMIAmountWithReputation);

        if (claimingRegistry.claimStatus(claimIndex) == IClaimingRegistry.ClaimStatus.ACCEPTED) {
            // calculate STBL reward tokens sent to the voter (from reinsurance)
            _stblAmount = info.reinsuranceTokensAmount.mul(voterRatio).div(PERCENTAGE_100);
        } else {
            // calculate BMI reward tokens sent to the voter (from 1% locked)
            _bmiAmount = info.lockedBMIAmount.mul(voterRatio).div(PERCENTAGE_100);
        }

        _newReputation = reputationSystem.getNewReputation(oldReputation, info.votedYesPercentage);
    }

    function _calculateMajorityNoVote(
        uint256 claimIndex,
        address voter,
        uint256 oldReputation
    ) internal view returns (uint256 _bmiAmount, uint256 _newReputation) {
        VotingResult storage info = _votings[claimIndex];

        uint256 voterRatio =
            _getRewardRatio(claimIndex, voter, info.votedNoStakedStkBMIAmountWithReputation);

        // calculate BMI reward tokens sent to the voter (from 1% locked)
        _bmiAmount = info.lockedBMIAmount.mul(voterRatio).div(PERCENTAGE_100);

        _newReputation = reputationSystem.getNewReputation(
            oldReputation,
            PERCENTAGE_100.sub(info.votedYesPercentage)
        );
    }

    function _calculateMinorityVote(
        uint256 claimIndex,
        address voter,
        uint256 oldReputation
    ) internal view returns (uint256 _bmiPenalty, uint256 _newReputation) {
        uint256 minorityPercentageWithPrecision =
            Math.min(
                _votings[claimIndex].votedYesPercentage,
                PERCENTAGE_100.sub(_votings[claimIndex].votedYesPercentage)
            );

        if (minorityPercentageWithPrecision < PENALTY_THRESHOLD) {
            // calculate confiscated staked stkBMI tokens sent to reinsurance pool
            _bmiPenalty = Math.min(
                stkBMIStaking.stakedStkBMI(voter),
                _allVotesByIndexInst[_allVotesToIndex[voter][claimIndex]]
                    .stakedStkBMIAmount
                    .mul(PENALTY_THRESHOLD.sub(minorityPercentageWithPrecision))
                    .div(PERCENTAGE_100)
            );
        }

        _newReputation = reputationSystem.getNewReputation(
            oldReputation,
            minorityPercentageWithPrecision
        );
    }

    function _calculateVoteResult(uint256 claimIndex) internal {
        for (uint256 i = 0; i < _votings[claimIndex].voteIndexes.length(); i++) {
            uint256 voteIndex = _votings[claimIndex].voteIndexes.at(i);
            address voter = _allVotesByIndexInst[voteIndex].voter;
            uint256 oldReputation = reputationSystem.reputation(voter);

            require(_allVotesIndexes.contains(voteIndex), "CV: Vote doesn't exist");

            uint256 stblAmount;
            uint256 bmiAmount;
            uint256 bmiPenaltyAmount;
            uint256 newReputation;
            VoteStatus status;

            if (_isVoteAwaitingExposure(voteIndex)) {
                bmiPenaltyAmount = _allVotesByIndexInst[_allVotesToIndex[voter][claimIndex]]
                    .stakedStkBMIAmount;
                voteResults[voteIndex].stakeChange = int256(bmiPenaltyAmount);
            } else if (
                _votings[claimIndex].votedYesPercentage >= PERCENTAGE_50 &&
                _allVotesByIndexInst[voteIndex].suggestedAmount > 0
            ) {
                (stblAmount, bmiAmount, newReputation) = _calculateMajorityYesVote(
                    claimIndex,
                    voter,
                    oldReputation
                );

                voteResults[voteIndex].stblReward = stblAmount;

                status = VoteStatus.MAJORITY;
            } else if (
                _votings[claimIndex].votedYesPercentage < PERCENTAGE_50 &&
                _allVotesByIndexInst[voteIndex].suggestedAmount == 0
            ) {
                (bmiAmount, newReputation) = _calculateMajorityNoVote(
                    claimIndex,
                    voter,
                    oldReputation
                );
                status = VoteStatus.MAJORITY;
            } else {
                (bmiPenaltyAmount, newReputation) = _calculateMinorityVote(
                    claimIndex,
                    voter,
                    oldReputation
                );
                voteResults[voteIndex].stakeChange = int256(bmiPenaltyAmount);

                status = VoteStatus.MINORITY;
            }

            _allVotesByIndexInst[voteIndex].status = status;
            voteResults[voteIndex].reputationChange = int256(newReputation);
            voteResults[voteIndex].bmiReward = bmiAmount;

            _myNotReceivedVotes[voter].add(claimIndex);

            emit VoteCalculated(claimIndex, voter, status);
        }
    }

    function _getBMIRewardForCalculation(uint256 claimIndex) internal view returns (uint256) {
        uint256 lockedBMIs = _votings[claimIndex].lockedBMIAmount;
        uint256 timeElapsed =
            claimingRegistry.claimSubmittedTime(claimIndex).add(
                claimingRegistry.anyoneCanCalculateClaimResultAfter(claimIndex)
            );

        if (claimingRegistry.canClaimBeCalculatedByAnyone(claimIndex)) {
            timeElapsed = block.timestamp.sub(timeElapsed);
        } else {
            timeElapsed = timeElapsed.sub(block.timestamp);
        }

        return
            Math.min(
                lockedBMIs,
                lockedBMIs.mul(timeElapsed.mul(CALCULATION_REWARD_PER_DAY.div(1 days))).div(
                    PERCENTAGE_100
                )
            );
    }

    function _sendRewardsForCalculationTo(uint256 claimIndex, address calculator) internal {
        uint256 reward = _getBMIRewardForCalculation(claimIndex);

        _votings[claimIndex].lockedBMIAmount = _votings[claimIndex].lockedBMIAmount.sub(reward);

        bmiToken.transfer(calculator, reward);

        emit RewardsForClaimCalculationSent(calculator, reward);
    }

    function calculateResult(uint256 claimIndex) external override {
        // TODO invert order condition to prevent duplicate storage hits
        require(
            claimingRegistry.canClaimBeCalculatedByAnyone(claimIndex) ||
                claimingRegistry.claimOwner(claimIndex) == msg.sender,
            "CV: Not allowed to calculate"
        );
        _sendRewardsForCalculationTo(claimIndex, msg.sender);

        if (claimingRegistry.claimStatus(claimIndex) == IClaimingRegistry.ClaimStatus.EXPIRED) {
            claimingRegistry.expireClaim(claimIndex);
        } else {
            // claim existence is checked in claimStatus function
            require(
                claimingRegistry.claimStatus(claimIndex) ==
                    IClaimingRegistry.ClaimStatus.AWAITING_CALCULATION,
                "CV: Claim is not awaiting"
            );

            _resolveClaim(claimIndex);
            _calculateVoteResult(claimIndex);
        }
    }

    function _resolveClaim(uint256 claimIndex) internal {
        uint256 totalStakedStkBMI = stkBMIStaking.totalStakedStkBMI();

        uint256 allVotedStakedStkBMI = _votings[claimIndex].allVotedStakedStkBMIAmount;

        // if no votes or not an appeal and voted < 10% supply of staked StkBMI
        if (
            allVotedStakedStkBMI == 0 ||
            ((totalStakedStkBMI == 0 ||
                totalStakedStkBMI.mul(QUORUM).div(PERCENTAGE_100) > allVotedStakedStkBMI) &&
                !claimingRegistry.isClaimAppeal(claimIndex))
        ) {
            // reject & use locked BMI for rewards
            claimingRegistry.rejectClaim(claimIndex);
        } else {
            uint256 votedYesPower = _votings[claimIndex].votedYesStakedStkBMIAmountWithReputation;
            uint256 votedNoPower = _votings[claimIndex].votedNoStakedStkBMIAmountWithReputation;
            uint256 totalPower = votedYesPower.add(votedNoPower);
            if (totalPower > 0) {
                _votings[claimIndex].votedYesPercentage = votedYesPower.mul(PERCENTAGE_100).div(
                    totalPower
                );
            }

            if (_votings[claimIndex].votedYesPercentage >= APPROVAL_PERCENTAGE) {
                // approve + send STBL & return locked BMI to the claimer
                claimingRegistry.acceptClaim(
                    claimIndex,
                    _votings[claimIndex].votedAverageWithdrawalAmount
                );
            } else {
                // reject & use locked BMI for rewards
                claimingRegistry.rejectClaim(claimIndex);
            }
        }
        emit ClaimCalculated(claimIndex, msg.sender);
    }

    function receiveResult() external override {
        uint256 notReceivedLength = _myNotReceivedVotes[msg.sender].length();
        uint256 oldReputation = reputationSystem.reputation(msg.sender);

        (uint256 rewardAmount, ) = claimingRegistry.rewardWithdrawalInfo(msg.sender);

        uint256 stblAmount = rewardAmount;
        uint256 bmiAmount;
        int256 bmiPenaltyAmount;
        uint256 newReputation = oldReputation;

        for (uint256 i = 0; i < notReceivedLength; i++) {
            uint256 claimIndex = _myNotReceivedVotes[msg.sender].at(i);
            uint256 voteIndex = _allVotesToIndex[msg.sender][claimIndex];
            stblAmount = stblAmount.add(voteResults[voteIndex].stblReward);
            bmiAmount = bmiAmount.add(voteResults[voteIndex].bmiReward);
            bmiPenaltyAmount += voteResults[voteIndex].stakeChange;
            if (uint256(voteResults[voteIndex].reputationChange) > oldReputation) {
                newReputation = newReputation.add(
                    uint256(voteResults[voteIndex].reputationChange).sub(oldReputation)
                );
            } else if (uint256(voteResults[voteIndex].reputationChange) < oldReputation) {
                newReputation = newReputation.sub(
                    oldReputation.sub(uint256(voteResults[voteIndex].reputationChange))
                );
            }
            _allVotesByIndexInst[voteIndex].status = VoteStatus.RECEIVED;
        }
        if (stblAmount > 0) {
            claimingRegistry.requestRewardWithdrawal(msg.sender, stblAmount);
        }
        if (bmiAmount > 0) {
            bmiToken.transfer(msg.sender, bmiAmount);
        }
        if (bmiPenaltyAmount > 0) {
            stkBMIStaking.slashUserTokens(msg.sender, uint256(bmiPenaltyAmount));
        }
        reputationSystem.setNewReputation(msg.sender, newReputation);

        delete _myNotReceivedVotes[msg.sender];

        emit RewardsForVoteCalculationSent(msg.sender, bmiAmount);
    }

    function transferLockedBMI(uint256 claimIndex, address claimer)
        external
        override
        onlyClaimingRegistry
    {
        uint256 lockedAmount = _votings[claimIndex].lockedBMIAmount;
        require(lockedAmount > 0, "CV: Already withdrawn");
        _votings[claimIndex].lockedBMIAmount = 0;
        bmiToken.transfer(claimer, lockedAmount);
    }
}
