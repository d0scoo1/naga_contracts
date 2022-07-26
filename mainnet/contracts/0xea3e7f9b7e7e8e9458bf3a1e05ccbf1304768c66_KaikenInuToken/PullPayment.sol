pragma solidity ^0.4.24;


import "./SafeMath.sol";


contract PullPayment {
    using SafeMath for uint256;

    mapping (address => uint256) public payments;

    uint256 public totalPayments;

    /**
    * @dev withdraw accumulated balance, called by payee.
    */
    function withdrawPayments() internal {
        uint256 payment = payments[msg.sender];

        require(payment != 0);
        require(address(this).balance >= payment);

        totalPayments = totalPayments.sub(payment);
        payments[msg.sender] = 0;

        msg.sender.transfer(payment);
    }
    /**
    * @dev Called by the payer to store the sent amount as credit to be pulled.
    * @param dest The destination address of the funds.
    * @param amount The amount to transfer.
    */
    function asyncSend(address dest, uint256 amount) internal {
        payments[dest] = payments[dest].add(amount);
        totalPayments = totalPayments.add(amount);
    }


}
