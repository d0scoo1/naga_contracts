//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "./CSale.sol";

abstract contract LiveSale is CSale {
    uint256 private cost = 0.08 ether; //80000000000000000
    //bool private saleTime; // True = Live Sale, False = Pre Sale

    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost * 1 wei; }

    function getCost() public view returns (uint256) {
        return cost; }

    function mintGeneral(uint256 _mintAmount) public payable {
        uint256 supply = totalSupply();
        require(!paused, "The mint is paused"); //Si evalua falso no sigue
        require(saleTime == true, "Is time to pre-sale");
        require(_mintAmount > 0, "Mint amount must be more than Zero");
        require(_mintAmount <= maxMintAmount,
            "Mint amount must be less or equal than Max Mint amount permited");
        require(supply + _mintAmount <= maxSupply,
            "the amount to be minted exceeds the established limit");
        require(msg.value >= cost * _mintAmount, "Incorrect Cost");
        for (uint256 i = 1; i <= _mintAmount; i++) {
            _safeMint(msg.sender, supply + i);
        }
    }
}
