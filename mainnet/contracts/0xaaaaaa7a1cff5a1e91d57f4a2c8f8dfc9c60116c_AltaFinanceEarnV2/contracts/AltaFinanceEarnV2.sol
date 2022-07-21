//SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "./EarnBase.sol";

/// @title Alta Finance EarnV2
/// @author Alta Finance Team
/// @notice This contract is a lending protocol where consumers lend crypto assets and earn stable yields secured by real estate.
contract AltaFinanceEarnV2 is EarnBase {
    /// ALTA token
    IERC20Metadata public ALTA;

    /// Address of wallet to receive funds
    address public feeAddress;

    /// Percent of offer amount transferred to Alta Finance as a service fee (100 = 10%)
    uint256 public transferFee; // 100 = 10%

    /// amount of alta to stake to reach tier 1
    uint256 public tier1Amount;
    /// amount of alta to stake to reach tier 2
    uint256 public tier2Amount;

    /// multiplier for contracts that reach tier 1
    uint256 public immutable tier1Multiplier = 1150; // 1150 = 1.15x
    /// multiplier for contracts that reach tier 2
    uint256 public immutable tier2Multiplier = 1300; // 1250 = 1.25x

    address safeAddress;
    address immutable treasury = 0x087183a411770a645A96cf2e31fA69Ab89e22F5E;

    /// Boolean variable to guard against multiple initialization attempts
    bool initiated;

    /// @param owner Address of the contract owner
    /// @param earnContractId index of earn contract in earnContracts
    event ContractOpened(address indexed owner, uint256 indexed earnContractId);

    /// @param owner Address of the contract owner
    /// @param earnContractId index of earn contract in earnContracts
    event ContractClosed(address indexed owner, uint256 indexed earnContractId);

    /// @param previousOwner Address of the previous contract owner
    /// @param newOwner Address of the new contract owner
    /// @param earnContractId Index of earn contract in earnContracts
    event ContractSold(
        address indexed previousOwner,
        address indexed newOwner,
        uint256 indexed earnContractId
    );

    /// @param owner Address of the contract owner
    /// @param earnContractId Index of earn contract in earnContracts
    /// @param token Address of the token redeemed
    /// @param tokenAmount Amount of token redeemed
    /// @param altaAmount Amount of ALTA redeemed
    event Redemption(
        address indexed owner,
        uint256 indexed earnContractId,
        address token,
        uint256 tokenAmount,
        uint256 altaAmount
    );

    /// @param buyer Address of the buyer
    /// @param offerId Index of offer in offers
    event ContractOffer(address indexed buyer, uint256 indexed offerId);

    /// @param earnContractId Index of earn contract in earnContracts
    event ContractListed(uint256 indexed earnContractId);

    /// @param earnContractId Index of earn contract in earnContracts
    event ContractListingRemoved(uint256 indexed earnContractId);

    constructor() {
        _transferOwnership(treasury);
    }

    enum ContractStatus {
        OPEN,
        CLOSED,
        FORSALE
    }

    enum Tier {
        TIER0,
        TIER1,
        TIER2
    }

    struct EarnTerm {
        uint128 time; // Time Locked (in Days);
        uint64 interestRate; // Base APR (simple interest) (1000 = 10%)
        uint64 altaRatio; // ALTA ratio (1000 = 10%)
        bool open; // True if open, False if closed
    }

    struct EarnContract {
        address owner; // Contract Owner Address
        uint256 termIndex; // Index of Earn Term
        uint256 startTime; // Unix Epoch time started
        uint256 contractLength; // length of contract in seconds
        address token; // Token Address
        uint256 lentAmount; // Amount of token lent
        uint256 altaStaked; // Amount of ALTA staked
        uint256 baseTokenPaid; // Base Interest Paid
        uint256 altaPaid; // ALTA Interest Paid
        Tier tier; // TIER0, TIER1, TIER2
        ContractStatus status; // Open, Closed, or ForSale
    }

    struct Offer {
        address buyer; // Buyer Address
        address to; // Address of Contract Owner
        uint256 earnContractId; // Earn Contract Id
        uint256 amount; // ALTA Amount
        bool accepted; // Accepted - false if pending
    }

    EarnTerm[] public earnTerms;
    EarnContract[] public earnContracts;
    Offer[] public offers;
    mapping(address => bool) public acceptedAssets;

    /// @return An array of type EarnContract
    function getAllEarnContracts() public view returns (EarnContract[] memory) {
        return earnContracts;
    }

    /// @return An array of type EarnTerm
    function getAllEarnTerms() public view returns (EarnTerm[] memory) {
        return earnTerms;
    }

    /// @return An array of type Offer
    function getAllOffers() public view returns (Offer[] memory) {
        return offers;
    }

    /// Sends erc20 token to Alta Treasury Address and creates a contract with EarnContract[_id] terms for user.
    /// @param _earnTermsId Index of the earn term in earnTerms
    /// @param _amount Amount of token to be lent
    /// @param _token Token Address
    /// @param _altaStake Amount of Alta to stake in contract
    function openContract(
        uint256 _earnTermsId,
        uint256 _amount,
        IERC20Metadata _token,
        uint256 _altaStake
    ) public whenNotPaused {
        require(_amount > 0, "Token amount must be greater than zero");

        EarnTerm memory earnTerm = earnTerms[_earnTermsId];
        require(earnTerm.open, "Earn Term must be open");

        require(acceptedAssets[address(_token)], "Token not accepted");

        // User needs to first approve the token to be spent
        require(
            _token.balanceOf(address(msg.sender)) >= _amount,
            "Insufficient Tokens"
        );

        _token.transferFrom(msg.sender, address(this), _amount);

        if (_altaStake > 0) {
            ALTA.transferFrom(msg.sender, address(this), _altaStake);
        }

        Tier tier = getTier(_altaStake);

        // Convert time of earnTerm from days to seconds
        uint256 earnSeconds = earnTerm.time * 1 days;

        _createContract(
            _earnTermsId,
            earnSeconds,
            address(_token),
            _amount,
            _altaStake,
            tier
        );
    }

    /// @notice Redeem the currrent base token + ALTA interest available for the contract
    /// @param _earnContractId Index of earn contract in earnContracts
    function redeem(uint256 _earnContractId) public {
        EarnContract memory earnContract = earnContracts[_earnContractId];
        require(earnContract.owner == msg.sender);
        (uint256 baseTokenAmount, uint256 altaAmount) = redeemableValue(
            _earnContractId
        );
        earnContract.baseTokenPaid += baseTokenAmount;
        earnContract.altaPaid += altaAmount;

        if (
            block.timestamp >=
            earnContract.startTime + earnContract.contractLength
        ) {
            _closeContract(_earnContractId);
        }
        emit Redemption(
            msg.sender,
            _earnContractId,
            earnContract.token,
            baseTokenAmount,
            altaAmount
        );
        IERC20Metadata Token = IERC20Metadata(earnContract.token);
        Token.transfer(msg.sender, baseTokenAmount);
        ALTA.transfer(msg.sender, altaAmount);
    }

    /// @notice Redeem the tokens availabe for all earn contracts owned by the sender (gas savings)
    function redeemAll() public {
        uint256 length = earnContracts.length; // gas optimization
        EarnContract[] memory _contracts = earnContracts; // gas optimization
        for (uint256 i = 0; i < length; i++) {
            if (_contracts[i].owner == msg.sender) {
                redeem(i);
            }
        }
    }

    /// @dev Calculate the currrent base token + ALTA available for the contract
    /// @param _earnContractId Index of earn contract in earnContracts
    /// @return baseTokenAmount Base token amount
    /// @return altaAmount ALTA amount
    function redeemableValue(uint256 _earnContractId)
        public
        view
        returns (uint256 baseTokenAmount, uint256 altaAmount)
    {
        EarnContract memory earnContract = earnContracts[_earnContractId];
        EarnTerm memory earnTerm = earnTerms[earnContract.termIndex];
        IERC20Metadata Token = IERC20Metadata(earnContract.token);

        uint256 timeOpen = block.timestamp -
            earnContracts[_earnContractId].startTime;

        uint256 interestRate = getInterestRate(
            earnTerm.interestRate,
            earnContract.tier
        );

        if (timeOpen <= earnContract.contractLength) {
            // Just interest
            baseTokenAmount =
                (earnContract.lentAmount * interestRate * timeOpen) /
                365 days /
                10000;

            // Calculate the total amount of alta rewards accrued
            altaAmount = (((((earnContract.lentAmount * (10**ALTA.decimals())) /
                (10**Token.decimals())) * earnTerm.altaRatio) / 10000) * timeOpen / earnContract.contractLength);
        } else {
            // Calculate the total amount of base token to be paid out (principal + interest)
            uint256 baseRegInterest = ((earnContract.lentAmount *
                interestRate *
                earnContract.contractLength) /
                365 days /
                10000);

            baseTokenAmount = baseRegInterest + earnContract.lentAmount;

            // Calculate the total amount of alta rewards accrued + staked amount
            altaAmount = ((((earnContract.lentAmount * (10**ALTA.decimals())) /
                (10**Token.decimals())) * earnTerm.altaRatio) / 10000) + earnContract.altaStaked;
        }

        baseTokenAmount = baseTokenAmount - earnContract.baseTokenPaid;
        altaAmount = altaAmount - earnContract.altaPaid;
        return (baseTokenAmount, altaAmount);
    }

    /// @dev Calculate the currrent base token + ALTA available for the contract
    /// @param _earnContractId Index of earn contract in earnContracts
    /// @return baseTokenAmount Base token amount
    /// @return altaAmount ALTA amount
    function redeemableValue(uint256 _earnContractId, uint256 _time)
        public
        view
        returns (uint256 baseTokenAmount, uint256 altaAmount)
    {
        require(_time >= earnContracts[_earnContractId].startTime);
        EarnContract memory earnContract = earnContracts[_earnContractId];
        EarnTerm memory earnTerm = earnTerms[earnContract.termIndex];
        IERC20Metadata Token = IERC20Metadata(earnContract.token);

        uint256 timeOpen = _time - earnContracts[_earnContractId].startTime;

        uint256 interestRate = getInterestRate(
            earnTerm.interestRate,
            earnContract.tier
        );

        if (timeOpen <= earnContract.contractLength) {
            // Just interest
            baseTokenAmount =
                (earnContract.lentAmount * interestRate * timeOpen) /
                365 days /
                10000;

            // Calculate the total amount of alta rewards accrued
            altaAmount = (((((earnContract.lentAmount * (10**ALTA.decimals())) /
                (10**Token.decimals())) * earnTerm.altaRatio) / 10000) * timeOpen / earnContract.contractLength);
        } else {
            // Calculate the total amount of base token to be paid out (principal + interest)
            uint256 baseRegInterest = ((earnContract.lentAmount *
                interestRate *
                earnContract.contractLength) /
                365 days /
                10000);

            baseTokenAmount = baseRegInterest + earnContract.lentAmount;

            // Calculate the total amount of alta rewards accrued + staked amount
            altaAmount = ((((earnContract.lentAmount * (10**ALTA.decimals())) /
                (10**Token.decimals())) * earnTerm.altaRatio) / 10000) + earnContract.altaStaked;
        }

        baseTokenAmount = baseTokenAmount - earnContract.baseTokenPaid;
        altaAmount = altaAmount - earnContract.altaPaid; 
        return (baseTokenAmount, altaAmount);
    }

    /// @notice Lists the associated earn contract for sale on the market
    /// @param _earnContractId Index of earn contract in earnContracts
    function putSale(uint256 _earnContractId) external whenNotPaused {
        require(
            msg.sender == earnContracts[_earnContractId].owner,
            "Msg.sender is not the owner"
        );
        earnContracts[_earnContractId].status = ContractStatus.FORSALE;
        emit ContractListed(_earnContractId);
    }

    /// @notice Submits an offer for an earn contract listed on the market
    /// @dev User must sign an approval transaction for first. ALTA.approve(address(this), _amount);
    /// @param _earnContractId Index of earn contract in earnContracts
    /// @param _amount Amount of base token offered
    function makeOffer(uint256 _earnContractId, uint256 _amount)
        external
        whenNotPaused
    {
        EarnContract memory earnContract = earnContracts[_earnContractId];
        require(
            earnContract.status == ContractStatus.FORSALE,
            "Contract not for sale"
        );
        require(msg.sender != earnContract.owner, "Cannot make offer on own contract");

        Offer memory offer = Offer(
            msg.sender, // buyer
            earnContract.owner, // to
            _earnContractId, // earnContractId
            _amount, // amount
            false // accepted
        );

        offers.push(offer);
        uint256 offerId = offers.length - 1;

        IERC20Metadata(earnContract.token).transferFrom(
            msg.sender,
            address(this),
            _amount
        );
        emit ContractOffer(msg.sender, offerId);
    }

    /// @notice Transfers the offer amount to the owner of the earn contract and transfers ownership of the contract to the buyer
    /// @param _offerId Index of offer in Offers
    function acceptOffer(uint256 _offerId) external whenNotPaused {
        Offer memory offer = offers[_offerId];
        uint256 earnContractId = offer.earnContractId;
        EarnContract memory earnContract = earnContracts[earnContractId];

        require(
            msg.sender == earnContract.owner,
            "Msg.sender is not the owner"
        );

        uint256 fee = (offer.amount * transferFee) / 1000;

        if (fee > 0) {
            IERC20Metadata(earnContract.token).transfer(feeAddress, fee);
            offer.amount = offer.amount - fee;
        }
        IERC20Metadata(earnContract.token).transfer(offer.to, offer.amount);

        offers[_offerId].accepted = true;

        emit ContractSold(offer.to, offer.buyer, earnContractId);
        earnContracts[earnContractId].owner = offer.buyer;

        _removeContractFromMarket(earnContractId);
    }

    /// @notice Remove Contract From Market
    /// @param _earnContractId Index of earn contract in earnContracts
    function removeContractFromMarket(uint256 _earnContractId) external {
        require(
            msg.sender == earnContracts[_earnContractId].owner,
            "Msg.sender is not the owner"
        );
        _removeContractFromMarket(_earnContractId);
    }

    /// @notice Sends offer funds back to buyer and removes the offer from the array
    /// @param _offerId Index of offer in Offers
    function removeOffer(uint256 _offerId) external {
        Offer memory offer = offers[_offerId];
        require(msg.sender == offer.buyer, "Msg.sender is not the buyer");
        EarnContract memory earnContract = earnContracts[offer.earnContractId];
        IERC20Metadata(earnContract.token).transfer(offer.buyer, offer.amount);

        _removeOffer(_offerId);
    }

    /// @param _interestRate Base interest rate before tier multipliers
    /// @param _tier Tier of the contract
    function getInterestRate(uint256 _interestRate, Tier _tier)
        public
        pure
        returns (uint256)
    {
        if (_tier == Tier.TIER0) {
            return _interestRate;
        } else if (_tier == Tier.TIER1) {
            return ((_interestRate * tier1Multiplier) / 1000);
        } else {
            return ((_interestRate * tier2Multiplier) / 1000);
        }
    }

    /// @param _ALTA Address of ALTA Token contract
    /// @param _feeAddress Address of wallet to recieve loan funds
    function init(
        IERC20Metadata _ALTA,
        address _feeAddress
    ) external onlyOwner {
        require(!initiated, "Contract already initiated");
        ALTA = _ALTA;
        feeAddress = _feeAddress;
        transferFee = 3; // 3 = .3%
        tier1Amount = 10000 * (10**ALTA.decimals()); // 10,000 ALTA
        tier2Amount = 100000 * (10**ALTA.decimals()); // 100,000 ALTA
        initiated = true;
    }

    /// @param _time Length of the contract in days
    /// @param _interestRate Base interest rate (1000 = 10%)
    /// @param _altaRatio Interest rate for ALTA (1000 = 10%)
    /// @dev Add an earn term with 8 parameters
    function addTerm(
        uint128 _time,
        uint64 _interestRate,
        uint64 _altaRatio
    ) public onlyOwner {
        earnTerms.push(EarnTerm(_time, _interestRate, _altaRatio, true));
    }

    /// @param _earnTermsId index of the earn term in earnTerms
    function closeTerm(uint256 _earnTermsId) public onlyOwner {
        require(_earnTermsId < earnTerms.length);
        earnTerms[_earnTermsId].open = false;
    }

    /// @param _earnTermsId index of the earn term in earnTerms
    function openTerm(uint256 _earnTermsId) public onlyOwner {
        require(_earnTermsId < earnTerms.length);
        earnTerms[_earnTermsId].open = true;
    }

    /// @notice Close the contract flagged wallet for AML compliance. Owner will receive principal with no interest.
    /// @param _earnContractId Index of earn contract in earnContracts
    function closeContractAmlCheck(uint256 _earnContractId) external onlyOwner {
        EarnContract memory earnContract = earnContracts[_earnContractId];
        require(block.timestamp <= earnContract.startTime + 7 days);
        IERC20Metadata Token = IERC20Metadata(earnContract.token);
        _closeContract(_earnContractId);
        Token.transfer(msg.sender, earnContract.lentAmount);
    }

    /// Set the transfer fee rate for contracts sold on the market place
    /// @param _transferFee Percent of accepted earn contract offer to be sent to Alta wallet
    function setTransferFee(uint256 _transferFee) external onlyOwner {
        transferFee = _transferFee;
    }

    /// @notice Set the safe address for the contract
    /// @param _safeAddress Address of the safe contract
    function setSafeAddress(address _safeAddress) external onlyOwner {
        safeAddress = _safeAddress;
        _transferOwnership(_safeAddress);
    }

    /// @notice Set ALTA ERC20 token address
    /// @param _ALTA Address of ALTA Token contract
    function setAltaAddress(address _ALTA) external onlyOwner {
        ALTA = IERC20Metadata(_ALTA);
    }

    /// @notice Set the feeAddress
    /// @param _feeAddress Wallet address to recieve loan funds
    function setFeeAddress(address _feeAddress) external onlyOwner {
        require(_feeAddress != address(0));
        feeAddress = _feeAddress;
    }

    /// @param _tier1Amount Amount of ALTA staked to be considered Tier 1
    /// @param _tier2Amount Amount of ALTA staked to be considered Tier 2
    function setStakeAmounts(uint256 _tier1Amount, uint256 _tier2Amount)
        external
        onlyOwner
    {
        tier1Amount = _tier1Amount;
        tier2Amount = _tier2Amount;
    }

    /// @param _asset Address of token to be updated
    /// @param _accepted True if the token is accepted, false otherwise
    function updateAsset(address _asset, bool _accepted) external onlyOwner {
        acceptedAssets[_asset] = _accepted;
    }

    /// @param _assets Array of token addresses to be updated
    /// @param _accepted True if the token is accepted, false otherwise
    function updateAssets(address[] memory _assets, bool _accepted) external onlyOwner {
        for (uint256 i = 0; i < _assets.length; i++) {
            acceptedAssets[_assets[i]] = _accepted;
        }
    }

    /// @param _earnTermsId Index of the earn term in earnTerms
    /// @param _earnSeconds Length of the contract in seconds
    /// @param _lentAmount Amount of token lent
    function _createContract(
        uint256 _earnTermsId,
        uint256 _earnSeconds,
        address _token,
        uint256 _lentAmount,
        uint256 _altaStake,
        Tier tier
    ) internal {
        EarnContract memory earnContract = EarnContract(
            msg.sender, // owner
            _earnTermsId, // termIndex
            block.timestamp, // startTime
            _earnSeconds, //contractLength,
            _token, // token
            _lentAmount, // lentAmount
            _altaStake, // altaStaked
            0, // baseTokenPaid
            0, // altaPaid
            tier, // tier
            ContractStatus.OPEN
        );

        earnContracts.push(earnContract);
        uint256 id = earnContracts.length - 1;
        emit ContractOpened(msg.sender, id);
    }

    /// @param _earnContractId index of earn contract in earnContracts
    function _closeContract(uint256 _earnContractId) internal {
        require(
            earnContracts[_earnContractId].status != ContractStatus.CLOSED,
            "Contract is already closed"
        );
        require(
            _earnContractId < earnContracts.length,
            "Contract does not exist"
        );
        EarnContract memory earnContract = earnContracts[_earnContractId];
        address owner = earnContract.owner;
        emit ContractClosed(owner, _earnContractId);

        _removeAllContractOffers(_earnContractId);
        earnContracts[_earnContractId].status = ContractStatus.CLOSED;
    }

    /// @param _offerId Index of offer in Offers
    function _removeOffer(uint256 _offerId) internal {
        require(_offerId < offers.length, "Offer ID longer than array length");

        if (offers.length > 1) {
            offers[_offerId] = offers[offers.length - 1];
        }
        offers.pop();
    }

    /// @notice Removes all contracts offers and sets the status flag back to open
    /// @param _earnContractId Index of earn contract in earnContracts
    function _removeContractFromMarket(uint256 _earnContractId) internal {
        earnContracts[_earnContractId].status = ContractStatus.OPEN;
        _removeAllContractOffers(_earnContractId);
        emit ContractListingRemoved(_earnContractId);
    }

    /// @notice Sends all offer funds for an earn contract back to the buyer and removes them arrays and mappings
    /// @param _earnContractId Index of earn contract in earnContracts
    function _removeAllContractOffers(uint256 _earnContractId) internal {
        uint256 length = offers.length; // gas optimization
        Offer[] memory _offers = offers; // gas optimization
        if (length > 0) {
            for (uint256 i = length; i > 0; i--) {
                uint256 offerId = i - 1;
                if (_offers[offerId].earnContractId == _earnContractId) {
                    if (!_offers[offerId].accepted) {
                        IERC20Metadata(
                            earnContracts[_offers[offerId].earnContractId].token
                        ).transfer(_offers[offerId].buyer, _offers[offerId].amount);
                    }
                    _removeOffer(offerId);
                }
            }
        }
    }

    /// @param _altaStaked Amount of ALTA staked to the contract
    function getTier(uint256 _altaStaked) internal view returns (Tier) {
        if (_altaStaked < tier1Amount) {
            return Tier.TIER0;
        } else if (_altaStaked < tier2Amount) {
            return Tier.TIER1;
        } else {
            return Tier.TIER2;
        }
    }
}
