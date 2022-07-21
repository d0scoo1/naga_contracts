// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.4;

import "../token/onft/ONFT.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CyberFukuro is ONFT {
    uint public nextMintId;
    address public managerAddress;

    modifier onlyManager() {
        require(msg.sender == managerAddress, "Only manager can call this function.");
        _;
    }

    /// @param _layerZeroEndpoint handles message transmission across chains
    constructor(address _layerZeroEndpoint) ONFT("Cyber Fukuro", "Fukuro", _layerZeroEndpoint) {
        nextMintId = 0;
        managerAddress = msg.sender;
    }

    /// @notice Mint your ONFT
    function mint(uint numFukuro) public onlyManager {
        for (uint i = 0; i < numFukuro; i++) {
            uint newId = nextMintId;
            nextMintId++;
            _safeMint(msg.sender, newId);
        }
    }

    function setManagerAddress(address _managerAddress) public onlyOwner {
        managerAddress = _managerAddress;
    }
}
