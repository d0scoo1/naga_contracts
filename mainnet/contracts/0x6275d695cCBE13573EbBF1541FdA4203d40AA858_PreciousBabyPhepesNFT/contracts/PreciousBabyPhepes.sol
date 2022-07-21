// SPDX-License-Identifier: MIT
// Precious Phepes contracts v1.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @dev Implementation of the basic standard multi-token.
 * See https://eips.ethereum.org/EIPS/eip-1155
 * Originally based on code by Enjin: https://github.com/enjin/erc-1155
 *
 * _Available since v3.1._
 */
contract PreciousBabyPhepesNFT is
    ERC165,
    IERC1155,
    IERC1155MetadataURI,
    Ownable
{
    using Address for address;
    using Counters for Counters.Counter;

    uint256 public constant FREE_SUPPLY = 900;
    uint256 public constant MAX_SUPPLY_PLUS_ONE = 4445; // start counting at 1, don't use <= equations
    uint256 public constant MAX_FREE_MINT_PER_WALLET = 1; // Mint allowance per wallet on free mint

    Counters.Counter private _tokenIdCounter;

    address[MAX_SUPPLY_PLUS_ONE] internal _owners; // start counting at 1

    // Mapping from account to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
    string private _uri;

    // Precious Baby Phepes mint price
    uint256 public price = 0.047 ether;

    // Track mints per wallet to restrict to a given number
    mapping(address => uint256) private _mintsPerWallet;

    // Tracking mint status
    bool private _paused = true;

    // Contract name
    string public name;
    // Contract symbol
    string public symbol;

    /**
     * @dev See {_setURI}.
     */
    constructor(
        string memory uri_,
        string memory name_,
        string memory symbol_
    ) {
        name = name_;
        symbol = symbol_;
        _setURI(uri_);
    }

    /**
     * Sets a new mint price for the public mint.
     */
    function setMintPrice(uint256 newPrice) public onlyOwner {
        price = newPrice;
    }

    /**
     * Returns the paused state for the contract.
     */
    function isPaused() public view returns (bool) {
        return _paused;
    }

    /**
     * Sets the paused state for the contract.
     *
     * Pausing the contract also stops all minting options.
     */
    function setPaused(bool paused_) public onlyOwner {
        _paused = paused_;
    }

    /**
     * @dev See {_setURI}
     */
    function setUri(string memory newUri) public onlyOwner {
        _setURI(newUri);
    }

    /**
     * Free Mint
     *
     * The first 900 token are provided to the community for free.
     * After that, this function can no longer be used.
     */
    function mintFree() public {
        require(tx.origin == msg.sender, "Phepes: We love People.");
        require(_paused == false, "Phepes: Minting is paused");
        require(
            _tokenIdCounter.current() < FREE_SUPPLY,
            "Phepes: All free mints are gone"
        );
        require(
            _mintsPerWallet[_msgSender()] < MAX_FREE_MINT_PER_WALLET,
            "Phepes: Exceeding max free mints"
        );

        _mintsPerWallet[_msgSender()] = _mintsPerWallet[_msgSender()] + 1;

        _tokenIdCounter.increment();
        uint256 nextTokenId = _tokenIdCounter.current();
        _mint(_msgSender(), nextTokenId, 1, "");
    }

    /**
     * Public Mint
     *
     * Allows minting publicly ones all free mints have been picked up.
     * There are no limits on the amounts.
     */
    function mintPublic(uint256 amount) public payable {
        require(tx.origin == msg.sender, "Phepes: We love People.");
        require(_paused == false, "Phepes: Minting is paused");
        require(
            _tokenIdCounter.current() >= FREE_SUPPLY,
            "Phepes: Free mint in progress"
        );
        require(msg.value == price * amount, "Phepes: Wrong mint price");
        require(
            _tokenIdCounter.current() + amount < MAX_SUPPLY_PLUS_ONE,
            "Phepes: Max supply exceeded"
        );
        uint256 nextTokenId;

        for (uint256 i = 0; i < amount; i++) {
            _tokenIdCounter.increment();
            nextTokenId = _tokenIdCounter.current();
            _mint(_msgSender(), nextTokenId, 1, "");
        }
    }

    /**
     * Mint Giveaways (only Owner)
     *
     * Option for the owner to mint leftover token to be used in giveaways.
     */
    function mintGiveaway(address to_, uint256 amount) public onlyOwner {
        require(_paused == false, "Phepes: Minting is paused");
        require(
            _tokenIdCounter.current() < MAX_SUPPLY_PLUS_ONE,
            "Phepes: Max supply exceeded"
        );
        uint256 nextTokenId;

        for (uint256 i = 0; i < amount; i++) {
            _tokenIdCounter.increment();
            nextTokenId = _tokenIdCounter.current();
            _mint(to_, nextTokenId, 1, "");
        }
    }

    /**
     * Withdraws all retrieved funds into the project team wallets.
     *
     * Splits the funds 90/10 for owner/dev.
     */
    function withdraw() public onlyOwner {
        // Splits the received funds into portions of 90 for the owner and 10 for the developer.
        uint256 totalBalance = address(this).balance;

        uint256 devBalance = totalBalance / 10;
        uint256 remainderBalance = totalBalance - devBalance;

        Address.sendValue(
            payable(0x61FffDbAAfCBb2E8f35B09C58C3EAeECb37c8E67),
            devBalance
        );
        Address.sendValue(payable(_msgSender()), remainderBalance);
    }

    /**
     * Returns the number of minted tokens.
     */
    function totalSupply() public view returns (uint256) {
        return _tokenIdCounter.current();
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC165, IERC165)
        returns (bool)
    {
        return
            interfaceId == type(IERC1155).interfaceId ||
            interfaceId == type(IERC1155MetadataURI).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC1155MetadataURI-uri}.
     *
     * This implementation returns the same URI for *all* token types. It relies
     * on the token type ID substitution mechanism
     * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
     *
     * Clients calling this function must replace the `\{id\}` substring with the
     * actual token type ID.
     */
    function uri(uint256) public view virtual override returns (string memory) {
        return _uri;
    }

    /**
     * @dev See {IERC1155-balanceOf}.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOf(address account, uint256 id)
        public
        view
        virtual
        override
        returns (uint256)
    {
        require(
            account != address(0),
            "ERC1155: balance query for the zero address"
        );
        require(id < MAX_SUPPLY_PLUS_ONE, "ERC1155D: id exceeds maximum");

        return _owners[id] == account ? 1 : 0;
    }

    /**
     * @dev See {IERC1155-balanceOfBatch}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
    function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
        public
        view
        virtual
        override
        returns (uint256[] memory)
    {
        require(
            accounts.length == ids.length,
            "ERC1155: accounts and ids length mismatch"
        );

        uint256[] memory batchBalances = new uint256[](accounts.length);

        for (uint256 i = 0; i < accounts.length; ++i) {
            batchBalances[i] = balanceOf(accounts[i], ids[i]);
        }

        return batchBalances;
    }

    /**
     * @dev See {IERC1155-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved)
        public
        virtual
        override
    {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC1155-isApprovedForAll}.
     */
    function isApprovedForAll(address account, address operator)
        public
        view
        virtual
        override
        returns (bool)
    {
        return _operatorApprovals[account][operator];
    }

    /**
     * @dev See {IERC1155-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public virtual override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: caller is not owner nor approved"
        );
        _safeTransferFrom(from, to, id, amount, data);
    }

    /**
     * @dev See {IERC1155-safeBatchTransferFrom}.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: transfer caller is not owner nor approved"
        );
        _safeBatchTransferFrom(from, to, ids, amounts, data);
    }

    /**
     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `from` must have a balance of tokens of type `id` of at least `amount`.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function _safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) internal virtual {
        require(to != address(0), "ERC1155: transfer to the zero address");

        address operator = _msgSender();
        uint256[] memory ids = _asSingletonArray(id);
        uint256[] memory amounts = _asSingletonArray(amount);

        _beforeTokenTransfer(operator, from, to, ids, amounts, data);

        require(
            _owners[id] == from && amount < 2,
            "ERC1155: insufficient balance for transfer"
        );

        // The ERC1155 spec allows for transfering zero tokens, but we are still expected
        // to run the other checks and emit the event. But we don't want an ownership change
        // in that case
        if (amount == 1) {
            _owners[id] = to;
        }

        emit TransferSingle(operator, from, to, id, amount);

        _afterTokenTransfer(operator, from, to, ids, amounts, data);

        _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
    }

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function _safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {
        require(
            ids.length == amounts.length,
            "ERC1155: ids and amounts length mismatch"
        );
        require(to != address(0), "ERC1155: transfer to the zero address");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, from, to, ids, amounts, data);

        for (uint256 i = 0; i < ids.length; ++i) {
            uint256 id = ids[i];

            require(
                _owners[id] == from && amounts[i] < 2,
                "ERC1155: insufficient balance for transfer"
            );

            if (amounts[i] == 1) {
                _owners[id] == to;
            }
        }

        emit TransferBatch(operator, from, to, ids, amounts);

        _afterTokenTransfer(operator, from, to, ids, amounts, data);

        _doSafeBatchTransferAcceptanceCheck(
            operator,
            from,
            to,
            ids,
            amounts,
            data
        );
    }

    /**
     * @dev Sets a new URI for all token types, by relying on the token type ID
     * substitution mechanism
     * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
     *
     * By this mechanism, any occurrence of the `\{id\}` substring in either the
     * URI or any of the amounts in the JSON file at said URI will be replaced by
     * clients with the token type ID.
     *
     * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
     * interpreted by clients as
     * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
     * for token type ID 0x4cce0.
     *
     * See {uri}.
     *
     * Because these URIs cannot be meaningfully represented by the {URI} event,
     * this function emits no events.
     */
    function _setURI(string memory newuri) internal virtual {
        _uri = newuri;
    }

    /**
     * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */

    function _mint(
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) internal virtual {
        require(to != address(0), "ERC1155: mint to the zero address");
        require(amount < 2, "ERC1155D: exceeds supply");
        require(id < MAX_SUPPLY_PLUS_ONE, "ERC1155D: invalid id");

        address operator = _msgSender();
        uint256[] memory ids = _asSingletonArray(id);
        uint256[] memory amounts = _asSingletonArray(amount);

        _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);

        // The ERC1155 spec allows for transfering zero tokens, but we are still expected
        // to run the other checks and emit the event. But we don't want an ownership change
        // in that case
        if (amount == 1) {
            _owners[id] = to;
        }

        emit TransferSingle(operator, address(0), to, id, amount);

        _afterTokenTransfer(operator, address(0), to, ids, amounts, data);

        _doSafeTransferAcceptanceCheck(
            operator,
            address(0),
            to,
            id,
            amount,
            data
        );
    }

    /**
     * @dev Destroys `amount` tokens of token type `id` from `from`
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `from` must have at least `amount` tokens of token type `id`.
     */
    function _burn(
        address from,
        uint256 id,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC1155: burn from the zero address");

        address operator = _msgSender();
        uint256[] memory ids = _asSingletonArray(id);
        uint256[] memory amounts = _asSingletonArray(amount);

        _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");

        require(
            _owners[id] == from && amount < 2,
            "ERC1155: burn amount exceeds balance"
        );
        if (amount == 1) {
            _owners[id] = address(0);
        }

        emit TransferSingle(operator, from, address(0), id, amount);

        _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
    }

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     */
    function _burnBatch(
        address from,
        uint256[] memory ids,
        uint256[] memory amounts
    ) internal virtual {
        require(from != address(0), "ERC1155: burn from the zero address");
        require(
            ids.length == amounts.length,
            "ERC1155: ids and amounts length mismatch"
        );

        address operator = _msgSender();

        _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");

        for (uint256 i = 0; i < ids.length; i++) {
            uint256 id = ids[i];
            require(
                _owners[id] == from && amounts[i] < 2,
                "ERC1155: burn amount exceeds balance"
            );
            if (amounts[i] == 1) {
                _owners[id] = address(0);
            }
        }

        emit TransferBatch(operator, from, address(0), ids, amounts);

        _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
    }

    /**
     * @dev Approve `operator` to operate on all of `owner` tokens
     *
     * Emits a {ApprovalForAll} event.
     */
    function _setApprovalForAll(
        address owner_,
        address operator,
        bool approved
    ) internal virtual {
        require(
            owner_ != operator,
            "ERC1155: setting approval status for self"
        );
        _operatorApprovals[owner_][operator] = approved;
        emit ApprovalForAll(owner_, operator, approved);
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning, as well as batched variants.
     *
     * The same hook is called on both single and batched variants. For single
     * transfers, the length of the `id` and `amount` arrays will be 1.
     *
     * Calling conditions (for each `id` and `amount` pair):
     *
     * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * of token type `id` will be  transferred to `to`.
     * - When `from` is zero, `amount` tokens of token type `id` will be minted
     * for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
     * will be burned.
     * - `from` and `to` are never both zero.
     * - `ids` and `amounts` have the same, non-zero length.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {}

    /**
     * @dev Hook that is called after any token transfer. This includes minting
     * and burning, as well as batched variants.
     *
     * The same hook is called on both single and batched variants. For single
     * transfers, the length of the `id` and `amount` arrays will be 1.
     *
     * Calling conditions (for each `id` and `amount` pair):
     *
     * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * of token type `id` will be  transferred to `to`.
     * - When `from` is zero, `amount` tokens of token type `id` will be minted
     * for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
     * will be burned.
     * - `from` and `to` are never both zero.
     * - `ids` and `amounts` have the same, non-zero length.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {}

    function _doSafeTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) private {
        if (to.isContract()) {
            try
                IERC1155Receiver(to).onERC1155Received(
                    operator,
                    from,
                    id,
                    amount,
                    data
                )
            returns (bytes4 response) {
                if (response != IERC1155Receiver.onERC1155Received.selector) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non ERC1155Receiver implementer");
            }
        }
    }

    function _doSafeBatchTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) private {
        if (to.isContract()) {
            try
                IERC1155Receiver(to).onERC1155BatchReceived(
                    operator,
                    from,
                    ids,
                    amounts,
                    data
                )
            returns (bytes4 response) {
                if (
                    response != IERC1155Receiver.onERC1155BatchReceived.selector
                ) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non ERC1155Receiver implementer");
            }
        }
    }

    function _asSingletonArray(uint256 element)
        internal
        pure
        returns (uint256[] memory)
    {
        uint256[] memory array = new uint256[](1);
        array[0] = element;

        return array;
    }

    function getOwnershipRecordOffChain()
        external
        view
        returns (address[MAX_SUPPLY_PLUS_ONE] memory)
    {
        return _owners;
    }

    function ownerOfERC721Like(uint256 id) external view returns (address) {
        require(id < _owners.length, "ERC1155D: id exceeds maximum");
        address owner_ = _owners[id];
        require(
            owner_ != address(0),
            "ERC1155D: owner query for nonexistent token"
        );
        return owner_;
    }

    function getERC721BalanceOffChain(address _address)
        external
        view
        returns (uint256)
    {
        uint256 counter = 0;
        for (uint256 i; i < _owners.length; i++) {
            if (_owners[i] == _address) {
                counter++;
            }
        }
        return counter;
    }
}
