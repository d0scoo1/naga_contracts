//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AnniversaryToken is Ownable {
    uint256 public startingTimestamp;
    address public groomAddress;

    receive() external payable {}

    constructor(uint256 _startingTimestamp, address groom){
        startingTimestamp = _startingTimestamp;
        groomAddress = groom;
    }

    function emergencyWithdraw() external onlyOwner {
        uint256 total = (address(this)).balance;
        payable(msg.sender).transfer(total);
    }

    modifier onlyGroom() {
        require(msg.sender == groomAddress, "Only Groom alloed");
        _;
    }

    function withdraw() external onlyGroom {
        require(block.timestamp >= startingTimestamp + 100 days, "Only claim on anniversary dates");
        payable(msg.sender).transfer(0.1 ether);
        startingTimestamp = block.timestamp;
    }

    function changeGroom(address _groom) external {
        groomAddress = _groom;
    }
}