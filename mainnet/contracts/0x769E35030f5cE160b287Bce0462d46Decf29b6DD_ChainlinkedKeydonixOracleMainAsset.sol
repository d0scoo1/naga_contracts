// File: helpers/IUniswapV2Factory.sol

// SPDX-License-Identifier: bsl-1.1

/*
  Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
*/
pragma solidity ^0.6.8;

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function createPair(address tokenA, address tokenB) external returns (address pair);
}

// File: helpers/AggregatorInterface.sol

/*
  Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
*/
pragma solidity ^0.6.8;

interface AggregatorInterface {
    function latestAnswer() external view returns (int256); // deprecated
    function latestTimestamp() external view returns (uint256); // deprecated
    function latestRound() external view returns (uint256);
    function decimals() external view returns (uint256);

    function latestRoundData()
    external
    view
    returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    );
}

// File: helpers/IKeydonixOracleUsd.sol

pragma experimental ABIEncoderV2;


interface IKeydonixOracleUsd {

    // returns Q112-encoded value
    function assetToUsd(address asset, uint amount, UniswapOracle.ProofData calldata proofData) external view returns (uint);
}
// File: @keydonix/uniswap-oracle-contracts/source/UQ112x112.sol

pragma solidity 0.6.8;

// https://raw.githubusercontent.com/Uniswap/uniswap-v2-core/master/contracts/libraries/UQ112x112.sol
// a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))

// range: [0, 2**112 - 1]
// resolution: 1 / 2**112

library UQ112x112 {
	uint224 constant Q112 = 2**112;

	// encode a uint112 as a UQ112x112
	function encode(uint112 y) internal pure returns (uint224 z) {
		z = uint224(y) * Q112; // never overflows
	}

	// divide a UQ112x112 by a uint112, returning a UQ112x112
	function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {
		z = x / uint224(y);
	}
}

// File: @keydonix/uniswap-oracle-contracts/source/IUniswapV2Pair.sol

pragma solidity 0.6.8;

interface IUniswapV2Pair {
    function token0() external view returns (address);
    function token1() external view returns (address);

    function price0CumulativeLast() external view returns (uint256);
    function price1CumulativeLast() external view returns (uint256);

	function getReserves() external view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast);
}

// File: @keydonix/uniswap-oracle-contracts/source/Rlp.sol

pragma solidity 0.6.8;

