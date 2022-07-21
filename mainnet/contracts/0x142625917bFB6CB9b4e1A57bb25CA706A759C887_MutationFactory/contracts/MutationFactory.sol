// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./MutationContract.sol";

abstract contract LaunchPass {
    function balanceOf(address owner)
        public
        view
        virtual
        returns (uint256 balance);
    function ownerOf(uint256 tokenId)
        public
        view
        virtual
        returns (address);
}

contract MutationFactory is Ownable {

    mapping(uint256 => address) public deployments;
    address public launchpassAddress;
    MutationContract[] public nfts;

    constructor(address _launchpassAddress) {
        launchpassAddress = _launchpassAddress;
    }

    function setLaunchPassAddress(address _launchpassAddress) public onlyOwner {
        launchpassAddress = _launchpassAddress;
    }

    function getDeployedNFTs() public view returns (MutationContract[] memory) {
        return nfts;
    }

    function deploy(
        MutationContract.InitialParameters memory initialParameters
    ) public {
        LaunchPass launchpass = LaunchPass(launchpassAddress);
        require(launchpass.balanceOf(msg.sender) > 0,  "You do not have a LaunchPass.");
        require(launchpass.ownerOf(initialParameters.launchpassId) == msg.sender,  "You do not own this LaunchPass.");
        require(deployments[initialParameters.launchpassId] == address(0),  "This LaunchPass has already been used.");
        MutationContract nft = new MutationContract(msg.sender, initialParameters);
        deployments[initialParameters.launchpassId] = address(nft);
        nfts.push(nft);
    }

}
