// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "Ownable.sol";

interface IERC20 {
    function transfer(address _to, uint256 _amount) external returns (bool);

    function balanceOf(address account) external view returns (uint256);
}

abstract contract Withdrawable is Ownable {
    address public constant PAYABLE_ADDRESS = 0x27843db515259c720043aF957dEff77741BAd89B;

    function withdrawAll() public onlyOwner {
        require(address(this).balance > 0);
        _withdrawAll();
    }

    function _withdrawAll() private {
        uint256 balance = address(this).balance;

        _widthdraw(PAYABLE_ADDRESS, balance);
    }

    function _widthdraw(address _address, uint256 _amount) private {
        (bool success, ) = _address.call{value: _amount}("");
        require(success, "Transfer failed.");
    }

    /**
     * @dev Allow contract owner to withdraw ERC-20 balance from contract
     * while still splitting royalty payments to all other team members.
     * in the event ERC-20 tokens are paid to the contract.
     * @param _tokenContract contract of ERC-20 token to withdraw
     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
     */
    function withdrawAllERC20(address _tokenContract, uint256 _amount)
        public
        onlyOwner
    {
        require(_amount > 0);
        IERC20 tokenContract = IERC20(_tokenContract);
        require(
            tokenContract.balanceOf(address(this)) >= _amount,
            "Contract does not own enough tokens"
        );

        tokenContract.transfer(PAYABLE_ADDRESS,_amount);
    }
}