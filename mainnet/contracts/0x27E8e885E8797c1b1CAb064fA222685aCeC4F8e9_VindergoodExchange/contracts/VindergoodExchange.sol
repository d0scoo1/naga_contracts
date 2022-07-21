// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

import "./exchange/Exchange.sol";
import "./registry/ProxyRegistry.sol";
import "./modules/VindergoodTransferProxy.sol";
import "./modules/ERC20.sol";

contract VindergoodExchange is Exchange {
    string public constant name = "Project Wyvern Exchange";

    /**
     * @dev Initialize a WyvernExchange instance
     * @param registryAddress Address of the registry instance which this Exchange instance will use
     * @param tokenAddress Address of the token used for protocol fees
     */
    constructor(
        ProxyRegistry registryAddress,
        VindergoodTransferProxy tokenTransferProxyAddress,
        ERC20 tokenAddress
    ) {
        registry = registryAddress;
        tokenTransferProxy = tokenTransferProxyAddress;
        exchangeToken = tokenAddress;
    }
}
