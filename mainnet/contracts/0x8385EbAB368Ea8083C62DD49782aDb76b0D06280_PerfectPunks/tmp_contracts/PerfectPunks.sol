// SPDX-License-Identifier: UNLICENSED
/// @title PerfectPunks
/// @notice Perfect Punks
/// @author CyberPnk <cyberpnk@perfectpunks.cyberpnk.win>

pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@cyberpnk/solidity-library/contracts/INftRenderer.sol";
import "@cyberpnk/solidity-library/contracts/RenderContractLockable.sol";
import "@cyberpnk/solidity-library/contracts/DestroyLockable.sol";
// import "hardhat/console.sol";

contract PerfectPunks is ERC721, IERC721Receiver, Ownable, ReentrancyGuard, RenderContractLockable, DestroyLockable {
    address public v1WrapperContract;
    address public v2WrapperContract;
    IERC721 v1Wrapper;
    IERC721 v2Wrapper;

    function wrap(uint16 _punkId) external nonReentrant {
        require(v1Wrapper.ownerOf(uint(_punkId)) == msg.sender && v2Wrapper.ownerOf(uint(_punkId)) == msg.sender, "Not yours");
        v1Wrapper.safeTransferFrom(msg.sender, address(this), uint(_punkId));
        v2Wrapper.safeTransferFrom(msg.sender, address(this), uint(_punkId));
        _mint(msg.sender, uint(_punkId));
    }

    function unwrap(uint16 _punkId) external nonReentrant {
        require (ownerOf(uint(_punkId)) == msg.sender, "Not yours");
        _burn(uint(_punkId));
        v1Wrapper.safeTransferFrom(address(this), msg.sender, uint(_punkId));
        v2Wrapper.safeTransferFrom(address(this), msg.sender, uint(_punkId));
    }

    function tokenURI(uint256 itemId) public view override returns (string memory) {
        return INftRenderer(renderContract).getTokenURI(itemId);
    }

    function contractURI() external view returns(string memory) {
        return INftRenderer(renderContract).getContractURI(owner());
    }

    function onERC721Received(address, address, uint256, bytes memory) override public pure returns(bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    constructor(address _v1WrapperContract, address _v2WrapperContract) ERC721("PerfectPunks","PERFECTPUNKS") Ownable() {
        v1WrapperContract = _v1WrapperContract;
        v2WrapperContract = _v2WrapperContract;
        v1Wrapper = IERC721(_v1WrapperContract);
        v2Wrapper = IERC721(_v2WrapperContract);
    }

}
