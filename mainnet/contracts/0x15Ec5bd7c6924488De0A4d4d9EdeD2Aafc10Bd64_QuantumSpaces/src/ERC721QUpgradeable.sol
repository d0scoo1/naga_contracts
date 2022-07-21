// SPDX-License-Identifier: MIT
// Creator: JCBDEV

pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./TokenId.sol";
import "hardhat/console.sol";

error ApprovalCallerNotOwnerNorApproved();
error ApprovalQueryForNonexistentToken();
error ApproveToCaller();
error ApprovalToCurrentOwner();
error BalanceQueryForZeroAddress();
error MintToZeroAddress();
error MintZeroQuantity();
error OwnerQueryForNonexistentToken();
error TransferCallerNotOwnerNorApproved();
error TransferFromIncorrectOwner();
error TransferToNonERC721ReceiverImplementer();
error TransferToZeroAddress();
error URIQueryForNonexistentToken();
error TokenFrozenForFraudPeriod();
error AddressZeroNotValid();

/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata extension. Built to optimize for lower gas during batch mints.
 *
 * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
 *
 * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
 *
 * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
 */
contract ERC721QUpgradeable is
    Initializable,
    ContextUpgradeable,
    ERC165Upgradeable,
    IERC721Upgradeable,
    IERC721MetadataUpgradeable
{
    using AddressUpgradeable for address;
    using StringsUpgradeable for uint256;
    using TokenId for uint256;

    // // Compiler will pack this into a single 256bit word.
    struct TokenOwnership {
        // The address of the owner.
        address addr;
        // Keeps track of the start time of ownership with minimal overhead for tokenomics.
        uint64 startTimestamp;
        // Prevent forward transfer for up to max 256 hours (fraud)
        uint8 freezePeriod;
        // Unused
        uint16 _unused;
        // Whether the token has been burned.
        bool burned;
        bool isPre;
    }

    // Compiler will pack this into a single 256bit word.
    struct AddressData {
        // Realistically, 2**64-1 is more than enough.
        uint64 balance;
        // Keeps track of mint count with minimal overhead for tokenomics.
        uint64 numberMinted;
        // Keeps track of burn count with minimal overhead for tokenomics.
        uint64 numberBurned;
        // For miscellaneous variable(s) pertaining to the address
        // (e.g. number of whitelist mint slots used).
        // If there are multiple variables, please pack them into a uint64.
        uint64 aux;
    }

    // The tokenId of the next token to be minted.
    // Contract should always be offset by 1 everytime a mint starts (for preallocation gas savings)
    mapping(uint128 => uint128) internal _minted;

    // The number of tokens.
    uint256 internal _supplyCounter; //offset by 1 to save gas on mint 0

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    string internal _baseURI;

    // Mapping from token ID to ownership details
    // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
    mapping(uint256 => TokenOwnership) internal _ownerships;

    // Mapping owner address to address data
    mapping(address => AddressData) private _addressData;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    uint256 private constant __deprecated_baseIdMask =
        ~uint256(type(uint160).max);

    uint256 constant GAS_REFUNDS_LOCATION =
        uint256(keccak256("com.quantum.erc721q.gasrefunds"));

    function __ERC721Q_init(string memory name_, string memory symbol_)
        internal
        onlyInitializing
    {
        __ERC721Q_init_unchained(name_, symbol_);
    }

    function __ERC721Q_init_unchained(
        string memory name_,
        string memory symbol_
    ) internal onlyInitializing {
        _name = name_;
        _symbol = symbol_;
        _supplyCounter = 1; //Everything offset by one to save on minting costs
        // _currentIndex = _startTokenId();
    }

    // /**
    //  * To change the starting tokenId, please override this function.
    //  */
    // function _startTokenId(uint128 dropId) internal view virtual returns (uint256) {
    //     return uint256(dropId) << 128;
    // }

    /**
     * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
     */
    function totalSupply() public view returns (uint256) {
        return _supplyCounter - 1;
    }

    // /**
    //  * Returns the total amount of tokens minted in the contract.
    //  */
    // function _totalMinted() internal view returns (uint256) {
    //     // Counter underflow is impossible as _currentIndex does not decrement,
    //     // and it is initialized to _startTokenId()
    //     unchecked {
    //         return _currentIndex - _startTokenId();
    //     }
    // }

    function _mintedInDrop(uint128 dropId) internal view returns (uint128) {
        return _minted[dropId] == 0 ? 0 : _minted[dropId] - 1;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC165Upgradeable, IERC165Upgradeable)
        returns (bool)
    {
        return
            interfaceId == type(IERC721Upgradeable).interfaceId ||
            interfaceId == type(IERC721MetadataUpgradeable).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721-balanceOf}.
     */
    function balanceOf(address owner) public view override returns (uint256) {
        // revert("test");
        if (owner == address(0)) revert BalanceQueryForZeroAddress();
        return uint256(_addressData[owner].balance);
    }

    /**
     * Returns the number of tokens minted by `owner`.
     */
    function _numberMinted(address owner) internal view returns (uint256) {
        return uint256(_addressData[owner].numberMinted);
    }

    /**
     * Returns the number of tokens burned by or on behalf of `owner`.
     */
    function _numberBurned(address owner) internal view returns (uint256) {
        return uint256(_addressData[owner].numberBurned);
    }

    /**
     * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
     */
    function _getAux(address owner) internal view returns (uint64) {
        return _addressData[owner].aux;
    }

    /**
     * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
     * If there are multiple variables, please pack them into a uint64.
     */
    function _setAux(address owner, uint64 aux) internal {
        _addressData[owner].aux = aux;
    }

    /**
     * Gas spent here starts off proportional to the maximum mint batch size.
     * It gradually moves to O(1) as tokens get transferred around in the collection over time.
     */
    function _ownershipOf(uint256 tokenId)
        internal
        view
        returns (TokenOwnership memory)
    {
        uint256 curr = tokenId;

        uint256 minted = _mintedInDrop(tokenId.dropId());
        // console.log(tokenId.firstTokenInDrop());
        // if (minted < 1) minted = 1;

        unchecked {
            if (tokenId.firstTokenInDrop() <= curr && curr.mintId() < minted) {
                // console.log(curr);
                TokenOwnership memory ownership = _ownerships[curr];
                // console.log(_ownerships[curr].addr);
                // console.log(_ownerships[curr].startTimestamp);
                // console.log(_ownerships[curr].freezePeriod);
                // console.log(_ownerships[curr].burned);
                // console.log(_ownerships[curr].isPre);
                if (!ownership.burned) {
                    if (ownership.addr != address(0)) {
                        return ownership;
                    }

                    while (curr >= tokenId.firstTokenInDrop()) {
                        curr--;
                        ownership = _ownerships[curr];
                        if (ownership.addr != address(0)) {
                            return ownership;
                        }
                    }
                }
            }
        }
        revert OwnerQueryForNonexistentToken();
    }

    /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId) public view override returns (address) {
        return _ownershipOf(tokenId).addr;
    }

    /**
     * @dev See {IERC721Metadata-name}.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        if (!_exists(tokenId)) revert URIQueryForNonexistentToken();

        // string memory baseURI = _baseURI();
        // return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
        return
            bytes(_baseURI).length != 0
                ? string(abi.encodePacked(_baseURI, tokenId.toString()))
                : "";
    }

    // /**
    //  * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
    //  * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
    //  * by default, can be overriden in child contracts.
    //  */
    // function _baseURI() internal view virtual returns (string memory) {
    //     return '';
    // }

    /**
     * @dev See {IERC721-approve}.
     */
    function approve(address to, uint256 tokenId) public override {
        address owner = ERC721QUpgradeable.ownerOf(tokenId);
        if (to == owner) revert ApprovalToCurrentOwner();

        if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
            revert ApprovalCallerNotOwnerNorApproved();
        }

        _approve(to, tokenId, owner);
    }

    /**
     * @dev See {IERC721-getApproved}.
     */
    function getApproved(uint256 tokenId)
        public
        view
        override
        returns (address)
    {
        if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();

        return _tokenApprovals[tokenId];
    }

    /**
     * @dev See {IERC721-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved)
        public
        virtual
        override
    {
        if (operator == _msgSender()) revert ApproveToCaller();

        _operatorApprovals[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC721-isApprovedForAll}.
     */
    function isApprovedForAll(address owner, address operator)
        public
        view
        virtual
        override
        returns (bool)
    {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        _transfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        _transfer(from, to, tokenId);
        if (
            to.isContract() &&
            !_checkContractOnERC721Received(from, to, tokenId, _data)
        ) {
            revert TransferToNonERC721ReceiverImplementer();
        }
    }

    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`_mint`),
     */
    function _exists(uint256 tokenId) internal view returns (bool) {
        return
            tokenId.firstTokenInDrop() <= tokenId &&
            tokenId.mintId() < _mintedInDrop(tokenId.dropId()) &&
            !_ownerships[tokenId].burned;
    }

    function _safeMint(
        address to,
        uint128 dropId,
        uint128 quantity,
        uint8 freezePeriod
    ) internal {
        _safeMint(to, dropId, quantity, freezePeriod, "");
    }

    /**
     * @dev Safely mints `quantity` tokens and transfers them to `to`.
     *
     * Requirements:
     *
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
     * - `quantity` must be greater than 0.
     *
     * Emits a {Transfer} event.
     */
    function _safeMint(
        address to,
        uint128 dropId,
        uint128 quantity,
        uint8 freezePeriod,
        bytes memory _data
    ) internal {
        _mint(to, dropId, quantity, freezePeriod, _data, true);
    }

    /**
     * @dev Mints `quantity` tokens and transfers them to `to`.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `quantity` must be greater than 0.
     *
     * Emits a {Transfer} event.
     */
    function _mint(
        address to,
        uint128 dropId,
        uint128 quantity,
        uint8 freezePeriod,
        bytes memory _data,
        bool safe
    ) internal {
        if (_minted[dropId] == 0) _minted[dropId] = 1; //If drop is not preallocated
        uint128 minted = _mintedInDrop(dropId);
        uint256 startTokenId = TokenId.from(dropId, minted);
        if (to == address(0)) revert MintToZeroAddress();
        if (quantity == 0) revert MintZeroQuantity();

        _beforeTokenTransfers(address(0), to, startTokenId, quantity);

        // Overflows are incredibly unrealistic.
        // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
        // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
        unchecked {
            // New customer so delete a storage item to "refund" 15k gas
            // freeGasSlots(1);

            _addressData[to].balance += uint64(quantity);
            _addressData[to].numberMinted += uint64(quantity);
            _addressData[to].aux = 0;
            _supplyCounter += quantity;
            _ownerships[startTokenId].addr = to;
            _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
            _ownerships[startTokenId].freezePeriod = freezePeriod;
            _ownerships[startTokenId]._unused = 0;
            uint128 updatedIndex = minted;
            uint128 end = updatedIndex + quantity;
            if (safe && to.isContract()) {
                do {
                    uint256 tokenId = TokenId.from(dropId, updatedIndex++);
                    // console.log(tokenId);
                    emit Transfer(address(0), to, tokenId);
                    if (
                        !_checkContractOnERC721Received(
                            address(0),
                            to,
                            tokenId,
                            _data
                        )
                    ) {
                        revert TransferToNonERC721ReceiverImplementer();
                    }
                } while (updatedIndex != end);
                // Reentrancy protection
                if (minted != startTokenId.mintId()) revert();
            } else {
                do {
                    uint256 tokenId = TokenId.from(dropId, updatedIndex++);
                    // console.log(tokenId);
                    emit Transfer(address(0), to, tokenId);
                } while (updatedIndex != end);
            }
            _minted[dropId] = updatedIndex + 1;
        }
        _afterTokenTransfers(address(0), to, startTokenId, quantity);
        // console.log(gasleft());
    }

    /**
     * @dev Create storage slot entries for tokens upfront to reduce minting costs at purchase
     *
     * Requirements:
     *
     * - `quantity` must be greater than 0.
     *
     */
    function _preAllocateTokens(uint128 dropId, uint128 quantity) internal {
        if (quantity == 0) revert MintZeroQuantity();

        unchecked {
            // _supplyCounter = _supplyCounter;
            _minted[dropId] = _minted[dropId] >= 1 ? _minted[dropId] : 1;
            // reserveGasSlots(quantity);
            uint128 minted = _mintedInDrop(dropId);
            uint256 startTokenId = TokenId.from(dropId, minted);
            uint256 endTokenId = TokenId.from(dropId, minted + quantity - 1);
            uint256 currentTokenId = startTokenId;
            do {
                // console.log(currentTokenId);
                _ownerships[currentTokenId++]._unused = 1;
            } while (currentTokenId <= endTokenId);
        }
    }

    /**
     * @dev Create storage slots upfront for new addresses
     */
    function _preAllocateAddresses(address[] calldata addresses) internal {
        uint256 currentAddress = 0;
        unchecked {
            do {
                if (addresses[currentAddress] == address(0))
                    revert AddressZeroNotValid();
                _addressData[addresses[currentAddress++]].aux = 1;
            } while (currentAddress < addresses.length);
        }
    }

    // /**
    //  * @dev Create some arbitrary storage slots we can delete later to refund gas and reduce at purchase minting
    //  *
    //  * Requirements:
    //  *
    //  * - `quantity` must be greater than 0.
    //  *
    //  */
    // function _topUpGasRefunds() internal {
    //     if (_maxGasRefunds > 0 && _availableGasRefunds < _maxGasRefunds) {
    //         unchecked {
    //             do {
    //                 _gasRefunds[_availableGasRefunds++];
    //             } while (_availableGasRefunds < _maxGasRefunds);
    //         }
    //     }
    // }

    // Mints `value` new sub-tokens (e.g. cents, pennies, ...) by filling up
    // `value` words of EVM storage. The minted tokens are owned by the
    // caller of this function.
    function reserveGasSlots(uint256 value) public {
        uint256 gas_location = GAS_REFUNDS_LOCATION; // can't use constants inside assembly

        if (value == 0) {
            return;
        }

        // Read supply
        uint256 supply;
        assembly {
            supply := sload(gas_location)
        }

        // Set memory locations in interval [l, r]
        uint256 l = gas_location + supply + 1;
        uint256 r = gas_location + supply + value;
        assert(r >= l);

        for (uint256 i = l; i <= r; i++) {
            assembly {
                sstore(i, 1)
            }
        }

        // Write updated supply & balance
        assembly {
            sstore(gas_location, add(supply, value))
        }
    }

    function freeGasSlots(uint256 value) public {
        uint256 gas_location = GAS_REFUNDS_LOCATION; // can't use constants inside assembly

        // Read supply
        uint256 supply;
        assembly {
            supply := sload(gas_location)
        }
        if (supply == 0) return;

        // Clear memory locations in interval [l, r]
        uint256 l = gas_location + supply - value + 1;
        uint256 r = gas_location + supply;
        for (uint256 i = l; i <= r; i++) {
            assembly {
                sstore(i, 0)
            }
        }

        // Write updated supply
        assembly {
            sstore(gas_location, sub(supply, value))
        }
    }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     *
     * Emits a {Transfer} event.
     */
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) private {
        TokenOwnership memory prevOwnership = _ownershipOf(tokenId);

        if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
        if (
            block.timestamp <=
            (prevOwnership.startTimestamp + (prevOwnership.freezePeriod * 60))
        ) revert TokenFrozenForFraudPeriod();

        bool isApprovedOrOwner = (_msgSender() == from ||
            isApprovedForAll(from, _msgSender()) ||
            getApproved(tokenId) == _msgSender());

        if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
        if (to == address(0)) revert TransferToZeroAddress();

        _beforeTokenTransfers(from, to, tokenId, 1);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId, from);

        // Underflow of the sender's balance is impossible because we check for
        // ownership above and the recipient's balance can't realistically overflow.
        // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
        unchecked {
            _addressData[from].balance -= 1;
            _addressData[to].balance += 1;

            TokenOwnership storage currSlot = _ownerships[tokenId];
            currSlot.addr = to;
            currSlot.startTimestamp = uint64(block.timestamp);
            currSlot.freezePeriod = 0;

            // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
            // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
            uint256 nextTokenId = tokenId + 1;
            TokenOwnership storage nextSlot = _ownerships[nextTokenId];
            if (nextSlot.addr == address(0)) {
                // This will suffice for checking _exists(nextTokenId),
                // as a burned slot cannot contain the zero address.
                if (nextTokenId.mintId() != _mintedInDrop(tokenId.dropId())) {
                    nextSlot.addr = from;
                    nextSlot.startTimestamp = prevOwnership.startTimestamp;
                }
            }
        }

        emit Transfer(from, to, tokenId);
        _afterTokenTransfers(from, to, tokenId, 1);
    }

    /**
     * @dev This is equivalent to _burn(tokenId, false)
     */
    function _burn(uint256 tokenId) internal virtual {
        _burn(tokenId, false);
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
        TokenOwnership memory prevOwnership = _ownershipOf(tokenId);

        address from = prevOwnership.addr;

        if (approvalCheck) {
            bool isApprovedOrOwner = (_msgSender() == from ||
                isApprovedForAll(from, _msgSender()) ||
                getApproved(tokenId) == _msgSender());

            if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
            //TODO: Check if we need this on burn
            if (
                block.timestamp <=
                (prevOwnership.startTimestamp +
                    (prevOwnership.freezePeriod * 60))
            ) revert TokenFrozenForFraudPeriod();
        }

        _beforeTokenTransfers(from, address(0), tokenId, 1);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId, from);

        // Underflow of the sender's balance is impossible because we check for
        // ownership above and the recipient's balance can't realistically overflow.
        // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
        uint128 dropId = tokenId.dropId();
        unchecked {
            AddressData storage addressData = _addressData[from];
            addressData.balance -= 1;
            addressData.numberBurned += 1;

            // Keep track of who burned the token, and the timestamp of burning.
            TokenOwnership storage currSlot = _ownerships[tokenId];
            currSlot.addr = from;
            currSlot.startTimestamp = uint64(block.timestamp);
            currSlot.freezePeriod = 0;
            currSlot.burned = true;

            // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
            // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
            uint256 nextTokenId = tokenId + 1;
            TokenOwnership storage nextSlot = _ownerships[nextTokenId];
            if (nextSlot.addr == address(0)) {
                // This will suffice for checking _exists(nextTokenId),
                // as a burned slot cannot contain the zero address.
                if (nextTokenId.mintId() < _mintedInDrop(dropId)) {
                    nextSlot.addr = from;
                    nextSlot.startTimestamp = prevOwnership.startTimestamp;
                }
            }
        }

        emit Transfer(from, address(0), tokenId);
        _afterTokenTransfers(from, address(0), tokenId, 1);

        // Underflow should be impossible as supplyCounter is increased for every mint
        unchecked {
            _supplyCounter--;
        }
    }

    /**
     * @dev Approve `to` to operate on `tokenId`
     *
     * Emits a {Approval} event.
     */
    function _approve(
        address to,
        uint256 tokenId,
        address owner
    ) private {
        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkContractOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        try
            IERC721ReceiverUpgradeable(to).onERC721Received(
                _msgSender(),
                from,
                tokenId,
                _data
            )
        returns (bytes4 retval) {
            return
                retval ==
                IERC721ReceiverUpgradeable(to).onERC721Received.selector;
        } catch (bytes memory reason) {
            if (reason.length == 0) {
                revert TransferToNonERC721ReceiverImplementer();
            } else {
                assembly {
                    revert(add(32, reason), mload(reason))
                }
            }
        }
    }

    /**
     * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
     * And also called before burning one token.
     *
     * startTokenId - the first token id to be transferred
     * quantity - the amount to be transferred
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
     * transferred to `to`.
     * - When `from` is zero, `tokenId` will be minted for `to`.
     * - When `to` is zero, `tokenId` will be burned by `from`.
     * - `from` and `to` are never both zero.
     */
    function _beforeTokenTransfers(
        address from,
        address to,
        uint256 startTokenId,
        uint256 quantity
    ) internal virtual {}

    /**
     * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
     * minting.
     * And also called after one token has been burned.
     *
     * startTokenId - the first token id to be transferred
     * quantity - the amount to be transferred
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
     * transferred to `to`.
     * - When `from` is zero, `tokenId` has been minted for `to`.
     * - When `to` is zero, `tokenId` has been burned by `from`.
     * - `from` and `to` are never both zero.
     */
    function _afterTokenTransfers(
        address from,
        address to,
        uint256 startTokenId,
        uint256 quantity
    ) internal virtual {}

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[42] private __gap;
}
