

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "./CSale.sol";
abstract contract WhiteList is CSale {
    uint256 private whitelistcost = 0.00 ether;
    uint256 private maxWhiteListSupply = 1000;
    uint256 private countmintWhiteList = 0;
    bool private whiteListTime;
    uint32 private Seed;
    mapping(address => bool) public whitelisted;
    
    function getWhiteListTime() public view returns (bool) {
        return whiteListTime;    }
    function setWhiteListTime(bool _isTime) public onlyOwner {
        if (countmintWhiteList == maxWhiteListSupply){
            whiteListTime = false; 
        } 
        else 
        {
            whiteListTime = _isTime;    
        }}

    function addWhitelistUser(address _user) public onlyOwner {
        whitelisted[_user] = true;     }
    function removeWhitelistUser(address _user) public onlyOwner {
        whitelisted[_user] = false;    }

    function getWhiteListCost() public view returns (uint256) {
        return whitelistcost;    }
    function setWhiteListCost(uint256 _cost) public onlyOwner {
        whitelistcost = _cost * 1 wei;    }

    function getMintWhiteListSupply() public view returns (uint256) {
        return countmintWhiteList;    }
 
    function getWhiteListSupply() public view returns (uint256) {
        return maxWhiteListSupply;    }
    function setWhiteListSupply(uint256 _newmaxWhiteListSupply) public onlyOwner {
        require(_newmaxWhiteListSupply >= countmintWhiteList,"new amount must be greater than white list's minter counter");
        require(_newmaxWhiteListSupply <= maxSupply,"new amount must be lower than global limit");
        maxWhiteListSupply = _newmaxWhiteListSupply;    }

    function setSeed(uint32 _code) public onlyOwner {
        Seed = _code;    }
    function getSeed() public view onlyOwner returns (uint32) {
        return Seed;    }

    function mintWhitelist(uint256 _mintAmount, bytes32 _discordCode) public payable {
        require(!paused,"The mint is paused");
        require(getWhiteListTime(), "White list time is over - 111"); //Si evalua falso no sigue
        require(whitelisted[msg.sender] != true,"Only one minted by wallet is permitted");
        require(msg.value >= whitelistcost * _mintAmount,"Incorrect Cost");
        require(_mintAmount == 1,"Mint amount must be only One");
        uint256 supply = totalSupply();
        require(supply + _mintAmount <= maxSupply,"the amount to be minted exceeds the established limit, try less amount");
        require(IsDiscordCodeValid(_discordCode),"Discord Code Invalid");
        whitelisted[msg.sender] = true;
        _safeMint(msg.sender, supply + _mintAmount);    
        countmintWhiteList++; 
        if (countmintWhiteList == maxWhiteListSupply){
            whiteListTime = false; 
        } }

    function IsDiscordCodeValid(bytes32 _discordCode) private view  returns (bool) {
        require(getWhiteListTime(), "White list time is over - 222");
        return (_discordCode == makeHash(Seed));    }

}
