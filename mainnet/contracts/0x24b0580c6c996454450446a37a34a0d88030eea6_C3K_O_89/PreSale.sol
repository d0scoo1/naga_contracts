// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "./CSale.sol";

abstract contract PreSale is CSale {
    uint256 private presaleCost = 0.04 ether; //40000000000000000
    uint256 private maxPresaleSupply = 1000;
    uint256 private countmintPresale = 0;

    mapping(address => int) public preSaleMinters;
    
    function addPresaleUser(address _user) public onlyOwner{
        preSaleMinters[_user] += 1;    }
    function removePresaleUser(address _user) public onlyOwner {
        preSaleMinters[_user] = 0;    }
    
    function getPreSaleCost() public view returns (uint256) {
        return presaleCost;    }
    function setPresaleCost(uint256 _newCost) public onlyOwner {
        presaleCost = _newCost * 1 wei;    }

    function getMintPresaleSupply() public view returns (uint256) {
        return countmintPresale;    }
    
    function setmaxPresaleSupply(uint256 _newmaxPresaleSupply) public onlyOwner {
        require(_newmaxPresaleSupply >= countmintPresale,"New amount must be greater than presale's minter counter");
        require(_newmaxPresaleSupply <= maxSupply,"New amount must be lower than global limit");
        maxPresaleSupply = _newmaxPresaleSupply;    }
    function getmaxPresaleSupply() public view returns (uint256) {
        return maxPresaleSupply;    }






    function mintPresale(uint256 _mintAmount) public payable {
        uint256 supply = totalSupply();
        require(!paused,"The mint is paused"); //Evalua a false para no pasar
        require(saleTime == false, "Presale time is over");
        require(msg.value  >= presaleCost * _mintAmount, "Incorrect Cost");
        require(_mintAmount > 0, "Mint Amount must be more then Zero");
        require(supply + _mintAmount <= maxSupply,"the amount to be minted exceeds the established limit, try less amount");
        require(countmintPresale + _mintAmount <= maxPresaleSupply,"the amount to be minted exceeds the established limit, for presale, try less amount");
        if (preSaleMinters[msg.sender] == 0) {
            preSaleMinters[msg.sender] = int256(_mintAmount);
        }
        else {
            preSaleMinters[msg.sender]+= int256(_mintAmount);
        }
        countmintPresale+=_mintAmount;
        for (uint256 i = 1; i <= _mintAmount; i++) {
            _safeMint(msg.sender, supply + i);
        }    
        if (countmintPresale == maxPresaleSupply)
            saleTime=false; }
    function getPreSaleMintersCount(address _account) public view returns (int) {
        return preSaleMinters[_account];
    }

}

