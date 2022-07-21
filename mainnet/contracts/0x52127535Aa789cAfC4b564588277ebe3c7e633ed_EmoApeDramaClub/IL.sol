// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0;

import "./IERC721Enumerable.sol";

interface IL is IERC721Enumerable {
    function _tokenIdToHash(uint256 _tokenId)
        external
        view
        returns (string memory);

    function hashToSVG(string memory _hash)
        external
        view
        returns (string memory);
}