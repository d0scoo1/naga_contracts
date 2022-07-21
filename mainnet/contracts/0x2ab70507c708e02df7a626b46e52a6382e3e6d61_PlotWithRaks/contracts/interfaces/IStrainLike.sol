//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "./IWithCoreTraits.sol";

interface IStrainLike is IERC721Upgradeable, IDeclareCoreTraits {
    function coreTraits(uint256 id) external view returns (CoreTraits memory);

    function burn(uint256 id) external;
}
