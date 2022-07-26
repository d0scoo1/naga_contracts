// SPDX-License-Identifier: Unliscensed
pragma solidity ^0.8.6;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./2_DayManToken.sol";

contract NightManToken is ERC20{
    
    DayManToken dayManToken;
    uint256 public _totalBurned;
    uint256 maxCombinedSupply = 1000000*10**decimals();
    
    
    constructor() ERC20("NightManToken","NMCX"){
        _totalBurned = maxCombinedSupply / 2;
        dayManToken = new DayManToken( payable(address(this)) );

    }
     
    function totalBurned() public view returns (uint256){
        return(_totalBurned);
    }

    function dayManTokenAddress() public view returns (address payable){
        return payable(address(dayManToken));
    }

    fallback() external payable {}
    receive() external payable {}
    
    function _transfer(address sender, address recipient, uint256 amount) override(ERC20) internal {
        _burn(sender, amount/100); //burns 1% of transaction
        _totalBurned += amount/100; // and adds that to the total burned
        payable(address(dayManToken)).transfer((address(this).balance * (amount/100))/totalSupply()); //then sends the troll toll to rival contract
        super._transfer(sender, recipient, (99*amount)/100); //finally makes the transfer
    }
    

    function tokensPurchased(uint256 valueSent) public view returns (uint256){
        return (valueSent * maxCombinedSupply) / (_totalBurned + dayManToken.totalBurned()) * 1000; //returns the amount of tokens a purchase would give. inversly proportional to the amount of tokens burned.
    }
    
    function purchaseTokens() public payable{
        require(msg.value > 0); //amount purchased must be greater than zero
        if(tokensPurchased(msg.value) + totalSupply() + dayManToken.totalSupply() > maxCombinedSupply){ // if the value sent in would result in more tokens than allowed
            _mint(msg.sender, maxCombinedSupply - (totalSupply() + dayManToken.totalSupply())); // mints the max amount of tokens possible
           payable(msg.sender).transfer(msg.value - (msg.value * (maxCombinedSupply - (totalSupply() + dayManToken.totalSupply()))) / tokensPurchased(msg.value)); // sends back the unused eth
        }else{
            _mint(msg.sender, tokensPurchased(msg.value)); // mints tokens normally if it would not execeed the max supply
        }
    }
    
    function exchangeTokens(address payable to, uint256 amount) public {
        require(amount>0);
        require(balanceOf(msg.sender)>=amount);
        _burn(msg.sender, amount);
        _totalBurned += amount;
        to.transfer((address(this).balance * amount) / totalSupply());
    }
    
}