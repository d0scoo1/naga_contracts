/* 
This smart contract represents the "METAPUNKS" collection of Inter-Planetary Cosmos 2021.
Every Metapunk is a unique token represented by a digital Artwork.
Learn More at: https://inter-planetary.world.
*/

pragma solidity ^0.5.16;

import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "@openzeppelin/contracts/access/roles/MinterRole.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract InterPlanetary is Ownable, MinterRole, ERC721Full {
  using SafeMath for uint;

  constructor() ERC721Full("IPC METAPUNKS", "IPCM") public {
  }

  function mint(address _to, string memory _tokenURI) public onlyMinter returns (bool) {
    _mintWithTokenURI(_to, _tokenURI);
    return true;
  }

  function _mintWithTokenURI(address _to, string memory _tokenURI) internal {
    uint _tokenId = totalSupply().add(1);
    _mint(_to, _tokenId);
    _setTokenURI(_tokenId, _tokenURI);
  }
}