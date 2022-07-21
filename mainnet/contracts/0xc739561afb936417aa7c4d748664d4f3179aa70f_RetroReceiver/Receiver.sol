// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import { Ownable } from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import { ERC20 } from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import { ERC721 } from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

/**
 * @title RetroReceiver
 * @notice RetroReceiver is a minimal contract for receiving funds, meant to be deployed at the
 * same address on every chain that supports EIP-2470.
 */
contract RetroReceiver is Ownable {
    constructor() {
        // Use tx.origin instead of msg.sender since the sender will be the EIP-2470 singleton
        // factory. If we use a constructor param then the contract address will change depending
        // on the initial owner, which we don't want. Origin can then transfer ownership to the
        // correct address.
        _transferOwnership(tx.origin);
    }

    /**
     * Withdraws full ETH balance to the recipient.
     *
     * @param _to Address to receive the ETH balance.
     */
    function withdrawETH(
        address payable _to
    )
        public
        onlyOwner
    {
        _to.transfer(address(this).balance);
    }

    /**
     * Withdraws partial ETH balance to the recipient.
     *
     * @param _to Address to receive the ETH balance.
     * @param _amount Amount of ETH to withdraw.
     */
    function withdrawETH(
        address payable _to,
        uint256 _amount
    )
        public
        onlyOwner
    {
        _to.transfer(_amount);
    }

    /**
     * Withdraws full ERC20 balance to the recipient.
     *
     * @param _asset ERC20 token to withdraw.
     * @param _to Address to receive the ERC20 balance.
     */
    function withdrawERC20(
        ERC20 _asset,
        address _to
    )
        public
        onlyOwner
    {
        _asset.transfer(_to, _asset.balanceOf(address(this)));
    }

    /**
     * Withdraws partial ERC20 balance to the recipient.
     *
     * @param _asset ERC20 token to withdraw.
     * @param _to Address to receive the ERC20 balance.
     * @param _amount Amount of ERC20 to withdraw.
     */
    function withdrawERC20(
        ERC20 _asset,
        address _to,
        uint256 _amount
    )
        public
        onlyOwner
    {
        _asset.transfer(_to, _amount);
    }

    /**
     * Withdraws ERC721 token to the recipient.
     *
     * @param _asset ERC721 token to withdraw.
     * @param _to Address to receive the ERC721 token.
     * @param _id Token ID of the ERC721 token to withdraw.
     */
    function withdrawERC721(
        ERC721 _asset,
        address _to,
        uint256 _id
    )
        public
        onlyOwner
    {
        _asset.transferFrom(address(this), _to, _id);
    }

    /**
     * Backup function for making arbitrary transactions from this contract.
     *
     * @param _delegate Whether or not to use delegatecall.
     * @param _to Address to send the transaction to.
     * @param _value Amount of ETH to send with the transaction.
     * @param _data Data to send with the transaction.
     * @return Success of the transaction as a boolean.
     * @return Data returned by the target address.
     */
    function transact(
        bool _delegate,
        address _to,
        uint256 _value,
        bytes memory _data
    )
        public
        onlyOwner
        returns (
            bool,
            bytes memory
        )
    {
        if (_delegate) {
            return _to.delegatecall(_data);
        } else {
            return _to.call{value: _value}(_data);
        }
    }
}
