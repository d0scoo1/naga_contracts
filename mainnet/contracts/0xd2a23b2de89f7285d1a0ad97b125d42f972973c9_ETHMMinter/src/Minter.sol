pragma solidity ^0.8.9 <0.9.0;

import './EthMonkeys.sol';
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";


interface IERC721F is IERC721{
     function adminMint(address to, uint256 numberOfTokens) external;
     function transferOwnership(address newOwner) external;
}   

contract ETHMMinter is Ownable {
    mapping(address => uint256) public amount;
    bool public freeMintActive ;
    uint256 public maxFreeMint = 1;

    IERC721F public monkeyContr;

      constructor() {
          monkeyContr = IERC721F(0xE838e314f1aeA976E18D8299a08baCe58247e0Ca);
    }

    function mint() external payable {
          require(freeMintActive, "freeMint is not active yet");
          require(amount[msg.sender] < (maxFreeMint), "Already got free mint");
          monkeyContr.adminMint(msg.sender, 1);
          amount[msg.sender] += 1;
    }

    function setMaxFreeMint(uint256 newMax) external onlyOwner {
        maxFreeMint = newMax;
    }

    function flipFreeMintActive() external onlyOwner {
        freeMintActive = !freeMintActive;
    }

    function transferMonkeyOwnership(address newOwner) external onlyOwner {
        monkeyContr.transferOwnership(newOwner);
    }
}