// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";

import "../Interface/ISpaceCows.sol";

import "./Modules/Whitelisted.sol";
import "./Modules/Random.sol";

contract Sale is Ownable, Whitelisted {
    using Random for Random.Manifest;
    Random.Manifest internal _manifest;

    uint256 public whitelistSalePrice;
    uint256 public publicSalePrice;
    uint256 public maxMintsPerTxn;
    uint256 public maxPresaleMintsPerWallet;
    uint256 public maxTokenSupply;
    uint256 public pendingRefereeAwards;
    
    enum SaleState {
        CLOSED,
        PRESALE,
        OPEN
    }
    SaleState public saleState;

    ISpaceCows public spaceCows;

    struct Referee {
        uint128 referredCount;
        uint128 reward;
    }
    mapping(address => Referee) private _refereeAccounts;

    constructor(
        uint256 _whitelistSalePrice,
        uint256 _publicSalePrice,
        uint256 _maxSupply,
        uint256 _maxMintsPerTxn,
        uint256 _maxPresaleMintsPerWallet
    ) {
        whitelistSalePrice = _whitelistSalePrice;
        publicSalePrice = _publicSalePrice;
        maxTokenSupply = _maxSupply;
        maxMintsPerTxn = _maxMintsPerTxn;
        maxPresaleMintsPerWallet = _maxPresaleMintsPerWallet;
        _manifest.setup(_maxSupply);

        saleState = SaleState(0);
    }

    /**
    =========================================
    Owner Functions
    @dev these functions can only be called 
        by the owner of contract. some functions
        here are meant only for backup cases.
        separate maxpertxn and maxperwallet for
        max flexibility
    =========================================
    */
    function setWhitelistPrice(uint256 _newPrice) external onlyOwner {
        whitelistSalePrice = _newPrice;
    }

    function setPublicPrice(uint256 _newPrice) external onlyOwner {
        publicSalePrice = _newPrice;
    }

    function setMaxTokenSupply(uint256 _newMaxSupply) external onlyOwner {
        maxTokenSupply = _newMaxSupply;
    }

    function setMaxMintsPerTxn(uint256 _newMaxMintsPerTxn) external onlyOwner {
        maxMintsPerTxn = _newMaxMintsPerTxn;
    }

    function setMaxPresaleMintsPerWallet(uint256 _newLimit) external onlyOwner {
        maxPresaleMintsPerWallet = _newLimit;
    }

    function setSpaceCowsAddress(address _newNftContract) external onlyOwner {
        spaceCows = ISpaceCows(_newNftContract);
    }

    function setSaleState(uint256 _state) external onlyOwner {
        saleState = SaleState(_state);
    }

    function setWhitelistRoot(bytes32 _newWhitelistRoot) external onlyOwner {
        _setWhitelistRoot(_newWhitelistRoot);
    }

    function givewayReserved(address _user, uint256 _amount) external onlyOwner {
        uint256 totalSupply = spaceCows.totalSupply();
        require(totalSupply + _amount < maxTokenSupply + 1, "Not enough tokens!");
        
        uint256 index = 0;
        uint256[] memory tmpTokenIds = new uint256[](_amount);
        while (index < _amount) {
            uint256 tokenId = _manifest.draw();
            bool doExists = spaceCows.exists(tokenId);

            if (!doExists) {
                tmpTokenIds[index] = tokenId;
                index++;
            } else {
                continue;
            }
        }

        spaceCows.cowMint(_user, tmpTokenIds);
    }

    function withdraw() external onlyOwner {
        uint256 payment = (address(this).balance - pendingRefereeAwards) / 4;
        require(payment > 0, "Empty balance");

        sendToOwners(payment);
    }

    function emergencyWithdraw() external onlyOwner {
        uint256 payment = address(this).balance / 4;
        require(payment > 0, "Empty balance");

        sendToOwners(payment);
    }
    
    /**
    =========================================
    Mint Functions
    @dev these functions are relevant  
        for minting purposes only
    =========================================
    */
    function whitelistPurchase(uint256 numberOfTokens, bytes32[] calldata proof)
    external
    payable
    onlyWhitelisted(msg.sender, address(this), proof) {
        address user = msg.sender;
        uint256 buyAmount = whitelistSalePrice * numberOfTokens;

        require(saleState == SaleState.PRESALE, "Presale is not started!");
        require(spaceCows.balanceOf(user) + numberOfTokens < maxPresaleMintsPerWallet + 1, "You can only mint 10 token(s) on presale per wallet!");
        require(msg.value > buyAmount - 1, "Not enough ETH!");

        uint256 index = 0;
        uint256[] memory tmpTokenIds = new uint256[](numberOfTokens);
        while (index < numberOfTokens) {
            uint256 tokenId = _manifest.draw();
            bool doExists = spaceCows.exists(tokenId);

            if (!doExists) {
                tmpTokenIds[index] = tokenId;
                index++;
            } else {
                continue;
            }
        }

        spaceCows.cowMint(user, tmpTokenIds);
    }

    function publicPurchase(uint256 numberOfTokens, address referee)
    external
    payable {
        address user = msg.sender;
        uint256 totalSupply = spaceCows.totalSupply();
        uint256 buyAmount = publicSalePrice * numberOfTokens;

        require(saleState == SaleState.OPEN, "Sale not started!");
        require(numberOfTokens < maxMintsPerTxn + 1, "You can buy up to 10 per transaction");
        require(totalSupply + numberOfTokens < maxTokenSupply + 1, "Not enough tokens!");
        require(msg.value > buyAmount - 1, "Not enough ETH!");

        uint256 index = 0;
        uint256[] memory tmpTokenIds = new uint256[](numberOfTokens);
        while (index < numberOfTokens) {
            uint256 tokenId = _manifest.draw();
            bool doExists = spaceCows.exists(tokenId);

            if (!doExists) {
                tmpTokenIds[index] = tokenId;
                index++;
            } else {
                continue;
            }
        }

        spaceCows.cowMint(user, tmpTokenIds);

        if (msg.sender != referee && referee != address(0)) {
            updateReferee(referee);
        }
    }

    function getRefereeData(address referee) public view returns (Referee memory) {
        Referee memory _r = _refereeAccounts[referee];
        _r.reward = (_r.reward == 0) ? 0 : _r.reward - 1;

        return _r;
    }

    function claimRefereeRewards() external {
        address referee = msg.sender;
        uint256 refereeReward = (_refereeAccounts[referee].reward == 0) ? 0 : uint256(_refereeAccounts[referee].reward) - 1;
        uint256 accountBalance = address(this).balance;
        require(accountBalance > 0, "Empty balance");
        require(refereeReward > 0, "Empty reward");

        sendValue(payable(referee), refereeReward);

        Referee storage _refereeObject = _refereeAccounts[referee];
        _refereeObject.reward = 1;

        pendingRefereeAwards -= refereeReward;
    }

    /**
    ============================================
    Public & External Functions
    @dev functions that can be called by anyone
    ============================================
    */
    function remaining() public view returns (uint256) {
        return _manifest.remaining();
    }

    function getSaleState() public view returns (uint256) {
        return uint256(saleState);
    }

    /**
    ============================================
    Internal Functions
    @dev functions that can be use inside the contract
    ============================================
    */
    function updateReferee(address referee) internal {
        uint128 reward = uint128(msg.value) * 15 / 100;

        if (_refereeAccounts[referee].referredCount != 0) {
            Referee storage _refereeObject = _refereeAccounts[referee];
            _refereeObject.reward += reward;
            _refereeObject.referredCount += 1;
        } else {
            _refereeAccounts[referee] = Referee({
                referredCount: 1,
                reward: reward + 1
            });
        }

        pendingRefereeAwards += reward;
    }

    function sendToOwners(uint256 payment) internal {
        sendValue(payable(0xced6ACCbEbF5cb8BD23e2B2E8B49C78471FaAe20), payment);
        sendValue(payable(0x4386103c101ce063C668B304AD06621d6DEF59c9), payment);
        sendValue(payable(0x19Bb04164f17FF2136A1768aA4ed22cb7f1dAa00), payment);
        sendValue(payable(0x910040fA04518c7D166e783DB427Af74BE320Ac7), payment);
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}