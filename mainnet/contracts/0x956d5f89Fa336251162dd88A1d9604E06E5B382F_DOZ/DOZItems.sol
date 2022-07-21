import "./ERC721.sol";
import "./SafeMath.sol";
import "./AccessControl.sol";
import "./VRFConsumerBase.sol";

//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/**
 * @title Dragons of Zobrotera items contract
 * @dev Extends ERC721 Non-Fungible Token Standard implementation
 */
abstract contract DOZItems is ERC721, AccessControl, VRFConsumerBase{
    function updateNumberOfItemType(uint256 newValue) public onlyOwner {}
    function addAirdroperAddress(address airdroperAddress) public onlyOwner{}
    function withdraw() public onlyOwner {}
    function flipSaleState() public onlyOwner{}
    function flipOpenState() public onlyOwner{}
    function updateMaxSupply(uint256 newMaxSupply) public onlyOwner{}
    function loadTokenSpecs(uint256 tokenId) private returns (bytes32 requestId) {}
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {}
    function openLootBox(uint256 lootboxId) public {}
    function buyLootBoxes(uint256 numberOfBoxes, address _to) public payable {}
    function airdropNft(uint256 numberOfBoxes, address _to) public {}
    function totalSupply() public view returns (uint256) {}
    function getTokenSpec(uint256 tokenId) public view returns (uint256) {}
}