library Rlp {
	uint constant DATA_SHORT_START = 0x80;
	uint constant DATA_LONG_START = 0xB8;
	uint constant LIST_SHORT_START = 0xC0;
	uint constant LIST_LONG_START = 0xF8;

	uint constant DATA_LONG_OFFSET = 0xB7;
	uint constant LIST_LONG_OFFSET = 0xF7;


	struct Item {
		uint _unsafe_memPtr;    // Pointer to the RLP-encoded bytes.
		uint _unsafe_length;    // Number of bytes. This is the full length of the string.
	}

	struct Iterator {
		Item _unsafe_item;   // Item that's being iterated over.
		uint _unsafe_nextPtr;   // Position of the next item in the list.
	}

	/* Iterator */

	function next(Iterator memory self) internal pure returns (Item memory subItem) {
		require(hasNext(self), "Rlp.sol:Rlp:next:1");
		uint256 ptr = self._unsafe_nextPtr;
		uint256 itemLength = _itemLength(ptr);
		subItem._unsafe_memPtr = ptr;
		subItem._unsafe_length = itemLength;
		self._unsafe_nextPtr = ptr + itemLength;
	}

	function next(Iterator memory self, bool strict) internal pure returns (Item memory subItem) {
		subItem = next(self);
		require(!strict || _validate(subItem), "Rlp.sol:Rlp:next:2");
	}

	function hasNext(Iterator memory self) internal pure returns (bool) {
		Rlp.Item memory item = self._unsafe_item;
		return self._unsafe_nextPtr < item._unsafe_memPtr + item._unsafe_length;
	}

	/* Item */

	/// @dev Creates an Item from an array of RLP encoded bytes.
	/// @param self The RLP encoded bytes.
	/// @return An Item
	function toItem(bytes memory self) internal pure returns (Item memory) {
		uint len = self.length;
		if (len == 0) {
			return Item(0, 0);
		}
		uint memPtr;
		assembly {
			memPtr := add(self, 0x20)
		}
		return Item(memPtr, len);
	}

	/// @dev Creates an Item from an array of RLP encoded bytes.
	/// @param self The RLP encoded bytes.
	/// @param strict Will throw if the data is not RLP encoded.
	/// @return An Item
	function toItem(bytes memory self, bool strict) internal pure returns (Item memory) {
		Rlp.Item memory item = toItem(self);
		if(strict) {
			uint len = self.length;
			require(_payloadOffset(item) <= len, "Rlp.sol:Rlp:toItem4");
			require(_itemLength(item._unsafe_memPtr) == len, "Rlp.sol:Rlp:toItem:5");
			require(_validate(item), "Rlp.sol:Rlp:toItem:6");
		}
		return item;
	}

	/// @dev Check if the Item is null.
	/// @param self The Item.
	/// @return 'true' if the item is null.
	function isNull(Item memory self) internal pure returns (bool) {
		return self._unsafe_length == 0;
	}

	/// @dev Check if the Item is a list.
	/// @param self The Item.
	/// @return 'true' if the item is a list.
	function isList(Item memory self) internal pure returns (bool) {
		if (self._unsafe_length == 0)
			return false;
		uint memPtr = self._unsafe_memPtr;
		bool result;
		assembly {
			result := iszero(lt(byte(0, mload(memPtr)), 0xC0))
		}
		return result;
	}

	/// @dev Check if the Item is data.
	/// @param self The Item.
	/// @return 'true' if the item is data.
	function isData(Item memory self) internal pure returns (bool) {
		if (self._unsafe_length == 0)
			return false;
		uint memPtr = self._unsafe_memPtr;
		bool result;
		assembly {
			result := lt(byte(0, mload(memPtr)), 0xC0)
		}
		return result;
	}

	/// @dev Check if the Item is empty (string or list).
	/// @param self The Item.
	/// @return result 'true' if the item is null.
	function isEmpty(Item memory self) internal pure returns (bool) {
		if(isNull(self))
			return false;
		uint b0;
		uint memPtr = self._unsafe_memPtr;
		assembly {
			b0 := byte(0, mload(memPtr))
		}
		return (b0 == DATA_SHORT_START || b0 == LIST_SHORT_START);
	}

	/// @dev Get the number of items in an RLP encoded list.
	/// @param self The Item.
	/// @return The number of items.
	function items(Item memory self) internal pure returns (uint) {
		if (!isList(self))
			return 0;
		uint b0;
		uint memPtr = self._unsafe_memPtr;
		assembly {
			b0 := byte(0, mload(memPtr))
		}
		uint pos = memPtr + _payloadOffset(self);
		uint last = memPtr + self._unsafe_length - 1;
		uint itms;
		while(pos <= last) {
			pos += _itemLength(pos);
			itms++;
		}
		return itms;
	}

	/// @dev Create an iterator.
	/// @param self The Item.
	/// @return An 'Iterator' over the item.
	function iterator(Item memory self) internal pure returns (Iterator memory) {
		require(isList(self), "Rlp.sol:Rlp:iterator:1");
		uint ptr = self._unsafe_memPtr + _payloadOffset(self);
		Iterator memory it;
		it._unsafe_item = self;
		it._unsafe_nextPtr = ptr;
		return it;
	}

	/// @dev Return the RLP encoded bytes.
	/// @param self The Item.
	/// @return The bytes.
	function toBytes(Item memory self) internal pure returns (bytes memory) {
		uint256 len = self._unsafe_length;
		require(len != 0, "Rlp.sol:Rlp:toBytes:2");
		bytes memory bts;
		bts = new bytes(len);
		_copyToBytes(self._unsafe_memPtr, bts, len);
		return bts;
	}

	/// @dev Decode an Item into bytes. This will not work if the
	/// Item is a list.
	/// @param self The Item.
	/// @return The decoded string.
	function toData(Item memory self) internal pure returns (bytes memory) {
		require(isData(self));
		(uint256 rStartPos, uint256 len) = _decode(self);
		bytes memory bts;
		bts = new bytes(len);
		_copyToBytes(rStartPos, bts, len);
		return bts;
	}

	/// @dev Get the list of sub-items from an RLP encoded list.
	/// Warning: This is inefficient, as it requires that the list is read twice.
	/// @param self The Item.
	/// @return Array of Items.
	function toList(Item memory self) internal pure returns (Item[] memory) {
		require(isList(self), "Rlp.sol:Rlp:toList:1");
		uint256 numItems = items(self);
		Item[] memory list = new Item[](numItems);
		Rlp.Iterator memory it = iterator(self);
		uint idx;
		while(hasNext(it)) {
			list[idx] = next(it);
			idx++;
		}
		return list;
	}

	/// @dev Decode an Item into an ascii string. This will not work if the
	/// Item is a list.
	/// @param self The Item.
	/// @return The decoded string.
	function toAscii(Item memory self) internal pure returns (string memory) {
		require(isData(self), "Rlp.sol:Rlp:toAscii:1");
		(uint256 rStartPos, uint256 len) = _decode(self);
		bytes memory bts = new bytes(len);
		_copyToBytes(rStartPos, bts, len);
		string memory str = string(bts);
		return str;
	}

	/// @dev Decode an Item into a uint. This will not work if the
	/// Item is a list.
	/// @param self The Item.
	/// @return The decoded string.
	function toUint(Item memory self) internal pure returns (uint) {
		require(isData(self), "Rlp.sol:Rlp:toUint:1");
		(uint256 rStartPos, uint256 len) = _decode(self);
		require(len <= 32, "Rlp.sol:Rlp:toUint:3");
		require(len != 0, "Rlp.sol:Rlp:toUint:4");
		uint data;
		assembly {
			data := div(mload(rStartPos), exp(256, sub(32, len)))
		}
		return data;
	}

	/// @dev Decode an Item into a boolean. This will not work if the
	/// Item is a list.
	/// @param self The Item.
	/// @return The decoded string.
	function toBool(Item memory self) internal pure returns (bool) {
		require(isData(self), "Rlp.sol:Rlp:toBool:1");
		(uint256 rStartPos, uint256 len) = _decode(self);
		require(len == 1, "Rlp.sol:Rlp:toBool:3");
		uint temp;
		assembly {
			temp := byte(0, mload(rStartPos))
		}
		require(temp <= 1, "Rlp.sol:Rlp:toBool:8");
		return temp == 1 ? true : false;
	}

	/// @dev Decode an Item into a byte. This will not work if the
	/// Item is a list.
	/// @param self The Item.
	/// @return The decoded string.
	function toByte(Item memory self) internal pure returns (byte) {
		require(isData(self), "Rlp.sol:Rlp:toByte:1");
		(uint256 rStartPos, uint256 len) = _decode(self);
		require(len == 1, "Rlp.sol:Rlp:toByte:3");
		byte temp;
		assembly {
			temp := byte(0, mload(rStartPos))
		}
		return byte(temp);
	}

	/// @dev Decode an Item into an int. This will not work if the
	/// Item is a list.
	/// @param self The Item.
	/// @return The decoded string.
	function toInt(Item memory self) internal pure returns (int) {
		return int(toUint(self));
	}

	/// @dev Decode an Item into a bytes32. This will not work if the
	/// Item is a list.
	/// @param self The Item.
	/// @return The decoded string.
	function toBytes32(Item memory self) internal pure returns (bytes32) {
		return bytes32(toUint(self));
	}

	/// @dev Decode an Item into an address. This will not work if the
	/// Item is a list.
	/// @param self The Item.
	/// @return The decoded string.
	function toAddress(Item memory self) internal pure returns (address) {
		require(isData(self), "Rlp.sol:Rlp:toAddress:1");
		(uint256 rStartPos, uint256 len) = _decode(self);
		require(len == 20, "Rlp.sol:Rlp:toAddress:3");
		address data;
		assembly {
			data := div(mload(rStartPos), exp(256, 12))
		}
		return data;
	}

	// Get the payload offset.
	function _payloadOffset(Item memory self) private pure returns (uint) {
		if(self._unsafe_length == 0)
			return 0;
		uint b0;
		uint memPtr = self._unsafe_memPtr;
		assembly {
			b0 := byte(0, mload(memPtr))
		}
		if(b0 < DATA_SHORT_START)
			return 0;
		if(b0 < DATA_LONG_START || (b0 >= LIST_SHORT_START && b0 < LIST_LONG_START))
			return 1;
		if(b0 < LIST_SHORT_START)
			return b0 - DATA_LONG_OFFSET + 1;
		return b0 - LIST_LONG_OFFSET + 1;
	}

	// Get the full length of an Item.
	function _itemLength(uint memPtr) private pure returns (uint len) {
		uint b0;
		assembly {
			b0 := byte(0, mload(memPtr))
		}
		if (b0 < DATA_SHORT_START)
			len = 1;
		else if (b0 < DATA_LONG_START)
			len = b0 - DATA_SHORT_START + 1;
		else if (b0 < LIST_SHORT_START) {
			assembly {
				let bLen := sub(b0, 0xB7) // bytes length (DATA_LONG_OFFSET)
				let dLen := div(mload(add(memPtr, 1)), exp(256, sub(32, bLen))) // data length
				len := add(1, add(bLen, dLen)) // total length
			}
		}
		else if (b0 < LIST_LONG_START)
			len = b0 - LIST_SHORT_START + 1;
		else {
			assembly {
				let bLen := sub(b0, 0xF7) // bytes length (LIST_LONG_OFFSET)
				let dLen := div(mload(add(memPtr, 1)), exp(256, sub(32, bLen))) // data length
				len := add(1, add(bLen, dLen)) // total length
			}
		}
	}

	// Get start position and length of the data.
	function _decode(Item memory self) private pure returns (uint memPtr, uint len) {
		require(isData(self), "Rlp.sol:Rlp:_decode:1");
		uint b0;
		uint start = self._unsafe_memPtr;
		assembly {
			b0 := byte(0, mload(start))
		}
		if (b0 < DATA_SHORT_START) {
			memPtr = start;
			len = 1;
			return (memPtr, len);
		}
		if (b0 < DATA_LONG_START) {
			len = self._unsafe_length - 1;
			memPtr = start + 1;
		} else {
			uint bLen;
			assembly {
				bLen := sub(b0, 0xB7) // DATA_LONG_OFFSET
			}
			len = self._unsafe_length - 1 - bLen;
			memPtr = start + bLen + 1;
		}
		return (memPtr, len);
	}

	// Assumes that enough memory has been allocated to store in target.
	function _copyToBytes(uint sourceBytes, bytes memory destinationBytes, uint btsLen) internal pure {
		// Exploiting the fact that 'tgt' was the last thing to be allocated,
		// we can write entire words, and just overwrite any excess.
		assembly {
			let words := div(add(btsLen, 31), 32)
			let sourcePointer := sourceBytes
			let destinationPointer := add(destinationBytes, 32)
			for { let i := 0 } lt(i, words) { i := add(i, 1) }
			{
				let offset := mul(i, 32)
				mstore(add(destinationPointer, offset), mload(add(sourcePointer, offset)))
			}
			mstore(add(destinationBytes, add(32, mload(destinationBytes))), 0)
		}
	}

	// Check that an Item is valid.
	function _validate(Item memory self) private pure returns (bool ret) {
		// Check that RLP is well-formed.
		uint b0;
		uint b1;
		uint memPtr = self._unsafe_memPtr;
		assembly {
			b0 := byte(0, mload(memPtr))
			b1 := byte(1, mload(memPtr))
		}
		if(b0 == DATA_SHORT_START + 1 && b1 < DATA_SHORT_START)
			return false;
		return true;
	}

	function rlpBytesToUint256(bytes memory source) internal pure returns (uint256 result) {
		return Rlp.toUint(Rlp.toItem(source));
	}
}

