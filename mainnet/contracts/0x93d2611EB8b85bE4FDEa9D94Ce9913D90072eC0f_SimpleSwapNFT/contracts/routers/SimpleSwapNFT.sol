// SPDX-License-Identifier: ISC

pragma solidity 0.7.5;
pragma abicoder v2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/Utils.sol";
import "../lib/UtilsNFT.sol";
import "./IRouterNFT.sol";
import "../fee/FeeModel.sol";
import "../fee/IFeeClaimer.sol";

contract SimpleSwapNFT is FeeModel, IRouterNFT {
    using SafeMath for uint256;
    address public immutable augustusRFQ;

    /*solhint-disable no-empty-blocks*/
    constructor(
        uint256 _partnerSharePercent,
        uint256 _maxFeePercent,
        IFeeClaimer _feeClaimer,
        address _augustusRFQ
    ) public FeeModel(_partnerSharePercent, _maxFeePercent, _feeClaimer) {
        augustusRFQ = _augustusRFQ;
    }

    /*solhint-enable no-empty-blocks*/

    function initialize(bytes calldata) external override {
        revert("METHOD NOT IMPLEMENTED");
    }

    function getKey() external pure override returns (bytes32) {
        return keccak256(abi.encodePacked("SIMPLE_SWAP_NFT_ROUTER", "1.0.0"));
    }

    /**
     * @dev This function is called to buy multiple ERC721 or ERC1155 tokens.
     * @param data Data required to perform swap.
     */
    function simpleBuyNFT(UtilsNFT.SimpleBuyNFTData calldata data) external payable {
        require(data.deadline >= block.timestamp, "Deadline breached");
        address payable beneficiary = data.beneficiary == address(0) ? msg.sender : data.beneficiary;
        uint256 remainingAmount = performSimpleBuyNFT(
            data.callees,
            data.exchangeData,
            data.startIndexes,
            data.values,
            data.fromToken,
            data.toTokenDetails,
            data.fromAmount,
            data.expectedAmount,
            data.partner,
            data.feePercent,
            data.permit,
            beneficiary
        );

        emit BoughtNFTV3(
            data.uuid,
            data.partner,
            data.feePercent,
            msg.sender,
            beneficiary,
            data.fromToken,
            data.toTokenDetails,
            data.fromAmount.sub(remainingAmount),
            data.expectedAmount
        );
    }

    function performSimpleBuyNFT(
        address[] memory callees,
        bytes memory exchangeData,
        uint256[] memory startIndexes,
        uint256[] memory values,
        address fromToken,
        UtilsNFT.ToTokenNFTDetails[] memory toTokenDetails,
        uint256 fromAmount,
        uint256 expectedAmount,
        address payable partner,
        uint256 feePercent,
        bytes memory permit,
        address payable beneficiary
    ) private returns (uint256 remainingAmount) {
        require(msg.value == (fromToken == Utils.ethAddress() ? fromAmount : 0), "Incorrect msg.value");
        require(toTokenDetails.length > 0, "toTokenDetails can't be empty");
        require(callees.length + 1 == startIndexes.length, "Start indexes must be 1 greater then number of callees");
        require(callees.length == values.length, "callees and values must have same length");
        require(_isTakeFeeFromSrcToken(feePercent), "fee on dest token not supported");

        //If source token is not ETH than transfer required amount of tokens
        //from sender to this contract
        transferTokensFromProxy(fromToken, fromAmount, permit);

        performCalls(callees, exchangeData, startIndexes, values);

        // Slippage check is not require. If all the requested ERC721 and ERC1155
        // are transferred correctly the swap should succeed.
        for (uint256 i = 0; i < toTokenDetails.length; i++) {
            UtilsNFT.ToTokenNFTDetails memory details = toTokenDetails[i];
            // toToken is packed
            // 0 - 159 bits: token address
            // 160 bit: tokenType 0 -> ERC721, 1 -> ERC1155
            if ((details.toToken & (1 << 160)) == 0) {
                UtilsNFT.transferTokens721(address(details.toToken), beneficiary, details.toTokenID);
            } else {
                UtilsNFT.transferTokens1155(address(details.toToken), beneficiary, details.toTokenID, details.toAmount);
            }
        }

        // take slippage from src token
        remainingAmount = Utils.tokenBalance(fromToken, address(this));
        takeFromTokenFeeSlippageAndTransfer(
            fromToken,
            fromAmount,
            expectedAmount,
            remainingAmount,
            partner,
            feePercent
        );

        return remainingAmount;
    }

    function transferTokensFromProxy(
        address token,
        uint256 amount,
        bytes memory permit
    ) private {
        if (token != Utils.ethAddress()) {
            Utils.permit(token, permit);
            tokenTransferProxy.transferFrom(token, msg.sender, address(this), amount);
        }
    }

    function performCalls(
        address[] memory callees,
        bytes memory exchangeData,
        uint256[] memory startIndexes,
        uint256[] memory values
    ) private {
        for (uint256 i = 0; i < callees.length; i++) {
            require(callees[i] != address(tokenTransferProxy), "Can not call TokenTransferProxy Contract");

            if (callees[i] == augustusRFQ) {
                verifyAugustusRFQParams(startIndexes[i], exchangeData);
            } else {
                uint256 dataOffset = startIndexes[i];
                bytes32 selector;
                assembly {
                    selector := mload(add(exchangeData, add(dataOffset, 32)))
                }
                require(bytes4(selector) != IERC20.transferFrom.selector, "transferFrom not allowed for externalCall");
            }

            bool result = externalCall(
                callees[i], //destination
                values[i], //value to send
                startIndexes[i], // start index of call data
                startIndexes[i + 1].sub(startIndexes[i]), // length of calldata
                exchangeData // total calldata
            );
            require(result, "External call failed");
        }
    }

    function verifyAugustusRFQParams(uint256 startIndex, bytes memory exchangeData) private view {
        // Load the 4 byte function signature in the lower 32 bits
        // Also load the memory address of the calldata params which follow
        uint256 sig;
        uint256 paramsStart;
        assembly {
            let tmp := add(exchangeData, startIndex)
            // Note that all bytes variables start with 32 bytes length field
            sig := shr(224, mload(add(tmp, 32)))
            paramsStart := add(tmp, 36)
        }
        if (
            sig == 0x98f9b46b || // fillOrder
            sig == 0xbbbc2372 || // fillOrderNFT
            sig == 0x00154008 || // fillOrderWithTarget
            sig == 0x3c3694ab || // fillOrderWithTargetNFT
            sig == 0xc88ae6dc || // partialFillOrder
            sig == 0xb28ace5f || // partialFillOrderNFT
            sig == 0x24abf828 || // partialFillOrderWithTarget
            sig == 0x30201ad3 || // partialFillOrderWithTargetNFT
            sig == 0xda6b84af || // partialFillOrderWithTargetPermit
            sig == 0xf6c1b371 // partialFillOrderWithTargetPermitNFT
        ) {
            // First parameter is fixed size (encoded in place) order struct
            // with nonceAndMeta being the first field, therefore:
            // nonceAndMeta is the first 32 bytes of the ABI encoding
            uint256 nonceAndMeta;
            assembly {
                nonceAndMeta := mload(paramsStart)
            }
            address userAddress = address(uint160(nonceAndMeta));
            require(userAddress == address(0) || userAddress == msg.sender, "unauthorized user");
        } else if (
            sig == 0x077822bd || // batchFillOrderWithTarget
            sig == 0xc8b81d63 || // batchFillOrderWithTargetNFT
            sig == 0x1c64b820 || // tryBatchFillOrderTakerAmount
            sig == 0x01fb36ba // tryBatchFillOrderMakerAmount
        ) {
            // First parameter is variable length array of variable size order
            // infos where first field of order info is the actual order struct
            // (fixed size so encoded in place) which starts with nonceAndMeta.
            // Therefore, the nonceAndMeta is the first 32 bytes of order info.
            // But we need to find where the order infos start!
            // Firstly, we load the offset of the array, and its length
            uint256 arrayPtr;
            uint256 arrayLength;
            uint256 arrayStart;
            assembly {
                arrayPtr := add(paramsStart, mload(paramsStart))
                arrayLength := mload(arrayPtr)
                arrayStart := add(arrayPtr, 32)
            }
            // Each of the words after the array length is an offset from the
            // start of the array data, loading this gives us nonceAndMeta
            for (uint256 i = 0; i < arrayLength; ++i) {
                uint256 nonceAndMeta;
                assembly {
                    arrayPtr := add(arrayPtr, 32)
                    nonceAndMeta := mload(add(arrayStart, mload(arrayPtr)))
                }
                address userAddress = address(uint160(nonceAndMeta));
                require(userAddress == address(0) || userAddress == msg.sender, "unauthorized user");
            }
        } else {
            revert("unrecognized AugustusRFQ method selector");
        }
    }

    /*solhint-disable no-inline-assembly*/
    /**
     * @dev Source take from GNOSIS MultiSigWallet
     * @dev https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
     */
    function externalCall(
        address destination,
        uint256 value,
        uint256 dataOffset,
        uint256 dataLength,
        bytes memory data
    ) private returns (bool) {
        bool result = false;

        assembly {
            let x := mload(0x40) // "Allocate" memory for output
            // (0x40 is where "free memory" pointer is stored by convention)

            let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
            result := call(
                gas(),
                destination,
                value,
                add(d, dataOffset),
                dataLength, // Size of the input (in bytes) - this is what fixes the padding problem
                x,
                0 // Output is ignored, therefore the output size is zero
            )
        }
        return result;
    }

    /*solhint-enable no-inline-assembly*/
}
