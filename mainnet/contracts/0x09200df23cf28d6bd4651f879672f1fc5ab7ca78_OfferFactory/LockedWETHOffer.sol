// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.11;

import {IERC20, IWETHToken, IOwnable} from "./Interfaces.sol";

contract LockedWETHOffer {
    address public immutable factory;
    address public immutable seller;
    address public immutable tokenWanted;
    uint256 public immutable amountWanted;
    uint256 public immutable fee; // in bps
    bool public hasEnded = false;

    IWETHToken WETH = IWETHToken(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    event OfferFilled(address buyer, uint256 WETHAmount, address token, uint256 tokenAmount);
    event OfferCanceled(address seller, uint256 WETHAmount);

    constructor(
        address _seller,
        address _tokenWanted,
        uint256 _amountWanted,
        uint256 _fee
    ) {
        factory = msg.sender;
        seller = _seller;
        tokenWanted = _tokenWanted;
        amountWanted = _amountWanted;
        fee = _fee;
    }

    // release trapped funds
    function withdrawTokens(address token) public {
        require(msg.sender == IOwnable(factory).owner());
        if (token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
            payable(IOwnable(factory).owner()).transfer(address(this).balance);
        } else {
            uint256 balance = IERC20(token).balanceOf(address(this));
            safeTransfer(token, IOwnable(factory).owner(), balance);
        }
    }

    function fill() public {
        require(hasWETH(), "no WETH balance");
        require(!hasEnded, "sell has been previously cancelled");
        uint256 balance = WETH.totalBalanceOf(address(this));
        uint256 txFee = mulDiv(amountWanted, fee, 10000);

        // cap fee at 25k
        uint256 maxFee = 25000 * 10**IERC20(tokenWanted).decimals();
        txFee = txFee > maxFee ? maxFee : txFee;

        uint256 amountAfterFee = amountWanted - txFee;
        // collect fee
        safeTransferFrom(tokenWanted, msg.sender, IOwnable(factory).owner(), txFee);
        // exchange assets
        safeTransferFrom(tokenWanted, msg.sender, seller, amountAfterFee);
        WETH.transferAll(msg.sender);
        hasEnded = true;
        emit OfferFilled(msg.sender, balance, tokenWanted, amountWanted);
    }

    function cancel() public {
        require(hasWETH(), "no WETH balance");
        require(msg.sender == seller);
        uint256 balance = WETH.totalBalanceOf(address(this));
        WETH.transferAll(seller);
        hasEnded = true;
        emit OfferCanceled(seller, balance);
    }

    function hasWETH() public view returns (bool) {
        return WETH.totalBalanceOf(address(this)) > 0;
    }

    function mulDiv(
        uint256 x,
        uint256 y,
        uint256 z
    ) public pure returns (uint256) {
        return (x * y) / z;
    }

    function safeTransfer(
        address token,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "safeTransfer: failed");
    }

    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "safeTransferFrom: failed");
    }
}
