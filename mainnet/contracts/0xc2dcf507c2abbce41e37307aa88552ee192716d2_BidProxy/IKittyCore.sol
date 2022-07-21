//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface IKittyCore {
    function ownerOf(uint256 _tokenId) external view returns (address owner);
    function transfer(address _to, uint256 _tokenId) external;
}
