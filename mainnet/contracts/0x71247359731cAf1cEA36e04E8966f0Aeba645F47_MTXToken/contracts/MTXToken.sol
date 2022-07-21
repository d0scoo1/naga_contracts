//SPDX-License-Identifier: MIT
/**
███    ███  █████  ████████ ██████  ██ ██   ██     ██████   █████   ██████  
████  ████ ██   ██    ██    ██   ██ ██  ██ ██      ██   ██ ██   ██ ██    ██ 
██ ████ ██ ███████    ██    ██████  ██   ███       ██   ██ ███████ ██    ██ 
██  ██  ██ ██   ██    ██    ██   ██ ██  ██ ██      ██   ██ ██   ██ ██    ██ 
██      ██ ██   ██    ██    ██   ██ ██ ██   ██     ██████  ██   ██  ██████  

Website: https://matrixdaoresearch.xyz/
Twitter: https://twitter.com/MatrixDAO_
 */
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/INFTMatrixDao.sol";


contract MTXToken is ERC20 {
    INFTMatrixDao public immutable nft;

    mapping(uint256 => bool) public claimed;

    constructor(INFTMatrixDao nft_) ERC20("MatrixDAO Token", "MTX") {
        nft = nft_;
        _mint(msg.sender, 8_000_000 ether);
    }

    function claim(uint256 tokenId) public {
        require(
            nft.ownerOf(tokenId) == msg.sender,
            "Not the owner"
        );
        require(!claimed[tokenId], "Already Claimed");
        claimed[tokenId] = true;
        _mint(msg.sender, 2000 ether);
    }
}