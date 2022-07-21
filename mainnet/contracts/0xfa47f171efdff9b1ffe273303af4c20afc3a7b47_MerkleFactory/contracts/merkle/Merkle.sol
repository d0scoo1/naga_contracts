pragma solidity 0.8.10;
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Merkle is Ownable {
    bytes32 private root;
    bool public initialized;

    function initialize(bytes32 _root, address _owner) public {
        require(!initialized, "Only called once");
        root = _root;
        _transferOwnership(_owner);
        initialized = true;
    }

    function leaf(
        address account /*, uint256 tokenId*/
    ) public pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    account
                )
            );
    }

    function isPermitted(address account, bytes32[] memory proof) external view returns (bool) {
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
