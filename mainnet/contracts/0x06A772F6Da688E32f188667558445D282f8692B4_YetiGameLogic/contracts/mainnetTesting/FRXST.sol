pragma solidity ^0.8.0;


import "./ERC20.sol";
import "./Ownable.sol";
import "hardhat/console.sol";

contract FRXST is ERC20, Ownable {

  // a mapping from an address to whether or not it can mint / burn
  mapping(address => bool) controllers;
  
  constructor() ERC20("FRXST", "FRXST") {

      console.log("Hey from FRXST");
   }

  /**
   * mints $FRXST to a recipient
   * @param to the recipient of the $FRXST
   * @param amount the amount of $FRXST to mint
   */
  function mint(address to, uint256 amount) external {
    require(controllers[msg.sender], "Only controllers can mint");
    _mint(to, amount);
  }

  /**
   * burns $FRXST from a holder
   * @param from the holder of the $FRXST
   * @param amount the amount of $FRXST to burn
   */
  function burn(address from, uint256 amount) external {
    require(controllers[msg.sender], "Only controllers can burn");
    _burn(from, amount);
  }

  /**
   * enables an address to mint / burn
   * @param controller the address to enable
   */
  function addController(address controller) external onlyOwner {
    controllers[controller] = true;
  }

  /**
   * disables an address from minting / burning
   * @param controller the address to disbale
   */
  function removeController(address controller) external onlyOwner {
    controllers[controller] = false;
  }
}