// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./libraries/Clones.sol";
import "./Vindergood1155.sol";
import "./Vindergood721.sol";

contract VindergoodFactory is Initializable, OwnableUpgradeable {
    using SafeMath for uint256;

    uint256 public totalCollections;
    Vindergood721 private impl;
    Vindergood1155 private implMultiple;
    address private _proxyRegistryAddress;
    address private _exchangeAddress;

    mapping(address => address[]) public collections;
    mapping(address => address[]) public collectionsMutilpleSupply;

    event CollectionDeployed(address collection, address creator);
    event CollectionRegistrySettled(address oldRegistry, address newRegistry);
    event CollectionExchangeSettled(address oldExchange, address newExchange);

    function initialize(
        Vindergood1155 _implMultiple,
        Vindergood721 _impl,
        address _registry,
        address _exchange
    ) external initializer {
        require(_registry != address(0), "Invalid Address");
        require(_exchange != address(0), "Invalid Address");
        impl = _impl;
        implMultiple = _implMultiple;
        _proxyRegistryAddress = _registry;
        _exchangeAddress = _exchange;
    }

    function setProxyRegistry(address _registry) external onlyOwner {
        require(
            _registry != _proxyRegistryAddress,
            "VindergoodFactory::SAME REGISTRY ADDRESS"
        );
        emit CollectionRegistrySettled(_proxyRegistryAddress, _registry);
        _proxyRegistryAddress = _registry;
    }

    function setNewExchange(address _exchange) external onlyOwner {
        require(
            _exchange != _exchangeAddress,
            "VindergoodFactory::SAME EXCHANGE ADDRESS"
        );
        emit CollectionExchangeSettled(_exchangeAddress, _exchange);
        _exchangeAddress = _exchange;
    }

    function newCollection(
        string memory _name,
        string memory _symbol,
        string memory _tokenURI
    ) external returns (address) {
        address newCollection_ = Clones.clone(address(impl));
        address sender = msg.sender;

        Vindergood721(newCollection_).initialize(
            _name,
            _symbol,
            _tokenURI,
            _proxyRegistryAddress,
            _exchangeAddress
        );

        collections[sender].push(newCollection_);
        totalCollections = totalCollections.add(1);

        emit CollectionDeployed(newCollection_, sender);

        return newCollection_;
    }

    function newCollectionMultipleSupply(
        string memory _name,
        string memory _symbol,
        string memory _tokenURI
    ) external returns (address) {
        address newCollection_ = Clones.clone(address(implMultiple));
        address sender = msg.sender;

        Vindergood1155(newCollection_).initialize(
            _name,
            _symbol,
            _tokenURI,
            _proxyRegistryAddress,
            _exchangeAddress
        );

        collectionsMutilpleSupply[sender].push(newCollection_);
        totalCollections = totalCollections.add(1);

        emit CollectionDeployed(newCollection_, sender);

        return newCollection_;
    }
}
