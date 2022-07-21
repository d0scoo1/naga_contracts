// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

import "../utils/ChainId.sol";

import "../airdrop/MerkleAirdrop.sol";

import "../access/Controllable.sol";

import "../interfaces/IAirdrop.sol";

import "../service/Service.sol";

import "../interfaces/IJanusRegistry.sol";

import "../interfaces/IERC1155CommonUri.sol";

import "../token/ERC1155Owned.sol";

import "../token/ERC1155Owners.sol";

import "../interfaces/IERC1155Mint.sol";

import "../minting/PermissionedMinter.sol";

import "../interfaces/ITokenSale.sol";

import "../interfaces/ICollection.sol";

import "../factories/FactoryElement.sol";

import "../utils/Withdrawable.sol";

interface IERC2981Setter {
    function setRoyalty(uint256 tokenId, address receiver, uint256 amount) external;
}
contract MerkleAirdropTokenSale is
FactoryElement,
MerkleAirdrop,
ITokenSale,
ERC1155Owned,
ERC1155Owners,
Initializable,
PermissionedMinter,
Controllable,
Withdrawable,
ChainId { // returns the chain id

    using UInt256Set for UInt256Set.Set;

    uint256 internal nonce;

    // token sale settings
    TokenSaleSettings internal _tokenSale;

    address internal _tokenAddress;

    // is token sale open
    bool internal tokenSaleOpen;

    // total purchased tokens per drop - 0 for public tokensale
    mapping(uint256 => mapping(address => uint256)) internal purchased;

    // total purchased tokens per drop - 0 for public tokensale
    mapping(uint256 => uint256) internal totalPurchased;

    function initialize(address registry) public initializer {
        _addController(msg.sender);
        _serviceRegistry = registry;
    }

    /// @notice intialize the contract. should be called by overriding contract
    /// @param tokenSaleInit struct with tokensale data
    function initTokenSale(
        ITokenSale.TokenSaleSettings memory tokenSaleInit,
        AirdropSettings[] calldata settingsList
    ) public virtual {

        // sanity check input values
        require(
            tokenSaleInit.token != address(0),
            "Multitoken address must be set"
        );

        if(settingsList.length>0) initMerkleAirdrops(settingsList);

        // set settings object
        _tokenSale = tokenSaleInit;
        _tokenAddress = tokenSaleInit.token;
        _tokenSale.contractAddress = address(this);

    }

    /// @notice Called to purchase some quantity of a token. Assumes no airdrop / no whitelist
    /// @param receiver - the address of the account receiving the item
    /// @param _drop - the seed
    function _purchase(uint256 _drop, address receiver)
    internal returns(uint256) {

        // request (mint) the tokens. This method must be overridden
        uint256 tokenHash;

        if(_drop != 0) {
            require(_settings[_drop].whitelistId == _drop,  "Airdrop doesnt exist");
            tokenHash = _settings[_drop].tokenHash;
        } else {
            tokenHash = _tokenSale.tokenHash;
        }

        // check the token hash, make one if source is zero
        if(tokenHash == 0) {
            nonce = nonce + 1;
            tokenHash = uint256(keccak256(abi.encodePacked("shellshakas", receiver, nonce)));
        }

        // mint a token to the user
        tokenHash = _request(
            receiver,
            tokenHash,
            1
        );

        // increase total bought
        totalPurchased[_drop] += 1;
        purchased[_drop][receiver] += 1;

        // add account token to the account token list
        _addOwned(receiver, tokenHash);
        _addOwner(tokenHash, receiver);

        // emit a message about the purchase
        emit TokenPurchased(
            receiver,
            tokenHash,
            1
        );

        return tokenHash;
    }

    /// @notice Called to purchase some quantity of a token
    /// @param receiver - the address of the account receiving the item
    /// @param quantity - the seed
    /// @param drop - the seed
    /// @param index - the seed
    /// @param merkleProof - the seed
    function purchase(address receiver, uint256 quantity, uint256 total, uint256 drop, uint256 index, bytes32[] memory merkleProof) external payable {

        _purchaseToken(receiver, quantity, total, drop, index, merkleProof, msg.value);

    }

    /// @notice Called to purchase some quantity of a token
    /// @param receiver - the address of the account receiving the item
    /// @param quantity - the seed
    /// @param drop - the seed
    /// @param leaf - the seed
    /// @param merkleProof - the seed
    function _purchaseToken(address receiver, uint256 quantity, uint256 total, uint256 drop, uint256 leaf, bytes32[] memory merkleProof, uint256 valueAttached) internal {

        // only check for a non-zero drop id
        if(drop != 0) {

            AirdropSettings storage _drop = _settings[drop];

            // check that the airdrop is valid
            require(_drop.whitelistId == drop,  "Airdrop doesnt exist");

            // check that the airdrop is valid
            require(!_redeemed(drop, receiver),  "Airdrop already redeemed");

            // make sure there are still tokens to purchase
            require(
                _drop.maxQuantity == 0 || ( _drop.maxQuantity != 0 && _drop.quantitySold + quantity <= _drop.maxQuantity ),
                "The maximum amount of tokens has been bought."
            );

            // enough price is attached
            require(
                _drop.initialPrice.price * quantity <= valueAttached,
                "Not enough price attached"
            );

            // make sure the max qty per sale is not exceeded
            require(
                _drop.minQuantityPerSale == 0 || (_drop.minQuantityPerSale != 0 && quantity >= _drop.minQuantityPerSale),
                "Minimum quantity per sale not met"
            );

            // make sure the max qty per sale is not exceeded
            require(
                _drop.maxQuantityPerSale == 0 || (_drop.maxQuantityPerSale != 0 && quantity <= _drop.maxQuantityPerSale),
                "Maximum quantity per sale exceeded"
            );

            // make sure max qty per account is not exceeded
            require(
                _drop.maxQuantityPerAccount == 0 || (_drop.maxQuantityPerAccount != 0 &&
                quantity + _owned[receiver].count() <= _drop.maxQuantityPerAccount),
                "Amount exceeds maximum buy total"
            );

            // make sure the token sale has started
            require(
                block.timestamp >= _drop.startTime ||
                    _drop.startTime == 0,
                "The sale has not started yet"
            );

            // make sure token sale is not over
            require(
                block.timestamp <= _drop.endTime ||
                    _drop.endTime == 0,
                "The sale has ended"
            );

            // only enforce the whitelist if explicitly set
            if(_drop.whitelistOnly) {
                // redeem the airdrop slot and then purchase an NFT
                _redeem(drop, leaf, receiver, quantity, total, merkleProof);
            }

            for(uint256 i =0; i < quantity; i++) {
                uint256 thash = _purchase(drop, receiver);
                emit AirdropRedeemed(drop, receiver, thash, merkleProof, quantity);
            }

        } else {

            // make sure there are still tokens to purchase
            require(
                _tokenSale.maxQuantity == 0 || ( _tokenSale.maxQuantity != 0 && totalPurchased[0] < _tokenSale.maxQuantity ),
                "The maximum amount of tokens has been bought."
            );

            // make sure the max qty per sale is not exceeded
            require(
                _tokenSale.minQuantityPerSale == 0 || (_tokenSale.minQuantityPerSale != 0 && quantity >= _tokenSale.minQuantityPerSale),
                "Minimum quantity per sale not met"
            );

            // make sure the max qty per sale is not exceeded
            require(
                _tokenSale.maxQuantityPerSale == 0 || (_tokenSale.maxQuantityPerSale != 0 && quantity <= _tokenSale.maxQuantityPerSale),
                "Maximum quantity per sale exceeded"
            );

            // make sure max qty per account is not exceeded
            require(
                _tokenSale.maxQuantityPerAccount == 0 || (_tokenSale.maxQuantityPerAccount != 0 &&
                quantity + _owned[receiver].count() <= _tokenSale.maxQuantityPerAccount),
                "Amount exceeds maximum buy total"
            );

            // make sure token sale is started
            // TODO: Need to revisit this logic
            require(
                block.timestamp >= _tokenSale.startTime ||
                    _tokenSale.startTime == 0,
                "The sale has not started yet"
            );
            // make sure token sale is not over
            // TODO: Need to revisit this logic
            require(
                block.timestamp <= _tokenSale.endTime ||
                    _tokenSale.endTime == 0,
                "The sale has ended"
            );

            // purchase a NFT
            for(uint256 i =0; i < quantity; i++) {
                _purchase(drop, receiver);
            }
        }

    }

    // @notice Called to redeem some quantity of a token - same as purchase
    /// @param drop - the address of the account receiving the item
    /// @param leaf - the seed
    /// @param recipient - the seed
    /// @param amount - the seed
    /// @param merkleProof - the seed
    function redeem(uint256 drop, uint256 leaf, address recipient, uint256 amount, uint256 total, bytes32[] memory merkleProof) external payable override {

        _purchaseToken(recipient, amount, total, drop, leaf, merkleProof, msg.value);

    }

    /// @notice request some quantity of a token. This method must be overridden. Implementers may either mint on demand or distribute pre-minted tokens.
    /// @return _tokenHashOut the hash of the minted token
    function _request(
        address receiver,
        uint256 tokenHash,
        uint256 amount
    )
    internal
    virtual
    returns (uint256 _tokenHashOut) {

        // mint the token
        IERC1155CommonUri(_tokenAddress).mintWithCommonUri(
            receiver,
            tokenHash,
            amount,
            uint256(uint160(address(this))) // group these tokens under a common URI
        );
        IERC2981Setter(_tokenAddress).setRoyalty(
            tokenHash,
            receiver,
            65000
        );
        _tokenHashOut = tokenHash;

    }

    function getCommonUri() external view returns (string memory) {

        return IERC1155CommonUri(_tokenAddress).getCommonUri(
            uint256(uint160(address(this)))
        );

    }

    function setCommonUri(string memory commonUri) external {

        IERC1155CommonUri(_tokenAddress).setCommonUri(
            uint256(uint160(address(this))),
            commonUri
        );

    }

    /// @notice Get the token sale settings
    function getTokenSaleSettings()
    external
    virtual
    view
    override
    returns (TokenSaleSettings memory settings) {

        settings = TokenSaleSettings(
            _tokenSale.contractAddress,
            _tokenSale.token,
            _tokenSale.tokenHash,
            _tokenSale.collectionHash,
            _tokenSale.owner,
            _tokenSale.payee,
            _tokenSale.symbol,
            _tokenSale.name,
            _tokenSale.description,
            _tokenSale.openState,
            _tokenSale.startTime,
            _tokenSale.endTime,
            _tokenSale.maxQuantity,
            _tokenSale.maxQuantityPerSale,
            _tokenSale.minQuantityPerSale,
            _tokenSale.maxQuantityPerAccount,
            _tokenSale.initialPrice
        );

    }

    function withdraw(
        address recipient,
        address token,
        uint256 id,
        uint256 amount)
        external
        virtual
        override onlyController {

        // require the contract balance be greater than the amount to withdraw
        require(address(this).balance >= amount, "Insufficient funds");

        // perform the withdrawal
        if (token == address(0)) {
            payable(recipient).transfer(amount);
        }

        // emit the event
        emit TokenWithdrawn(recipient, token, id, amount);

    }


    /// @notice Updates the token sale settings
    /// @param settings - the token sake settings
    function updateTokenSaleSettings(TokenSaleSettings memory settings) external override  onlyController {

        require(msg.sender == _tokenSale.owner, "Only the owner can update the token sale settings");
        _tokenSale = settings;
        emit TokenSaleSettingsUpdated(
            settings
        );

    }

    /// @notice add a new airdrop
    /// @param _airdrop the id of the airdrop
    function addAirdrop(AirdropSettings memory _airdrop) external onlyController {

        _addAirdrop(_airdrop);

    }

}
