//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.4;

import "erc721a-upgradeable/contracts/IERC721AUpgradeable.sol";

interface IBredStrain is IERC721AUpgradeable {
    function mint(address account, uint256 quantity) external;

    function burn(uint256 id) external;
}
