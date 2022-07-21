// SPDX-License-Identifier: MIT
pragma solidity >=0.8.12 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

// The NFT that can be staked here.
interface IPPADealers {
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function ownerOf(uint256 tokenId) external view returns (address);
}

interface IPPASurrealestateStaking {
    struct SurrealestateStakingAccountInfo {
        uint256 numStaked;
    }

    function accounts(address)
        external
        view
        returns (SurrealestateStakingAccountInfo calldata);
}

// A listening contract can implement this function to get notified any time a user stakes or unstakes.
interface IStakingListener {
    function notifyChange(address account) external;
}

contract DealerStaking is ERC721Holder, Ownable {
    IPPADealers dealers;
    address public dealerContractAddress;
    IPPASurrealestateStaking surrealestateStaking;
    address public surrealestateStakingAddress;

    constructor() {
        _setContractAddresses();
    }

    function _setContractAddresses() internal {
        address _dealers;
        address _surreals;
        assembly {
            switch chainid()
            case 1 {
                // mainnet
                _dealers := 0x99120d128a5f7cb81c318a24fa1f60f66d9777d7
                _surreals := 0x3bc4af76990a1e64fed1a22ab72242e7cd2d40d9
            }
            case 4 {
                // rinkeby
                _dealers := 0x7551dc208fdb308c52a27cae25e9ba8e76ef2733
                _surreals := 0x053D12507c7bE738fb6be8403Fe4b5aa610F2e50
            }
        }
        dealerContractAddress = _dealers;
        surrealestateStakingAddress = _surreals;
        dealers = IPPADealers(dealerContractAddress);
        surrealestateStaking = IPPASurrealestateStaking(
            surrealestateStakingAddress
        );
    }

    // This is equivalent to the pointsByTokenId() function for the SurrealestatesStaking.
    uint256 public pointsPerDealer = 200;

    // The period which people can lock their funds up for to get an extra multiplier on rewards earned.
    uint256 stakingLockPeriod = 7776000; // 90 days in seconds.

    struct StakingMultiplier {
        uint256 numeratorMinus1; // Store as "minus 1" because we want this to default to 1, but uninitialized vars default to 0.
        uint256 denominatorMinus1;
    }

    struct AccountInfo {
        uint256 numStaked;
        uint256 pointsStaked;
        uint256 lastRefreshTimestamp;
        uint256 tokensEarnedBeforeLastRefresh;
        // A multiplier defaults to 1 but can be set by a manager in the future for a particular address. This increases
        // the overall rate of earning.
        StakingMultiplier stakingMultiplier;
    }
    mapping(address => AccountInfo) public accounts;

    struct TokenInfo {
        bool isLocked;
        uint256 lockedUntil;
        address owner;
    }
    mapping(uint256 => TokenInfo) public tokens;

    // Addresses that are allowed to do things like deduct tokens from a user's account or award earning multipliers.
    mapping(address => bool) public approvedManagers;

    IStakingListener[] listeners;

    // Earning period for a dealer. Default to 10 hours.
    uint256 public earnPeriodSeconds = 36000;

    modifier onlyApprovedManager() {
        require(
            owner() == msg.sender || approvedManagers[msg.sender],
            "Caller is not an approved manager"
        );
        _;
    }

    function _notifyAllListeners(address account) internal {
        for (uint256 i = 0; i < listeners.length; i++) {
            listeners[i].notifyChange(account);
        }
    }

    function numSurrealestatesStaked(address addr) public view returns (uint256) {
        return surrealestateStaking.accounts(addr).numStaked;
    }

    /** User must setApprovalForAll on the contract before staking. */
    function stake(uint256[] calldata tokenIds, bool lock) public {
        refreshTokensEarned(msg.sender);
        require(
            numSurrealestatesStaked(msg.sender) >=
                tokenIds.length + accounts[msg.sender].numStaked,
            "Cannot stake more Dealers than you have Surrealestates staked"
        );
        for (uint256 i = 0; i < tokenIds.length; i++) {
            require(
                dealers.ownerOf(tokenIds[i]) == msg.sender,
                "Not your token"
            );

            dealers.transferFrom(msg.sender, address(this), tokenIds[i]);
            tokens[tokenIds[i]].owner = msg.sender;
            accounts[msg.sender].pointsStaked += pointsPerDealer;
        }
        accounts[msg.sender].numStaked += tokenIds.length;

        if (lock) {
            uint256 lockUntil = block.timestamp + stakingLockPeriod;
            for (uint256 i = 0; i < tokenIds.length; i++) {
                tokens[tokenIds[i]].lockedUntil = lockUntil;
                tokens[tokenIds[i]].isLocked = true;
                accounts[msg.sender].pointsStaked += pointsPerDealer;
            }
        }

        _notifyAllListeners(msg.sender);
    }

    /**
     * User can lock their staking in for the stakingLockPeriod, which increases their multiplier.
     */
    function lockStaking(uint256[] calldata tokenIds) public {
        refreshTokensEarned(msg.sender);
        uint256 lockUntil = block.timestamp + stakingLockPeriod;
        for (uint256 i = 0; i < tokenIds.length; i++) {
            require(
                tokens[tokenIds[i]].owner == msg.sender,
                "Token is not currently staked"
            );
            require(
                tokens[tokenIds[i]].lockedUntil < block.timestamp,
                "Token is already locked"
            );
            if (!tokens[tokenIds[i]].isLocked) {
                tokens[tokenIds[i]].isLocked = true;
                accounts[msg.sender].pointsStaked += pointsPerDealer;
            }
            tokens[tokenIds[i]].lockedUntil = lockUntil;
        }
        _notifyAllListeners(msg.sender);
    }

    function refreshTokensEarned(address addr) internal {
        if (block.timestamp == accounts[addr].lastRefreshTimestamp) {
            // No need to refresh anything if we're up to date.
            return;
        }
        if (accounts[addr].lastRefreshTimestamp == 0) {
            // If this is the first refresh ever done, then just set the timestamp and return.
            accounts[addr].lastRefreshTimestamp = block.timestamp;
            return;
        }

        uint256 totalTokensEarned = calculateTokensEarned(addr);
        accounts[addr].tokensEarnedBeforeLastRefresh = totalTokensEarned;
        accounts[addr].lastRefreshTimestamp = block.timestamp;
    }

    function calculateTokensEarned(address addr) public view returns (uint256) {
        uint256 secondsStakedSinceLastRefresh = block.timestamp -
            accounts[addr].lastRefreshTimestamp;

        uint256 tokensEarnedSinceLastRefresh = (secondsStakedSinceLastRefresh *
            (accounts[addr].pointsStaked) *
            (accounts[addr].stakingMultiplier.numeratorMinus1 + 1)) /
            (accounts[addr].stakingMultiplier.denominatorMinus1 + 1) /
            earnPeriodSeconds;
        return
            accounts[addr].tokensEarnedBeforeLastRefresh +
            tokensEarnedSinceLastRefresh;
    }

    /**
     * To unstake, the user calls this function with the tokenIds they want to unstake.
     */
    function unstake(uint256[] calldata tokenIds) public {
        refreshTokensEarned(msg.sender);

        for (uint256 i = 0; i < tokenIds.length; i++) {
            require(
                tokens[tokenIds[i]].owner == msg.sender,
                "Caller is not currently staking the provided tokenId"
            );
            _unstakeSingle(tokenIds[i]);
        }
        accounts[msg.sender].numStaked -= tokenIds.length;
        _notifyAllListeners(msg.sender);
    }

    // Caller is responsible for deducted accounts[addr].numStaked
    function _unstakeSingle(uint256 tokenId) internal {
        require(
            tokens[tokenId].lockedUntil < block.timestamp,
            "Token is still locked"
        );
        accounts[tokens[tokenId].owner].pointsStaked -= pointsPerDealer;

        // If we are past the token locktime, then we need to update the the lockedTokens map as well.
        if (tokens[tokenId].isLocked) {
            tokens[tokenId].isLocked = false;
            // Deduct again because it was locked, so it was earning double.
            accounts[tokens[tokenId].owner].pointsStaked -= pointsPerDealer;
        }

        dealers.transferFrom(address(this), msg.sender, tokenId);

        tokens[tokenId].owner = address(0);
    }

    function addApprovedManager(address managerAddr) public onlyOwner {
        approvedManagers[managerAddr] = true;
    }

    function removeApprovedManager(address managerAddr) public onlyOwner {
        approvedManagers[managerAddr] = false;
    }

    function setStakingLockPeriod(uint256 newPeriod)
        public
        onlyApprovedManager
    {
        stakingLockPeriod = newPeriod;
    }

    function setEarnPeriod(uint256 newSeconds) public onlyApprovedManager {
        earnPeriodSeconds = newSeconds;
    }

    function setEarningMultiplier(
        address addr,
        uint256 numerator,
        uint256 denominator
    ) public onlyApprovedManager {
        refreshTokensEarned(addr);
        accounts[addr].stakingMultiplier = StakingMultiplier(
            numerator - 1,
            denominator - 1
        );
    }

    function addStakingListener(address contractAddress) public onlyOwner {
        listeners.push(IStakingListener(contractAddress));
    }

    function resetStakingListeners() public onlyOwner {
        delete listeners;
    }

    // Do not use in actual transaction due to massive gas cost.
    function stakedTokensOfOwner(
        address addr,
        uint256 start,
        uint256 stop
    ) public view returns (uint256[] memory) {
        if (accounts[addr].numStaked == 0) {
            return new uint256[](0);
        }

        uint256 index = 0;
        uint256[] memory ownedTokens = new uint256[](accounts[addr].numStaked);

        for (uint256 tokenId = start; tokenId <= stop; tokenId++) {
            if (tokens[tokenId].owner == addr) {
                ownedTokens[index] = tokenId;
                index++;
                if (index == accounts[addr].numStaked) {
                    break;
                }
            }
        }

        return ownedTokens;
    }

    function setDealerContractAddress(address addr) public onlyOwner {
        dealerContractAddress = addr;
        dealers = IPPADealers(addr);
    }

    // Only for use in emergency. Can be called by owner to unstake. Does not update the rest of the contract state.
    function unstakeAsOwner(address addr, uint256[] calldata tokenIds)
        public
        onlyOwner
    {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            dealers.transferFrom(address(this), addr, tokenIds[i]);
        }
    }
}