// File: @keydonix/uniswap-oracle-contracts/source/MerklePatriciaVerifier.sol

pragma solidity 0.6.8;


library MerklePatriciaVerifier {
	/*
	 * @dev Extracts the value from a merkle proof
	 * @param expectedRoot The expected hash of the root node of the trie.
	 * @param path The path in the trie leading to value.
	 * @param proofNodesRlp RLP encoded array of proof nodes.
	 * @return The value proven to exist in the merkle patricia tree whose root is `expectedRoot` at the path `path`
	 *
	 * WARNING: Does not currently support validation of unset/0 values!
	 */
	function getValueFromProof(bytes32 expectedRoot, bytes32 path, bytes memory proofNodesRlp) internal pure returns (bytes memory) {
		Rlp.Item memory rlpParentNodes = Rlp.toItem(proofNodesRlp);
		Rlp.Item[] memory parentNodes = Rlp.toList(rlpParentNodes);

		bytes memory currentNode;
		Rlp.Item[] memory currentNodeList;

		bytes32 nodeKey = expectedRoot;
		uint pathPtr = 0;

		// our input is a 32-byte path, but we have to prepend a single 0 byte to that and pass it along as a 33 byte memory array since that is what getNibbleArray wants
		bytes memory nibblePath = new bytes(33);
		assembly { mstore(add(nibblePath, 33), path) }
		nibblePath = _getNibbleArray(nibblePath);

		require(path.length != 0, "empty path provided");

		currentNode = Rlp.toBytes(parentNodes[0]);

		for (uint i=0; i<parentNodes.length; i++) {
			require(pathPtr <= nibblePath.length, "Path overflow");

			currentNode = Rlp.toBytes(parentNodes[i]);
			require(nodeKey == keccak256(currentNode), "node doesn't match key");
			currentNodeList = Rlp.toList(parentNodes[i]);

			if(currentNodeList.length == 17) {
				if(pathPtr == nibblePath.length) {
					return Rlp.toData(currentNodeList[16]);
				}

				uint8 nextPathNibble = uint8(nibblePath[pathPtr]);
				require(nextPathNibble <= 16, "nibble too long");
				nodeKey = Rlp.toBytes32(currentNodeList[nextPathNibble]);
				pathPtr += 1;
			} else if(currentNodeList.length == 2) {
				pathPtr += _nibblesToTraverse(Rlp.toData(currentNodeList[0]), nibblePath, pathPtr);
				// leaf node
				if(pathPtr == nibblePath.length) {
					return Rlp.toData(currentNodeList[1]);
				}
				//extension node
				require(_nibblesToTraverse(Rlp.toData(currentNodeList[0]), nibblePath, pathPtr) != 0, "invalid extension node");

				nodeKey = Rlp.toBytes32(currentNodeList[1]);
			} else {
				require(false, "unexpected length array");
			}
		}
		require(false, "not enough proof nodes");
	}

	function _nibblesToTraverse(bytes memory encodedPartialPath, bytes memory path, uint pathPtr) private pure returns (uint) {
		uint len;
		// encodedPartialPath has elements that are each two hex characters (1 byte), but partialPath
		// and slicedPath have elements that are each one hex character (1 nibble)
		bytes memory partialPath = _getNibbleArray(encodedPartialPath);
		bytes memory slicedPath = new bytes(partialPath.length);

		// pathPtr counts nibbles in path
		// partialPath.length is a number of nibbles
		for(uint i=pathPtr; i<pathPtr+partialPath.length; i++) {
			byte pathNibble = path[i];
			slicedPath[i-pathPtr] = pathNibble;
		}

		if(keccak256(partialPath) == keccak256(slicedPath)) {
			len = partialPath.length;
		} else {
			len = 0;
		}
		return len;
	}

	// bytes byteArray must be hp encoded
	function _getNibbleArray(bytes memory byteArray) private pure returns (bytes memory) {
		bytes memory nibbleArray;
		if (byteArray.length == 0) return nibbleArray;

		uint8 offset;
		uint8 hpNibble = uint8(_getNthNibbleOfBytes(0,byteArray));
		if(hpNibble == 1 || hpNibble == 3) {
			nibbleArray = new bytes(byteArray.length*2-1);
			byte oddNibble = _getNthNibbleOfBytes(1,byteArray);
			nibbleArray[0] = oddNibble;
			offset = 1;
		} else {
			nibbleArray = new bytes(byteArray.length*2-2);
			offset = 0;
		}

		for(uint i=offset; i<nibbleArray.length; i++) {
			nibbleArray[i] = _getNthNibbleOfBytes(i-offset+2,byteArray);
		}
		return nibbleArray;
	}

	function _getNthNibbleOfBytes(uint n, bytes memory str) private pure returns (byte) {
		return byte(n%2==0 ? uint8(str[n/2])/0x10 : uint8(str[n/2])%0x10);
	}
}

