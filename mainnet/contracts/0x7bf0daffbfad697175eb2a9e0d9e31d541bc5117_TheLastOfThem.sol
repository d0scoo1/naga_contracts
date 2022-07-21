/*                                                                                                                                           
░▀█▀░█░█░█▀▀░█░░░█▀█░█▀▀░▀█▀░█▀█░█▀▀░▀█▀░█░█░█▀▀░█▄█
░░█░░█▀█░█▀▀░█░░░█▀█░▀▀█░░█░░█░█░█▀▀░░█░░█▀█░█▀▀░█░█
░░▀░░▀░▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░░▀░░▀▀▀░▀░░░░▀░░▀░▀░▀▀▀░▀░▀                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
*/

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)

pragma solidity ^0.8.0;

/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length)
        internal
        pure
        returns (string memory)
    {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}

// OpenZeppelin Contracts v4.4.1 (utils/Address.sol)

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data)
        internal
        view
        returns (bytes memory)
    {
        return
            functionStaticCall(
                target,
                data,
                "Address: low-level static call failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return
            functionDelegateCall(
                target,
                data,
                "Address: low-level delegate call failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

/*********************************************
 *********************************************
 *  H e l p e r   c o n t r a c t s
 */

abstract contract ReentrancyGuard {
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;
    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
        _status = _ENTERED;
        _;
        _status = _NOT_ENTERED;
    }
}

abstract contract Ownable {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _transferOwnership(msg.sender);
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == msg.sender, "Caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Invalid address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

abstract contract Sale is Ownable {
    // not-active(0), presale(1), sale(2)
    uint8 private _saleState;
    uint256 private _priceSale;
    uint256 private _pricePresale;
    uint256 private _presaleListCount;
    uint256 private _presaleListCap;
    mapping(address => uint8) private _presaleList;
    event SaleStateChanged(uint8 indexed lastState, uint8 indexed newState);

    constructor() Ownable() {
        _saleState = 0;
        _presaleListCount = 0;
    }

    function setSaleState(uint8 _state) public onlyOwner {
        require(_state >= 0 && _state <= 2, "Invalid state");
        uint8 _lastState = _saleState;
        _saleState = _state;
        emit SaleStateChanged(_lastState, _state);
    }

    function saleState() public view virtual returns (uint8) {
        return _saleState;
    }

    function setPricePresale(uint256 _val) public onlyOwner {
        _pricePresale = _val;
    }

    function pricePresale() public view virtual returns (uint256) {
        return _pricePresale;
    }

    function setPriceSale(uint256 _val) public onlyOwner {
        _priceSale = _val;
    }

    function priceSale() public view virtual returns (uint256) {
        return _priceSale;
    }

    function setPresaleListCap(uint256 _cap) public onlyOwner {
        require(_cap >= 0, "Invalid capacity");
        _presaleListCap = _cap;
    }

    function presaleListCap() public view virtual returns (uint256) {
        return _presaleListCap;
    }

    function presaleListCount() public view virtual returns (uint256) {
        return _presaleListCount;
    }

    function presaleListCheck(address _addr)
        public
        view
        virtual
        returns (bool)
    {
        return _presaleList[_addr] > 0;
    }

    function presaleListAdd(address[] memory _addresses) public onlyOwner {
        uint256 len = _addresses.length;

        require(
            _presaleListCount + len <= _presaleListCap,
            "Presale list will overflow"
        );

        for (uint256 i = 0; i < len; i++) {
            _presaleList[_addresses[i]] = 1;
            _presaleListCount++;
        }
    }

    function presaleListRemove(address[] memory _addresses) public onlyOwner {
        uint256 len = _addresses.length;

        for (uint256 i = 0; i < len; i++) {
            _presaleList[_addresses[i]] = 0;
            _presaleListCount--;
        }
    }
}

/*********************************************
 *********************************************
 *  I n t e r f a c e s
 */

interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC2981 {
    function royaltyInfo(uint256 tokenId, uint256 salePrice)
        external
        view
        returns (address receiver, uint256 royaltyAmount);
}

interface IERC721Metadata {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function tokenURI(uint256 tokenId) external view returns (string memory);
}

interface IERC721 {
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );

    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    function balanceOf(address owner) external view returns (uint256 balance);

    function ownerOf(uint256 tokenId) external view returns (address owner);

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function approve(address to, uint256 tokenId) external;

    function getApproved(uint256 tokenId)
        external
        view
        returns (address operator);

    function setApprovalForAll(address operator, bool _approved) external;

    function isApprovedForAll(address owner, address operator)
        external
        view
        returns (bool);
}

contract TheLastOfThem is
    IERC165,
    IERC721,
    IERC721Metadata,
    IERC2981,
    Sale,
    ReentrancyGuard
{
    using Strings for uint256;
    using Address for address;

    /*********************************************
     *********************************************
     *  P r i v a t e
     *      m e m b e r s
     *
     */

    string private _name;
    string private _symbol;
    string private _baseURI;
    bool private _baseURILocked;
    uint8 private _mintCap;
    uint8 private _mintCapPresale;
    uint256 private _maxSupply;
    uint256 private _maxSupplyPresale;
    mapping(uint256 => address) private _owners;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => uint256) private _balances;
    mapping(address => uint8) private _mintedPresale;
    mapping(address => uint8) private _minted;
    mapping(address => uint8) private _mintedOwner;
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    address private _royaltyAddr;
    uint256 private _royaltyBasis;
    uint256 private _lastTokenId;

    constructor() Sale() ReentrancyGuard() {
        _symbol = "TLOT";
        _name = "TheLastOfThem";
        _lastTokenId = 0;
        setPricePresale(0.04 ether);
        setPriceSale(0.05 ether);
        setMintCapPresale(100);
        setMintCap(120);
        setMaxSupplyPresale(500);
        setMaxSupply(4460);
        setPresaleListCap(30);
        setBaseURI("https://api.thelastofthem.org/nft/");
        setRoyalty(0x4d26e56C11eB83f6EB80aA1D0F7507a184ea7C4d, 1000);
    }

    /*********************************************
     *********************************************
     *  P u b l i c
     *      m e t h o d s
     *
     */

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function totalSupply() public view virtual returns (uint256) {
        return _lastTokenId;
    }

    function setRoyalty(address _addr, uint256 _val) public onlyOwner {
        require(_addr != address(0), "Invalid address");
        _royaltyAddr = _addr;
        _royaltyBasis = _val;
    }

    function royaltyInfo(uint256 _tokenId, uint256 _price)
        public
        view
        virtual
        override
        returns (address receiver, uint256 royaltyAmount)
    {
        if (_exists(_tokenId)) {
            return (_royaltyAddr, (_price * _royaltyBasis) / 10000);
        }

        return (_royaltyAddr, 0);
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(_exists(_tokenId), "URI query for nonexistent token");
        require(bytes(_baseURI).length > 0, "Base URI not set");
        return string(abi.encodePacked(_baseURI, _tokenId.toString(), ".json"));
    }

    function setBaseURI(string memory _val) public onlyOwner {
        require(!_baseURILocked, "baseURI is locked");
        _baseURI = _val;
    }

    function lockBaseURI() public onlyOwner {
        _baseURILocked = true;
    }

    function baseURI() public view virtual returns (string memory) {
        return _baseURI;
    }

    function setMaxSupplyPresale(uint256 _val) public onlyOwner {
        _maxSupplyPresale = _val;
    }

    function maxSupplyPresale() public view virtual returns (uint256) {
        return _maxSupplyPresale;
    }

    function setMaxSupply(uint256 _val) public onlyOwner {
        _maxSupply = _val;
    }

    function maxSupply() public view virtual returns (uint256) {
        return _maxSupply;
    }

    function setMintCapPresale(uint8 _cap) public onlyOwner {
        require(_cap >= 0, "Invalid capacity");
        _mintCapPresale = _cap;
    }

    function mintCapPresale() public view virtual returns (uint8) {
        return _mintCapPresale;
    }

    function setMintCap(uint8 _cap) public onlyOwner {
        require(_cap >= 0, "Invalid capacity");
        _mintCap = _cap;
    }

    function mintCap() public view virtual returns (uint8) {
        return _mintCap;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        pure
        virtual
        override
        returns (bool)
    {
        return
            interfaceId == type(IERC165).interfaceId ||
            interfaceId == type(IERC2981).interfaceId ||
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId;
    }

    function minted(address _addr)
        public
        view
        virtual
        returns (
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        uint256 total = _minted[_addr] +
            _mintedOwner[_addr] +
            _mintedPresale[_addr];

        return (
            total,
            _mintedOwner[_addr],
            _mintedPresale[_addr],
            _minted[_addr]
        );
    }

    function mint(uint8 _mintAmount) public payable {
        mintTo(_mintAmount, msg.sender);
    }

    function mintTo(uint8 _mintAmount, address _receiver)
        public
        payable
        nonReentrant
    {
        require(_receiver != address(0), "Invalid address");
        require(_lastTokenId < _maxSupply, "Sale completed");

        uint8 _state = saleState();

        require(_state == 1 || _state == 2, "Sale is not active");

        if (_state == 1) {
            _presaleMint(_mintAmount, _receiver);
        } else {
            _saleMint(_mintAmount, _receiver);
        }
    }

    function mintOwner(uint8 _mintAmount) public onlyOwner {
        mintOwnerTo(_mintAmount, msg.sender);
    }

    function mintOwnerTo(uint8 _mintAmount, address _receiver)
        public
        onlyOwner
        nonReentrant
    {
        require(_mintAmount > 0, "Invalid mint amount");
        require(_lastTokenId < _maxSupply, "Sale completed");
        require(
            _mintAmount + totalSupply() <= _maxSupply,
            "Max supply will overflow"
        );

        for (uint256 i = 0; i < _mintAmount; i++) {
            _lastTokenId++;
            _mintedOwner[_receiver] += 1;
            _mint(_receiver, _lastTokenId);
        }
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        require(
            _isApprovedOrOwner(msg.sender, tokenId),
            "Transfer caller is not owner nor approved"
        );

        _transfer(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(
            _isApprovedOrOwner(msg.sender, tokenId),
            "Transfer caller is not owner nor approved"
        );

        _safeTransfer(from, to, tokenId, _data);
    }

    function balanceOf(address checkedOwner)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _balances[checkedOwner];
    }

    function ownerOf(uint256 tokenId)
        public
        view
        virtual
        override
        returns (address)
    {
        return _owners[tokenId];
    }

    function walletOfOwner(address _addr)
        public
        view
        returns (uint256[] memory)
    {
        uint256 _tokenCount = balanceOf(_addr);
        uint256[] memory _output = new uint256[](_tokenCount);
        uint256 _supply = totalSupply();
        uint256 _idx = 0;

        for (uint256 _tokenId = 1; _tokenId <= _supply; _tokenId++) {
            if (_owners[_tokenId] == _addr) {
                _output[_idx] = _tokenId;
                _idx++;
            }
        }

        return _output;
    }

    function withdraw(address _addr, uint256 _amnt) public onlyOwner {
        require(_addr != address(0), "Invalid address");

        uint256 currentBalance = address(this).balance;
        uint256 withdrawn;

        if (_amnt == 0) {
            withdrawn = address(this).balance;
        } else {
            require(
                currentBalance >= _amnt,
                "Contract balance is less than withdrawn amount"
            );

            withdrawn = _amnt;
        }

        _withdraw(_addr, withdrawn);
    }

    function approve(address to, uint256 tokenId) public virtual override {
        address tokenOwner = ownerOf(tokenId);

        require(to != tokenOwner, "Approval to current owner");
        require(
            msg.sender == tokenOwner ||
                isApprovedForAll(tokenOwner, msg.sender),
            "Approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    function isApprovedForAll(address checkedOwner, address operator)
        public
        view
        virtual
        override
        returns (bool)
    {
        return _operatorApprovals[checkedOwner][operator];
    }

    function setApprovalForAll(address operator, bool approved)
        public
        virtual
        override
    {
        require(operator != msg.sender, "Approve to caller");
        
        _operatorApprovals[msg.sender][operator] = approved;

        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function getApproved(uint256 tokenId)
        public
        view
        virtual
        override
        returns (address)
    {
        return _tokenApprovals[tokenId];
    }

    /*********************************************
     *********************************************
     *  P r i v a t e
     *      m e t h o d s
     *
     */

    function _exists(uint256 tokenId) private view returns (bool) {
        return _owners[tokenId] != address(0);
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId)
        private
        view
        returns (bool)
    {
        require(_exists(tokenId), "Operator query for nonexistent token");

        address tokenOwner = ownerOf(tokenId);

        return (tokenOwner == spender ||
            getApproved(tokenId) == spender ||
            isApprovedForAll(tokenOwner, spender));
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}

    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private {
        _transfer(from, to, tokenId);

        require(
            _checkOnERC721Received(from, to, tokenId, _data),
            "Transfer to non ERC721Receiver implementer"
        );
    }

    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) private {
        require(to != address(0), "Invalid address");
        require(ownerOf(tokenId) == from, "Transfer of token that is not own");

        _beforeTokenTransfer(from, to, tokenId);
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    function _approve(address to, uint256 tokenId) private {
        _tokenApprovals[tokenId] = to;

        emit Approval(ownerOf(tokenId), to, tokenId);
    }

    function _withdraw(address _addr, uint256 _amt) private nonReentrant {
        (bool success, ) = _addr.call{value: _amt}("");

        require(success, "Transfer failed");
    }

    function _presaleMint(uint8 _mintAmount, address _receiver) private {
        require(presaleListCheck(_receiver), "Address not on the whitelist");

        require(
            _mintAmount > 0 && _mintAmount <= _mintCapPresale,
            "Invalid mint amount"
        );

        require(
            _mintAmount + _mintedPresale[_receiver] <= _mintCapPresale,
            "User mint amount will overflow"
        );

        require(
            _mintAmount + totalSupply() <= _maxSupplyPresale,
            "Presale supply will overflow"
        );

        require(
            msg.value >= pricePresale() * _mintAmount,
            "More funds required"
        );

        for (uint256 i = 0; i < _mintAmount; i++) {
            _lastTokenId++;
            _mintedPresale[_receiver] += 1;
            _mint(_receiver, _lastTokenId);
        }
    }

    function _saleMint(uint8 _mintAmount, address _receiver) private {
        require(
            _mintAmount > 0 && _mintAmount <= _mintCap,
            "Invalid mint amount"
        );

        require(
            _mintAmount + _minted[_receiver] <= _mintCap,
            "User mint amount will overflow"
        );

        require(
            _mintAmount + totalSupply() <= _maxSupply,
            "Max supply will overflow"
        );

        require(msg.value >= priceSale() * _mintAmount, "More funds required");

        for (uint256 i = 0; i < _mintAmount; i++) {
            _lastTokenId++;
            _minted[_receiver] += 1;
            _mint(_receiver, _lastTokenId);
        }
    }

    function _mint(address to, uint256 tokenId) private {
        require(!_exists(tokenId), "Token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);
        
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            try
                IERC721Receiver(to).onERC721Received(
                    msg.sender,
                    from,
                    tokenId,
                    _data
                )
            returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("Transfer to non ERC721Receiver implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }
}