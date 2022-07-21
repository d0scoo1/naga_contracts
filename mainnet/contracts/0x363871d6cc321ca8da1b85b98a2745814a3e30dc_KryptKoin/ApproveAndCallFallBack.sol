// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.4.26;


contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}
