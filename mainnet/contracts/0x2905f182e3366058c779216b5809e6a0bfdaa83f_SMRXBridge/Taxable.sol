// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./Ownable.sol";

/**
 * @dev Contract module which provides a basic taxable transactions mechanism.
 *
 * By default, the transaction tax will be the one specified in the contract
 * constructor when it is deployed. This can later be changed with {changeTax}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `taxable`, which can be applied to your functions to make their taxable.
 */
abstract contract Taxable is Ownable {
    uint256 private _tax;
    mapping(address => uint256) private _taxes;

    event TaxChanged(uint256 indexed previousTax, uint256 indexed newTax);
    event TaxDeposit(address indexed from, uint256 value);
    event TaxPayment(address indexed from, uint256 value);

    constructor(uint256 newTax) Ownable() {
        _tax = newTax;
    }

    function tax() public view virtual returns (uint256) {
        return _tax;
    }

    function taxOf(address account) public view virtual returns (uint256) {
        return _taxes[account];
    }

    function payTax() public virtual payable returns (bool) {
        uint256 amount = msg.value;
        if (amount > 0) {
            payable(owner()).transfer(amount);
            _taxes[_msgSender()] += amount;
            emit TaxDeposit(_msgSender(), amount);
        }
        return true;
    }

    modifier taxable() {
        payTax();
        require(_taxes[_msgSender()] >= _tax, "Taxable: No tax paid");
        _taxes[_msgSender()] -= _tax;
        emit TaxPayment(_msgSender(), _tax);
        _;
    }

    function changeTax(uint256 newTax) public virtual onlyOwner returns (bool) {
        uint256 oldTax = _tax;
        _tax = newTax;
        emit TaxChanged(oldTax, newTax);
        return true;
    }
}
