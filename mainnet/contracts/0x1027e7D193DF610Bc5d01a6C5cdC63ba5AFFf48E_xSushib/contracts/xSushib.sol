// SPDX-License-Identifier: MIT

pragma solidity 0.8.3;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract xSushib is ERC20, Ownable {
    event SetSigner(address indexed signer);
    event Claim(address indexed account, uint256 amount, address indexed to);

    address public signer;
    mapping(address => bool) public claimed;

    constructor() ERC20("xSushib Token", "xSUSHIB") public {
        signer = msg.sender;
    }

    function decimals() public view override returns (uint8) {
        return 0;
    }

    function setSigner(address _signer) public onlyOwner {
        signer = _signer;

        emit SetSigner(_signer);
    }

    function claim(address account, uint256 amount, uint8 v, bytes32 r, bytes32 s, address to) external {
        require(!claimed[account], "xSUSHIB: ALREADY_CLAIMED");
        bytes32 hash = keccak256(abi.encode(account, amount));
        require(ECDSA.recover(ECDSA.toEthSignedMessageHash(hash), v, r, s) == signer, "xSUSHIB: INVALID_SIGNATURE");
        claimed[account] = true;
        _mint(to, amount);

        emit Claim(account, amount, to);
    }
}
