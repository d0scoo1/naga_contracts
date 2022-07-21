// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/IERC20MetadataUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/ClonesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeCastUpgradeable.sol";
import "./interfaces/IPoolMaster.sol";
import "./interfaces/IFlashGovernor.sol";
import "./interfaces/IMembershipStaking.sol";
import "./libraries/Decimal.sol";

contract PoolFactory is OwnableUpgradeable {
    using SafeERC20Upgradeable for IERC20Upgradeable;
    using ClonesUpgradeable for address;
    using SafeCastUpgradeable for uint256;
    using Decimal for uint256;

    /// @notice CPOOL token contract
    IERC20Upgradeable public cpool;

    /// @notice MembershipStaking contract
    IMembershipStaking public staking;

    /// @notice FlashGovernor contract
    IFlashGovernor public flashGovernor;

    /// @notice Pool master contract
    address public poolMaster;

    /// @notice Interest Rate Model contract address
    address public interestRateModel;

    /// @notice Address of the auction contract
    address public auction;

    /// @notice Address of the treasury
    address public treasury;

    /// @notice Reserve factor as 18-digit decimal
    uint256 public reserveFactor;

    /// @notice Insurance factor as 18-digit decimal
    uint256 public insuranceFactor;

    /// @notice Pool utilization that leads to warning state (as 18-digit decimal)
    uint256 public warningUtilization;

    /// @notice Pool utilization that leads to provisional default (as 18-digit decimal)
    uint256 public provisionalDefaultUtilization;

    /// @notice Grace period for warning state before pool goes to default (in seconds)
    uint256 public warningGracePeriod;

    /// @notice Max period for which pool can stay not active before it can be closed by governor (in seconds)
    uint256 public maxInactivePeriod;

    /// @notice Period after default to start auction after which pool can be closed by anyone (in seconds)
    uint256 public periodToStartAuction;

    /// @notice Allowance of different currencies in protocol
    mapping(address => bool) public currencyAllowed;

    struct ManagerInfo {
        address currency;
        address pool;
        address staker;
        uint32 proposalId;
        uint256 stakedAmount;
        bytes32 ipfsHash;
        string managerSymbol;
    }

    /// @notice Mapping of manager addresses to their pool info
    mapping(address => ManagerInfo) public managerInfo;

    /// @notice Mapping of manager symbols to flags if they are already used
    mapping(string => bool) public usedManagerSymbols;

    /// @notice Mapping of addresses to flags indicating if they are pools
    mapping(address => bool) public isPool;

    // EVENTS

    /// @notice Event emitted when new pool is proposed
    event PoolProposed(address indexed manager, address indexed currency);

    /// @notice Event emitted when proposed pool is cancelled
    event PoolCancelled(address indexed manager, address indexed currency);

    /// @notice Event emitted when new pool is created
    event PoolCreated(
        address indexed pool,
        address indexed manager,
        address indexed currency,
        bool forceCreated
    );

    /// @notice Event emitted when pool is closed
    event PoolClosed(
        address indexed pool,
        address indexed manager,
        address indexed currency
    );

    /// @notice Event emitted when status of the currency is set
    event CurrencySet(address currency, bool allowed);

    /// @notice Event emitted when new pool master is set
    event PoolMasterSet(address newPoolMaster);

    /// @notice Event emitted when new interest rate model is set
    event InterestRateModelSet(address newModel);

    /// @notice Event emitted when new treasury is set
    event TreasurySet(address newTreasury);

    /// @notice Event emitted when new reserve factor is set
    event ReserveFactorSet(uint256 factor);

    /// @notice Event emitted when new insurance factor is set
    event InsuranceFactorSet(uint256 factor);

    /// @notice Event emitted when new warning utilization is set
    event WarningUtilizationSet(uint256 utilization);

    /// @notice Event emitted when new provisional default utilization is set
    event ProvisionalDefaultUtilizationSet(uint256 utilization);

    /// @notice Event emitted when new warning grace period is set
    event WarningGracePeriodSet(uint256 period);

    /// @notice Event emitted when new max inactive period is set
    event MaxInactivePeriodSet(uint256 period);

    /// @notice Event emitted when new period to start auction is set
    event PeriodToStartAuctionSet(uint256 period);

    /// @notice Event emitted when new reward per block is set for some pool
    event PoolRewardPerBlockSet(address indexed pool, uint256 rewardPerBlock);

    // CONSTRUCTOR

    /**
     * @notice Upgradeable contract constructor
     * @param cpool_ The address of the CPOOL contract
     * @param staking_ The address of the Staking contract
     * @param flashGovernor_ The address of the FlashGovernor contract
     * @param poolMaster_ The address of the PoolMaster contract
     * @param interestRateModel_ The address of the InterestRateModel contract
     * @param auction_ The address of the Auction contract
     */
    function initialize(
        IERC20Upgradeable cpool_,
        IMembershipStaking staking_,
        IFlashGovernor flashGovernor_,
        address poolMaster_,
        address interestRateModel_,
        address auction_
    ) external initializer {
        require(address(cpool_) != address(0), "AIZ");
        require(address(staking_) != address(0), "AIZ");
        require(address(flashGovernor_) != address(0), "AIZ");
        require(poolMaster_ != address(0), "AIZ");
        require(interestRateModel_ != address(0), "AIZ");
        require(auction_ != address(0), "AIZ");

        __Ownable_init();

        cpool = cpool_;
        staking = staking_;
        flashGovernor = flashGovernor_;
        poolMaster = poolMaster_;
        interestRateModel = interestRateModel_;
        auction = auction_;
    }

    /* PUBLIC FUNCTIONS */

    /**
     * @notice Function used to propose new pool for the first time (with manager's info)
     * @param currency Address of the ERC20 token that would act as currnecy in the pool
     * @param ipfsHash IPFS hash of the manager's info
     * @param managerSymbol Manager's symbol
     */
    function proposePoolInitial(
        address currency,
        bytes32 ipfsHash,
        string memory managerSymbol
    ) external {
        _setManager(msg.sender, ipfsHash, managerSymbol);
        _proposePool(currency);
    }

    /**
     * @notice Function used to propose new pool (when manager's info already exist)
     * @param currency Address of the ERC20 token that would act as currnecy in the pool
     */
    function proposePool(address currency) external {
        require(managerInfo[msg.sender].ipfsHash != bytes32(0), "MHI");

        _proposePool(currency);
    }

    /**
     * @notice Function used to create proposed and approved pool
     */
    function createPool() external {
        ManagerInfo storage info = managerInfo[msg.sender];
        flashGovernor.execute(info.proposalId);
        IPoolMaster pool = IPoolMaster(poolMaster.clone());
        pool.initialize(msg.sender, info.currency);
        info.pool = address(pool);
        isPool[address(pool)] = true;

        emit PoolCreated(address(pool), msg.sender, info.currency, false);
    }

    /**
     * @notice Function used to cancel proposed but not yet created pool
     */
    function cancelPool() external {
        ManagerInfo storage info = managerInfo[msg.sender];
        require(info.proposalId != 0 && info.pool == address(0), "NPP");

        emit PoolCancelled(msg.sender, info.currency);

        info.currency = address(0);
        info.proposalId = 0;
        staking.unlockStake(info.staker, info.stakedAmount);
    }

    // RESTRICTED FUNCTIONS

    /**
     * @notice Function used to immedeately create new pool for some manager for the first time
     * @notice Skips approval, restricted to owner
     * @param manager Manager to create pool for
     * @param currency Address of the ERC20 token that would act as currnecy in the pool
     * @param ipfsHash IPFS hash of the manager's info
     * @param managerSymbol Manager's symbol
     */
    function forceCreatePoolInitial(
        address manager,
        address currency,
        bytes32 ipfsHash,
        string memory managerSymbol
    ) external onlyOwner {
        _setManager(manager, ipfsHash, managerSymbol);

        _forceCreatePool(manager, currency);
    }

    /**
     * @notice Function used to immediately create new pool for some manager (when info already exist)
     * @notice Skips approval, restricted to owner
     * @param manager Manager to create pool for
     * @param currency Address of the ERC20 token that would act as currnecy in the pool
     */
    function forceCreatePool(address manager, address currency)
        external
        onlyOwner
    {
        require(managerInfo[manager].ipfsHash != bytes32(0), "MHI");

        _forceCreatePool(manager, currency);
    }

    /**
     * @notice Function is called by contract owner to update currency allowance in the protocol
     * @param currency Address of the ERC20 token
     * @param allowed Should currency be allowed or forbidden
     */
    function setCurrency(address currency, bool allowed) external onlyOwner {
        currencyAllowed[currency] = allowed;
        emit CurrencySet(currency, allowed);
    }

    /**
     * @notice Function is called by contract owner to set new PoolMaster
     * @param poolMaster_ Address of the new PoolMaster contract
     */
    function setPoolMaster(address poolMaster_) external onlyOwner {
        require(poolMaster_ != address(0), "AIZ");
        poolMaster = poolMaster_;
        emit PoolMasterSet(poolMaster_);
    }

    /**
     * @notice Function is called by contract owner to set new InterestRateModel
     * @param interestRateModel_ Address of the new InterestRateModel contract
     */
    function setInterestRateModel(address interestRateModel_)
        external
        onlyOwner
    {
        require(interestRateModel_ != address(0), "AIZ");
        interestRateModel = interestRateModel_;
        emit InterestRateModelSet(interestRateModel_);
    }

    /**
     * @notice Function is called by contract owner to set new treasury
     * @param treasury_ Address of the new treasury
     */
    function setTreasury(address treasury_) external onlyOwner {
        require(treasury_ != address(0), "AIZ");
        treasury = treasury_;
        emit TreasurySet(treasury_);
    }

    /**
     * @notice Function is called by contract owner to set new reserve factor
     * @param reserveFactor_ New reserve factor as 18-digit decimal
     */
    function setReserveFactor(uint256 reserveFactor_) external onlyOwner {
        require(reserveFactor_ <= Decimal.ONE, "GTO");
        reserveFactor = reserveFactor_;
        emit ReserveFactorSet(reserveFactor_);
    }

    /**
     * @notice Function is called by contract owner to set new insurance factor
     * @param insuranceFactor_ New reserve factor as 18-digit decimal
     */
    function setInsuranceFactor(uint256 insuranceFactor_) external onlyOwner {
        require(insuranceFactor_ <= Decimal.ONE, "GTO");
        insuranceFactor = insuranceFactor_;
        emit InsuranceFactorSet(insuranceFactor_);
    }

    /**
     * @notice Function is called by contract owner to set new warning utilization
     * @param warningUtilization_ New warning utilization as 18-digit decimal
     */
    function setWarningUtilization(uint256 warningUtilization_)
        external
        onlyOwner
    {
        require(warningUtilization_ <= Decimal.ONE, "GTO");
        warningUtilization = warningUtilization_;
        emit WarningUtilizationSet(warningUtilization_);
    }

    /**
     * @notice Function is called by contract owner to set new provisional default utilization
     * @param provisionalDefaultUtilization_ New provisional default utilization as 18-digit decimal
     */
    function setProvisionalDefaultUtilization(
        uint256 provisionalDefaultUtilization_
    ) external onlyOwner {
        require(provisionalDefaultUtilization_ <= Decimal.ONE, "GTO");
        provisionalDefaultUtilization = provisionalDefaultUtilization_;
        emit ProvisionalDefaultUtilizationSet(provisionalDefaultUtilization_);
    }

    /**
     * @notice Function is called by contract owner to set new warning grace period
     * @param warningGracePeriod_ New warning grace period in seconds
     */
    function setWarningGracePeriod(uint256 warningGracePeriod_)
        external
        onlyOwner
    {
        warningGracePeriod = warningGracePeriod_;
        emit WarningGracePeriodSet(warningGracePeriod_);
    }

    /**
     * @notice Function is called by contract owner to set new max inactive period
     * @param maxInactivePeriod_ New max inactive period in seconds
     */
    function setMaxInactivePeriod(uint256 maxInactivePeriod_)
        external
        onlyOwner
    {
        maxInactivePeriod = maxInactivePeriod_;
        emit MaxInactivePeriodSet(maxInactivePeriod_);
    }

    /**
     * @notice Function is called by contract owner to set new period to start auction
     * @param periodToStartAuction_ New period to start auction
     */
    function setPeriodToStartAuction(uint256 periodToStartAuction_)
        external
        onlyOwner
    {
        periodToStartAuction = periodToStartAuction_;
        emit PeriodToStartAuctionSet(periodToStartAuction_);
    }

    /**
     * @notice Function is called by contract owner to set new CPOOl reward per block speed in some pool
     * @param pool Pool where to set reward
     * @param rewardPerBlock Reward per block value
     */
    function setPoolRewardPerBlock(address pool, uint256 rewardPerBlock)
        external
        onlyOwner
    {
        IPoolMaster(pool).setRewardPerBlock(rewardPerBlock);
        emit PoolRewardPerBlockSet(pool, rewardPerBlock);
    }

    /**
     * @notice Function is called through pool at closing to unlock manager's stake
     */
    function closePool() external {
        require(isPool[msg.sender], "SNP");
        address manager = IPoolMaster(msg.sender).manager();
        ManagerInfo storage info = managerInfo[manager];

        address currency = info.currency;
        info.currency = address(0);
        info.pool = address(0);
        staking.unlockStake(info.staker, info.stakedAmount);

        emit PoolClosed(msg.sender, manager, currency);
    }

    /**
     * @notice Function is called through pool to burn manager's stake when auction starts
     */
    function burnStake() external {
        require(isPool[msg.sender], "SNP");
        ManagerInfo storage info = managerInfo[
            IPoolMaster(msg.sender).manager()
        ];

        staking.burnStake(info.staker, info.stakedAmount);
        info.staker = address(0);
        info.stakedAmount = 0;
    }

    /**
     * @notice Function is used to withdraw CPOOL rewards from multiple pools
     * @param pools List of pools to withdrawm from
     */
    function withdrawReward(address[] memory pools) external {
        uint256 totalReward;
        for (uint256 i = 0; i < pools.length; i++) {
            require(isPool[pools[i]], "NPA");
            totalReward += IPoolMaster(pools[i]).withdrawReward(msg.sender);
        }

        if (totalReward > 0) {
            cpool.safeTransfer(msg.sender, totalReward);
        }
    }

    // VIEW FUNCTIONS

    /**
     * @notice Function returns symbol for new pool based on currency and manager
     * @param currency Pool's currency address
     * @param manager Manager's address
     * @return Pool symbol
     */
    function getPoolSymbol(address currency, address manager)
        external
        view
        returns (string memory)
    {
        return
            string(
                bytes.concat(
                    bytes("cp"),
                    bytes(managerInfo[manager].managerSymbol),
                    bytes("-"),
                    bytes(IERC20MetadataUpgradeable(currency).symbol())
                )
            );
    }

    // INTERNAL FUNCTIONS

    /**
     * @notice Internal function that proposes pool
     * @param currency Currency of the pool
     */
    function _proposePool(address currency) private {
        require(currencyAllowed[currency], "CNA");
        ManagerInfo storage info = managerInfo[msg.sender];
        require(info.currency == address(0), "AHP");

        info.proposalId = flashGovernor.propose();
        info.currency = currency;
        info.staker = msg.sender;
        info.stakedAmount = staking.lockStake(msg.sender);

        emit PoolProposed(msg.sender, currency);
    }

    /**
     * @notice Internal function that immedeately creates pool
     * @param manager Manager of the pool
     * @param currency Currency of the pool
     */
    function _forceCreatePool(address manager, address currency) private {
        require(currencyAllowed[currency], "CNA");
        ManagerInfo storage info = managerInfo[manager];
        require(info.currency == address(0), "AHP");

        IPoolMaster pool = IPoolMaster(poolMaster.clone());
        pool.initialize(manager, currency);

        info.pool = address(pool);
        info.currency = currency;
        info.staker = msg.sender;
        info.stakedAmount = staking.lockStake(msg.sender);

        isPool[address(pool)] = true;

        emit PoolCreated(address(pool), manager, currency, true);
    }

    /**
     * @notice Internal function that sets manager's info
     * @param manager Manager to set info for
     * @param info Manager's info IPFS hash
     * @param symbol Manager's symbol
     */
    function _setManager(
        address manager,
        bytes32 info,
        string memory symbol
    ) private {
        require(managerInfo[manager].ipfsHash == bytes32(0), "AHI");
        require(info != bytes32(0), "CEI");
        require(!usedManagerSymbols[symbol], "SAU");

        managerInfo[manager].ipfsHash = info;
        managerInfo[manager].managerSymbol = symbol;
        usedManagerSymbols[symbol] = true;
    }
}
