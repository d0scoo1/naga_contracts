// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Merkle is Ownable {
    bytes32 private root;

    constructor(bytes32 _root) {
        root = _root;
    }

    function leaf(address account) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(account));
    }

    function isPermitted(address account, bytes32[] memory proof)
        external
        view
        returns (bool)
    {
        return verify(leaf(account), proof);
    }

    function verify(bytes32 _leaf, bytes32[] memory proof)
        public
        view
        returns (bool)
    {
        return MerkleProof.verify(proof, root, _leaf);
    }

    function setRoot(bytes32 _root) external onlyOwner {
        root = _root;
    }
}
