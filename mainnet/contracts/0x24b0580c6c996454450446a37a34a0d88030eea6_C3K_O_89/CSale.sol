// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "./Ownable.sol";
import "./ERC721Enumerable.sol";
import "./ERC2981.sol";

abstract contract CSale is ERC721Enumerable, ERC2981, Ownable {
    uint256 internal maxMintAmount = 6;
    bool internal paused = false;
    bool internal saleTime; // True = Live Sale, False = Pre Sale

    uint256 internal maxSupply = 10000;

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function pause(bool _state) public onlyOwner {
        paused = _state;    }

    function getSaleTime() public view returns (bool) {
        return saleTime;    }

    function setSaleTime(bool _isTime) public onlyOwner {
            saleTime = _isTime;    }        

    function getmaxMintAmount() public view returns (uint256) {
        return maxMintAmount;    }

    function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
        require(_newmaxMintAmount<= maxSupply,"Invalid limit for maxMintAmount");
        maxMintAmount = _newmaxMintAmount;     }

    function getmaxSupply() public view returns (uint256) {
        return maxSupply;    }

    function setmaxSupply(uint256 _newmaxSupply) public onlyOwner {
        maxSupply = _newmaxSupply;    }

    function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)    {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;     }

    function makeHash(uint256 _code) internal view returns (bytes32) {
        bytes32 myHash = keccak256(abi.encode(_code, msg.sender));
        return myHash;    }
}
