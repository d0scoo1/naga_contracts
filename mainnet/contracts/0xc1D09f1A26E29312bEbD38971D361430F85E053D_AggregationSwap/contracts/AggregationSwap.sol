// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

contract AggregationSwap is Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    address public constant router =
        address(0x1111111254fb6c44bAC0beD2854e76F90643097d);

    address payable public feeCollector;

    constructor(address _feeCollector) public {
        require(_feeCollector != address(0));
        feeCollector = payable(_feeCollector);
    }

    /**
     * @dev swap with fee
     *
     * @param _feeCollector: feeCollector address
     **/
    function changeFeeCollector( address _feeCollector) external onlyOwner {
        require(_feeCollector != address(0));
        feeCollector = payable(_feeCollector);
    }

    /**
     * @dev swap with fee
     *
     * @param _fromToken: swap token address (if 0, ETH)
     * @param _fromTokenAmount: swap token amount
     * @param _data: data to send router
     * @param _gasFee: gasfee to send feeCollector
     **/
    function swap( 
        address _fromToken,
        uint256 _fromTokenAmount,
        bytes calldata _data, 
        uint256 _gasFee
    ) external payable nonReentrant {
        uint256 value;

        if(_fromToken == address(0)) { 
            require(_fromTokenAmount > 0, "Invalid ETH amount");
            require(msg.value >= _fromTokenAmount.add(_gasFee), "Invalid fee amount");
            value = _fromTokenAmount;
        } else {
            require(msg.value >= _gasFee, "Invalid fee amount");
            IERC20 fromToken = IERC20(_fromToken);
            fromToken.safeTransferFrom(msg.sender, address(this), _fromTokenAmount);
            fromToken.safeIncreaseAllowance(router, _fromTokenAmount);
        }

        (bool success, bytes memory returnData) =
            router.call{value: value}(_data);

        if (!success) {
            /// @dev never return
            decodeRevert(returnData);
        }

        feeCollector.transfer(msg.value.sub(value));
    }

    function decodeRevert(bytes memory result) internal pure {
        // Next 5 lines from https://ethereum.stackexchange.com/a/83577
        if (result.length < 68) revert();
        assembly {
            result := add(result, 0x04)
        }
        revert(abi.decode(result, (string)));
    }
}