//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.12;

import "@openzeppelin/contracts/access/IAccessControl.sol";
import "@openzeppelin/contracts/interfaces/IERC721.sol";
import "@openzeppelin/contracts/interfaces/IERC721Metadata.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";

interface IPikotaroZombieNFT is IAccessControl, IERC2981, IERC721, IERC721Metadata {
    function owner() external view returns (address);
    function transferOwnership(address newOwner) external;
    function totalSupply() external view returns (uint256);
    function setTokenURI(string memory tokenURI_) external;
    function setDefaultRoyalty(address receiver, uint96 feeNumerator) external;
    function tokenCount() external view returns (uint256);
    function activate(uint256 totalSupply_, address royaltyRecipient_) external;
    function mint(address to) external;
}
