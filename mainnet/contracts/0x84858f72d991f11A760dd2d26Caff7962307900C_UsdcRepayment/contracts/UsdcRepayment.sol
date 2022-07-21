// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract UsdcRepayment is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    event Claim(address from, address to, address token, uint256 amount);
    event TokenSeized(address token, uint256 amount);
    event Paused(bool paused);
    event MerkleRootUpdated(bytes32 oldMerkleRoot, bytes32 newMerkleRoot);
    event ExcludedUpdated(address user, address token, uint256 amount);

    address public immutable USDC;

    bytes32 public merkleRoot;
    bool public paused;
    mapping(address => uint256) public excluded;
    mapping(address => bool) public claimed;
    address public creth2Repayment;

    constructor(bytes32 _merkleRoot, address _token) {
        merkleRoot = _merkleRoot;
        USDC = _token;
    }

    function claim(uint256 amount, bytes32[] memory proof) external {
        _claimAndTransfer(msg.sender, msg.sender, amount, proof);
    }

    function claimFor(address _address, uint256 amount, bytes32[] memory proof) external {
        require(msg.sender == creth2Repayment, "creth2Repayment contract only");
        _claimAndTransfer(_address, _address, amount, proof);
    }

    // Like claim(), but transfer to `to` address.
    function claimAndTransfer(address to, uint256 amount, bytes32[] memory proof) external {
        _claimAndTransfer(msg.sender, to, amount, proof);
    }

    // Claim for a contract and transfer tokens to `to` address.
    function adminClaimAndTransfer(address from, address to, uint256 amount, bytes32[] memory proof) external onlyOwner {
        require(Address.isContract(from), "not a contract");
        _claimAndTransfer(from, to, amount, proof);
    }

    function _claimAndTransfer(address from, address to, uint256 amount, bytes32[] memory proof) internal nonReentrant {
        require(claimed[from] == false, "claimed");
        require(!paused, "claim paused");

        // Check the Merkle proof.
        bytes32 leaf = keccak256(abi.encodePacked(from, amount));
        bool verified = MerkleProof.verify(proof, merkleRoot, leaf);
        require(verified, "invalid amount");

        // Update the storage.
        claimed[from] = true;

        if (amount > excluded[from]) {
            IERC20(USDC).transfer(to, amount - excluded[from]);
            emit Claim(from, to, USDC, amount - excluded[from]);
        }
    }

    function seize(address token, uint amount) external onlyOwner {
        IERC20(token).safeTransfer(owner(), amount);
        emit TokenSeized(token, amount);
    }

    function updateMerkleTree(bytes32 _merkleRoot) external onlyOwner {
        bytes32 oldMerkleRoot = merkleRoot;
        merkleRoot = _merkleRoot;
        emit MerkleRootUpdated(oldMerkleRoot, _merkleRoot);
    }

    function pause(bool _paused) external onlyOwner {
        require(paused != _paused, "invalid paused");

        paused = _paused;
        emit Paused(_paused);
    }

    function setExcluded(address user, uint256 amount) external onlyOwner {
        require(!claimed[user], "already claimed");

        if (amount != excluded[user]) {
            excluded[user] = amount;
            emit ExcludedUpdated(user, USDC, amount);
        }
    }

    function setCreth2Repayment(address _creth2Repayment) external onlyOwner {
        creth2Repayment = _creth2Repayment;
    }
}