// File: @keydonix/uniswap-oracle-contracts/source/BlockVerifier.sol

pragma solidity 0.6.8;

library BlockVerifier {
	function extractStateRootAndTimestamp(bytes memory rlpBytes) internal view returns (bytes32 stateRoot, uint256 blockTimestamp, uint256 blockNumber) {
		assembly {
			function revertWithReason(message, length) {
				mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
				mstore(4, 0x20)
				mstore(0x24, length)
				mstore(0x44, message)
				revert(0, add(0x44, length))
			}

			function readDynamic(prefixPointer) -> dataPointer, dataLength {
				let value := byte(0, mload(prefixPointer))
				switch lt(value, 0x80)
				case 1 {
					dataPointer := prefixPointer
					dataLength := 1
				}
				case 0 {
					dataPointer := add(prefixPointer, 1)
					dataLength := sub(value, 0x80)
				}
			}

			// get the length of the data
			let rlpLength := mload(rlpBytes)
			// move pointer forward, ahead of length
			rlpBytes := add(rlpBytes, 0x20)

			// we know the length of the block will be between 483 bytes and 709 bytes, which means it will have 2 length bytes after the prefix byte, so we can skip 3 bytes in
			// CONSIDER: we could save a trivial amount of gas by compressing most of this into a single add instruction
			let parentHashPrefixPointer := add(rlpBytes, 3)
			let parentHashPointer := add(parentHashPrefixPointer, 1)
			let uncleHashPrefixPointer := add(parentHashPointer, 32)
			let uncleHashPointer := add(uncleHashPrefixPointer, 1)
			let minerAddressPrefixPointer := add(uncleHashPointer, 32)
			let minerAddressPointer := add(minerAddressPrefixPointer, 1)
			let stateRootPrefixPointer := add(minerAddressPointer, 20)
			let stateRootPointer := add(stateRootPrefixPointer, 1)
			let transactionRootPrefixPointer := add(stateRootPointer, 32)
			let transactionRootPointer := add(transactionRootPrefixPointer, 1)
			let receiptsRootPrefixPointer := add(transactionRootPointer, 32)
			let receiptsRootPointer := add(receiptsRootPrefixPointer, 1)
			let logsBloomPrefixPointer := add(receiptsRootPointer, 32)
			let logsBloomPointer := add(logsBloomPrefixPointer, 3)
			let difficultyPrefixPointer := add(logsBloomPointer, 256)
			let difficultyPointer, difficultyLength := readDynamic(difficultyPrefixPointer)
			let blockNumberPrefixPointer := add(difficultyPointer, difficultyLength)
			let blockNumberPointer, blockNumberLength := readDynamic(blockNumberPrefixPointer)
			let gasLimitPrefixPointer := add(blockNumberPointer, blockNumberLength)
			let gasLimitPointer, gasLimitLength := readDynamic(gasLimitPrefixPointer)
			let gasUsedPrefixPointer := add(gasLimitPointer, gasLimitLength)
			let gasUsedPointer, gasUsedLength := readDynamic(gasUsedPrefixPointer)
			let timestampPrefixPointer := add(gasUsedPointer, gasUsedLength)
			let timestampPointer, timestampLength := readDynamic(timestampPrefixPointer)

			blockNumber := shr(sub(256, mul(blockNumberLength, 8)), mload(blockNumberPointer))
			let blockHash := blockhash(blockNumber)
			let rlpHash := keccak256(rlpBytes, rlpLength)
			if iszero(eq(blockHash, rlpHash)) { revertWithReason("blockHash != rlpHash", 20) }

			stateRoot := mload(stateRootPointer)
			blockTimestamp := shr(sub(256, mul(timestampLength, 8)), mload(timestampPointer))
		}
	}
}

