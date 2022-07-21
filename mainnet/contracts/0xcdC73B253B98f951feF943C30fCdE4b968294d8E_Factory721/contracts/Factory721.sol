//SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.13;

import "./CrossTowerStorefrontUserToken721.sol";

contract Factory721 {
    event Deployed(address owner, address contractAddress);

    function deploy(
        bytes32 _salt,
        string memory name,
        string memory symbol,
        string memory tokenURIPrefix,
        address operator
    ) external returns (address addr) {
        addr = address(
            new CrossTowerStorefrontUserToken721{salt: _salt}(
                name,
                symbol,
                tokenURIPrefix,
                operator
            )
        );
        CrossTowerStorefrontUserToken721 token = CrossTowerStorefrontUserToken721(address(addr));
        token.transferOwnership(msg.sender);
        emit Deployed(msg.sender, addr);
    }
}