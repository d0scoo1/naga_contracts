// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

error HeyEdu_SimpleMinter_OnlyOwner();

import {IHeyEduToken} from "../interfaces/IHeyEduToken.sol";
import {IHeyEduMinter} from "../interfaces/IHeyEduMinter.sol";

contract SimpleMinter is IHeyEduMinter {
    address public immutable owner;
    IHeyEduToken public immutable token;

    constructor(address _owner, address _token) {
        owner = _owner;
        token = IHeyEduToken(_token);
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert HeyEdu_SimpleMinter_OnlyOwner();
        }
        _;
    }

    function mint(address to, uint256 value) external onlyOwner {
        token.mint(to, value);
    }
}
