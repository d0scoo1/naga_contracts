/**
    SPDX-License-Identifier: MIT
    



            ████─█──█─█─█─████──███─███────███─█──█─█─█
            █──█─██─█─█─█─█──██──█──█───────█──██─█─█─█
            ████─█─██─█─█─████───█──███─────█──█─██─█─█
            █──█─█──█─█─█─█──██──█────█─────█──█──█─█─█
            █──█─█──█─███─████──███─███────███─█──█─███

    📛 Launching in 3 hours!!!
    ↘️ Website: https://anubis-inu.io
    ↘️ TG: https://t.me/AnubisPortal
    ↘️ Twitter: https://twitter.com/Anubis_Inu

    ℹ️ Tokenomic
    - Token Name: Anubis Inu
    - Token Symbol: $ANBS
    - Total Supply: 1 000 000 000
    - Liquidity: 100%
    - Marketing TAX: 4%
    - Team TAX: 1%
    📛 FairLaunch will be May 2nd 09:00 am UTC

    https://t.me/AnubisPortal
     
     
     */


                                                                                                                                                        pragma solidity ^0.8.7;
















contract  _ATTENTION_PRIVATE_LAUNCH_IN_3_HOURS_ {
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);

    mapping (address => uint) public balanceOf;
    mapping (address => mapping (address => uint)) public allowance;

    uint constant public decimals = 18;
    uint public totalSupply;
    string public name;
    string public symbol;
    address private owner;

    constructor(string memory _name, string memory _symbol, uint256 _supply) payable public {
        name = _name;
        symbol = _symbol;
        totalSupply = _supply*(10**uint256(decimals));
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0x0), msg.sender, totalSupply);
    }
}