// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;
pragma abicoder v2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

import "contracts/interfaces/IUnoswapRouter.sol";
import "contracts/helpers/UniERC20.sol";

contract Aggregator is Ownable {
    using UniERC20 for IERC20;
    using SafeERC20 for IERC20;

    uint256 public feeAmount;
    address payable public feeAddress;

    IUnoswapRouter unoswapRouter;

    constructor(
        uint256 _feeAmount,
        address payable _feeAddress,
        address router
    ) {
        feeAmount = _feeAmount;
        feeAddress = _feeAddress;
        unoswapRouter = IUnoswapRouter(router);
    }

    receive() external payable {}

    function setFeeAmount(uint256 _feeAmount) public onlyOwner {
        feeAmount = _feeAmount;
    }

    function setFeeAddress(address payable _feeAddress) public onlyOwner {
        feeAddress = _feeAddress;
    }

    function swap(
        IERC20 srcToken,
        uint256 amount,
        uint256 minReturn,
        bytes32[] calldata pools
    ) external payable {
        require(msg.value >= feeAmount, "Aggregator: fee is not enough");
        feeAddress.transfer(feeAmount);

        bool srcETH = srcToken.isETH();

        if (!srcETH) {
            srcToken.safeTransferFrom(msg.sender, address(this), amount);
            srcToken.approve(address(unoswapRouter), amount);
        }

        unoswapRouter.unoswap{value: srcETH ? amount : 0}(
            srcToken,
            amount,
            minReturn,
            pools
        );
    }
}
