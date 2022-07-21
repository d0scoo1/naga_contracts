// SPDX-License-Identifier: MIT
// The line above is recommended and let you define the license of your contract
// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.0;
import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "../interfaces/IConfig.sol";
import "../interfaces/IRegistry.sol";
import "../interfaces/ISmartAccount.sol";
import "../interfaces/IPortal.sol";
import "../interfaces/socket/ISocketRegistry.sol";

contract Config is
    AccessControlEnumerableUpgradeable,
    PausableUpgradeable,
    IConfig
{
    IPortal public override portal;
    IRegistry public override registry;
    ISocketRegistry public override socketRegistry;
    ISmartAccountFactory public override smartAccountFactory;

    function _initialize() public initializer {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function setPortal(IPortal p)
        external
        override
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        portal = p;
    }

    function setRegistry(IRegistry p)
        external
        override
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        registry = p;
    }

    function setSocketRegistry(ISocketRegistry s)
        external
        override
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        socketRegistry = s;
    }

    function setSmartAccountFactory(ISmartAccountFactory b)
        external
        override
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        smartAccountFactory = b;
    }
}
