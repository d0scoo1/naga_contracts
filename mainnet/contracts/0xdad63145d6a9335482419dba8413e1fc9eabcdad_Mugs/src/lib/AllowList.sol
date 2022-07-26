// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;
import {Ownable} from "openzeppelin-contracts/access/Ownable.sol";

/**
 * @notice Smart contract that verifies and tracks allow list redemptions against a configurable Merkle root, up to a
 * max number configured at deploy
 */
contract AllowList is Ownable {
    bytes32 public merkleRoot;
    uint128 public maxTotalAllowListMints;
    uint128 public numAllowListMinted;

    error NotAllowListed();
    error MaxTotalAllowListMinted();

    ///@notice Checks if msg.sender is included in AllowList, revert otherwise
    ///@param _proof Merkle proof
    modifier onlyAllowListed(bytes32[] calldata _proof) {
        if (!isAllowListed(_proof, msg.sender)) {
            revert NotAllowListed();
        }
        _;
    }

    ///@notice check and then increment numAllowListMinted
    ///@param quantity Quantity of tokens to mint
    modifier upToMaxTotalAllowListMinted(uint128 quantity) {
        (uint128 _numAllowListMinted, uint128 _maxTotalAllowListMints) = (
            numAllowListMinted,
            maxTotalAllowListMints
        );
        if (_numAllowListMinted + quantity > _maxTotalAllowListMints) {
            revert MaxTotalAllowListMinted();
        }
        _;
        numAllowListMinted = _numAllowListMinted + quantity;
    }

    constructor(uint128 _maxTotalAllowListMints) {
        maxTotalAllowListMints = _maxTotalAllowListMints;
    }

    ///@notice set the Merkle root in the contract. OnlyOwner.
    ///@param _merkleRoot the new Merkle root
    function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
        merkleRoot = _merkleRoot;
    }

    ///@notice Set the maximum number of mints allowed from the allowlist
    ///@param _maxTotalAllowListMints the new maximum number of mints allowed from the allowlist
    function setMaxTotalAllowListMints(uint128 _maxTotalAllowListMints) public onlyOwner {
        maxTotalAllowListMints = _maxTotalAllowListMints;
    }

    ///@notice Given a Merkle proof, check if an address is AllowListed against the root
    ///@param _proof Merkle proof
    ///@param _address address to check against allow list
    ///@return boolean isAllowListed
    function isAllowListed(bytes32[] calldata _proof, address _address) public view returns (bool) {
        return verifyCalldata(_proof, merkleRoot, keccak256(abi.encodePacked(_address)));
    }

    /**
     * @dev Calldata version of {verify}
     * Copied from OpenZeppelin's MerkleProof.sol
     */
    function verifyCalldata(
        bytes32[] calldata proof,
        bytes32 root,
        bytes32 leaf
    ) internal pure returns (bool) {
        return processProofCalldata(proof, leaf) == root;
    }

    /**
     * @dev Calldata version of {processProof}
     * Copied from OpenZeppelin's MerkleProof.sol
     */
    function processProofCalldata(bytes32[] calldata proof, bytes32 leaf)
        internal
        pure
        returns (bytes32)
    {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; ) {
            computedHash = _hashPair(computedHash, proof[i]);
            unchecked {
                ++i;
            }
        }
        return computedHash;
    }

    /// @dev Copied from OpenZeppelin's MerkleProof.sol
    function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
        return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
    }

    /// @dev Copied from OpenZeppelin's MerkleProof.sol
    function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
        /// @solidity memory-safe-assembly
        assembly {
            mstore(0x00, a)
            mstore(0x20, b)
            value := keccak256(0x00, 0x40)
        }
    }
}
