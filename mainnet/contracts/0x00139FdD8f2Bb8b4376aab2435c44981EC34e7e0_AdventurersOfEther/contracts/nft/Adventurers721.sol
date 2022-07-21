//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.11;

import "../interfaces/ITreasury.sol";
import "./adventurer/PublicSale.sol";
import "./adventurer/PreSale.sol";
import "./adventurer/Reveal.sol";
import "./adventurer/WhiteList.sol";

/**
 * @notice Adventurers Token
 */
contract AdventurersOfEther is PublicSale, WhiteList, PreSale, Reveal {
    ITreasury public treasury;

    constructor() {}

    function mintBatch(address[] memory _to, uint256[] memory _amount)
        external onlyOwner returns (uint oldIndex, uint newIndex)
    {
        return _mintBatch(_to, _amount);
    }

    function burn(uint256[] calldata _tokens) external onlyOwner {
        _burn(_tokens);
    }

    function setTreasury(ITreasury _value) external onlyOwner {
        treasury = _value;
    }

    /**
     * @notice poll payment to treasury
     */
    function transferToTreasury() external {
        require(address(treasury) != address(0), "zero treasury address");
        treasury.primarySale{value: address(this).balance}();
    }
}