// File: @keydonix/uniswap-oracle-contracts/source/UniswapOracle.sol

pragma solidity 0.6.8;






contract UniswapOracle {
	using UQ112x112 for uint224;

	bytes32 public constant reserveTimestampSlotHash = keccak256(abi.encodePacked(uint256(8)));
	bytes32 public constant token0Slot = keccak256(abi.encodePacked(uint256(9)));
	bytes32 public constant token1Slot = keccak256(abi.encodePacked(uint256(10)));

	struct ProofData {
		bytes block;
		bytes accountProofNodesRlp;
		bytes reserveAndTimestampProofNodesRlp;
		bytes priceAccumulatorProofNodesRlp;
	}

	function getAccountStorageRoot(address uniswapV2Pair, ProofData memory proofData) public view returns (bytes32 storageRootHash, uint256 blockNumber, uint256 blockTimestamp) {
		bytes32 stateRoot;
		(stateRoot, blockTimestamp, blockNumber) = BlockVerifier.extractStateRootAndTimestamp(proofData.block);
		bytes memory accountDetailsBytes = MerklePatriciaVerifier.getValueFromProof(stateRoot, keccak256(abi.encodePacked(uniswapV2Pair)), proofData.accountProofNodesRlp);
		Rlp.Item[] memory accountDetails = Rlp.toList(Rlp.toItem(accountDetailsBytes));
		return (Rlp.toBytes32(accountDetails[2]), blockNumber, blockTimestamp);
	}

	// This function verifies the full block is old enough (MIN_BLOCK_COUNT), not too old (or blockhash will return 0x0) and return the proof values for the two storage slots we care about
	function verifyBlockAndExtractReserveData(IUniswapV2Pair uniswapV2Pair, uint8 minBlocksBack, uint8 maxBlocksBack, bytes32 slotHash, ProofData memory proofData) public view returns
	(uint256 blockTimestamp, uint256 blockNumber, uint256 priceCumulativeLast, uint112 reserve0, uint112 reserve1, uint256 reserveTimestamp) {
		bytes32 storageRootHash;
		(storageRootHash, blockNumber, blockTimestamp) = getAccountStorageRoot(address(uniswapV2Pair), proofData);
		require (blockNumber <= block.number - minBlocksBack, "Proof does not span enough blocks");
		require (blockNumber >= block.number - maxBlocksBack, "Proof spans too many blocks");

		priceCumulativeLast = Rlp.rlpBytesToUint256(MerklePatriciaVerifier.getValueFromProof(storageRootHash, slotHash, proofData.priceAccumulatorProofNodesRlp));
		uint256 reserve0Reserve1TimestampPacked = Rlp.rlpBytesToUint256(MerklePatriciaVerifier.getValueFromProof(storageRootHash, reserveTimestampSlotHash, proofData.reserveAndTimestampProofNodesRlp));
		reserveTimestamp = reserve0Reserve1TimestampPacked >> (112 + 112);
		reserve1 = uint112((reserve0Reserve1TimestampPacked >> 112) & (2**112 - 1));
		reserve0 = uint112(reserve0Reserve1TimestampPacked & (2**112 - 1));
	}

	function getPrice(IUniswapV2Pair uniswapV2Pair, address denominationToken, uint8 minBlocksBack, uint8 maxBlocksBack, ProofData memory proofData) public view returns (uint256 price, uint256 blockNumber) {
		// exchange = the ExchangeV2Pair. check denomination token (USE create2 check?!) check gas cost
		bool denominationTokenIs0;
		if (uniswapV2Pair.token0() == denominationToken) {
			denominationTokenIs0 = true;
		} else if (uniswapV2Pair.token1() == denominationToken) {
			denominationTokenIs0 = false;
		} else {
			revert("denominationToken invalid");
		}
		return getPriceRaw(uniswapV2Pair, denominationTokenIs0, minBlocksBack, maxBlocksBack, proofData);
	}

	function getPriceRaw(IUniswapV2Pair uniswapV2Pair, bool denominationTokenIs0, uint8 minBlocksBack, uint8 maxBlocksBack, ProofData memory proofData) public view returns (uint256 price, uint256 blockNumber) {
		uint256 historicBlockTimestamp;
		uint256 historicPriceCumulativeLast;
		{
			// Stack-too-deep workaround, manual scope
			// Side-note: wtf Solidity?
			uint112 reserve0;
			uint112 reserve1;
			uint256 reserveTimestamp;
			(historicBlockTimestamp, blockNumber, historicPriceCumulativeLast, reserve0, reserve1, reserveTimestamp) = verifyBlockAndExtractReserveData(uniswapV2Pair, minBlocksBack, maxBlocksBack, denominationTokenIs0 ? token1Slot : token0Slot, proofData);
			uint256 secondsBetweenReserveUpdateAndHistoricBlock = historicBlockTimestamp - reserveTimestamp;
			// bring old record up-to-date, in case there was no cumulative update in provided historic block itself
			if (secondsBetweenReserveUpdateAndHistoricBlock > 0) {
				historicPriceCumulativeLast += secondsBetweenReserveUpdateAndHistoricBlock * uint(UQ112x112
					.encode(denominationTokenIs0 ? reserve0 : reserve1)
					.uqdiv(denominationTokenIs0 ? reserve1 : reserve0)
				);
			}
		}
		uint256 secondsBetweenProvidedBlockAndNow = block.timestamp - historicBlockTimestamp;
		price = (getCurrentPriceCumulativeLast(uniswapV2Pair, denominationTokenIs0) - historicPriceCumulativeLast) / secondsBetweenProvidedBlockAndNow;
		return (price, blockNumber);
	}

	function getCurrentPriceCumulativeLast(IUniswapV2Pair uniswapV2Pair, bool denominationTokenIs0) public view returns (uint256 priceCumulativeLast) {
		(uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = uniswapV2Pair.getReserves();
		priceCumulativeLast = denominationTokenIs0 ? uniswapV2Pair.price1CumulativeLast() : uniswapV2Pair.price0CumulativeLast();
		uint256 timeElapsed = block.timestamp - blockTimestampLast;
		priceCumulativeLast += timeElapsed * uint(UQ112x112
			.encode(denominationTokenIs0 ? reserve0 : reserve1)
			.uqdiv(denominationTokenIs0 ? reserve1 : reserve0)
		);
	}
}

// File: helpers/IKeydonixOracleEth.sol


interface IKeydonixOracleEth {

    // returns Q112-encoded value
    function assetToEth(address asset, uint amount, UniswapOracle.ProofData calldata proofData) external view returns (uint);
}
// File: helpers/IOracleEth.sol

interface IOracleEth {

    // returns Q112-encoded value
    function assetToEth(address asset, uint amount) external view returns (uint);

    // returns the value "as is"
    function ethToUsd(uint amount) external view returns (uint);

    // returns the value "as is"
    function usdToEth(uint amount) external view returns (uint);
}
// File: helpers/IOracleRegistry.sol


interface IOracleRegistry {

    struct Oracle {
        uint oracleType;
        address oracleAddress;
    }

    function WETH (  ) external view returns ( address );
    function getKeydonixOracleTypes (  ) external view returns ( uint256[] memory );
    function getOracles (  ) external view returns ( Oracle[] memory foundOracles );
    function keydonixOracleTypes ( uint256 ) external view returns ( uint256 );
    function maxOracleType (  ) external view returns ( uint256 );
    function oracleByAsset ( address asset ) external view returns ( address );
    function oracleByType ( uint256 ) external view returns ( address );
    function oracleTypeByAsset ( address ) external view returns ( uint256 );
    function oracleTypeByOracle ( address ) external view returns ( uint256 );
    function setKeydonixOracleTypes ( uint256[] calldata _keydonixOracleTypes ) external;
    function setOracle ( uint256 oracleType, address oracle ) external;
    function setOracleTypeForAsset ( address asset, uint256 oracleType ) external;
    function setOracleTypeForAssets ( address[] calldata assets, uint256 oracleType ) external;
    function unsetOracle ( uint256 oracleType ) external;
    function unsetOracleForAsset ( address asset ) external;
    function unsetOracleForAssets ( address[] calldata assets ) external;
    function vaultParameters (  ) external view returns ( address );
}

// File: helpers/SafeMath.sol

/*
  Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
*/
pragma solidity ^0.6.8;


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

    /**
    * @dev Multiplies two numbers, throws on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}

// File: impl/ChainlinkedKeydonixOracleMainAsset.sol

/*
  Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
*/
pragma solidity 0.6.8;










/**
 * @title ChainlinkedKeydonixOracleMainAsset
 * @dev Calculates the USD price of desired tokens
 **/
contract ChainlinkedKeydonixOracleMainAsset is UniswapOracle, IKeydonixOracleEth, IKeydonixOracleUsd {
    using SafeMath for uint;

    uint8 public constant MIN_BLOCKS_BACK = uint8(100);

    uint8 public constant MAX_BLOCKS_BACK = uint8(255);

    uint public constant ETH_USD_DENOMINATOR = 1e8;

    uint public constant Q112 = 2 ** 112;

    IUniswapV2Factory public immutable uniswapFactory;

    IOracleRegistry public immutable oracleRegistry;

    address public immutable WETH;

    constructor(
        IUniswapV2Factory uniFactory,
        IOracleRegistry _oracleRegistry
    )
        public
    {
        require(address(uniFactory) != address(0), "Unit Protocol: ZERO_ADDRESS");
        require(address(_oracleRegistry) != address(0), "Unit Protocol: ZERO_ADDRESS");

        uniswapFactory = uniFactory;
        WETH = _oracleRegistry.WETH();
        oracleRegistry = _oracleRegistry;
    }

    /**
     * @notice USD token's rate is UniswapV2 Token/WETH pool's average time weighted price between proofs' blockNumber and current block number
     * @notice Merkle proof must be in range [MIN_BLOCKS_BACK ... MAX_BLOCKS_BACK] blocks ago
     * @notice {Token}/WETH pair must exists on Uniswap
     * @param asset The token address
     * @param amount Amount of tokens
     * @param proofData Merkle proof data
     * @return Q112-encoded price of tokens in USD
     **/
    function assetToUsd(address asset, uint amount, UniswapOracle.ProofData memory proofData) public override view returns (uint) {
        uint priceInEth = assetToEth(asset, amount, proofData);
        return IOracleEth(oracleRegistry.oracleByAsset(WETH)).ethToUsd(priceInEth);
    }

    /**
     * @notice USD token's rate is UniswapV2 Token/WETH pool's average price between proof's blockNumber and current block number
     * @notice Merkle proof must be in range [MIN_BLOCKS_BACK ... MAX_BLOCKS_BACK] blocks ago
     * @notice {Token}/WETH pair must be registered on Uniswap
     * @param asset The token address
     * @param amount Amount of tokens
     * @param proofData Merkle proof data
     * @return Q112-encoded price of asset in ETH
     **/
    function assetToEth(address asset, uint amount, UniswapOracle.ProofData memory proofData) public override view returns (uint) {
        if (amount == 0) { return 0; }
        if (asset == WETH) { return amount.mul(Q112); }
        IUniswapV2Pair pair = IUniswapV2Pair(uniswapFactory.getPair(asset, WETH));
        require(address(pair) != address(0), "Unit Protocol: UNISWAP_PAIR_DOES_NOT_EXIST");
        (uint priceInEth, ) = getPrice(pair, WETH, MIN_BLOCKS_BACK, MAX_BLOCKS_BACK, proofData);
        return priceInEth.mul(amount);
    }
}