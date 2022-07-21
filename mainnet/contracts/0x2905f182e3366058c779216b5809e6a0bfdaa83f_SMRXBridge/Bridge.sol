// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./Taxable.sol";

abstract contract Bridge is Taxable {
    mapping(bytes32 => bool) private _processedTx;

    event Deposit(address indexed from, uint256 value);
    event Withdraw(address indexed to, uint256 value, bytes32 otherChainTx);

    constructor(uint256 tax) Taxable(tax) {}

    function hasTxProcessed(bytes32 otherChainTx) public view virtual returns (bool) {
        return _processedTx[otherChainTx];
    }

    function deposit(uint256 amount) public virtual payable taxable returns (bool) {
        _deposit(amount);
        emit Deposit(_msgSender(), amount);
        return true;
    }

    function _deposit(uint256 amount) internal virtual {}

    function withdraw(
        address account,
        uint256 amount,
        bytes32 otherChainTx
    ) public virtual onlyOwner returns (bool) {
        require(
            _processedTx[otherChainTx] == false,
            "Bridge: Transfer already processed"
        );
        _withdraw(account, amount);
        _processedTx[otherChainTx] = true;
        emit Withdraw(account, amount, otherChainTx);
        return true;
    }

    function _withdraw(address account, uint256 amount) internal virtual {}
}
