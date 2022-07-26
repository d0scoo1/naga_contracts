// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

/**
 * @title ENS registry
 *
 * @dev Base on https://github.com/ensdomains/ens/blob/v0.2.2/contracts/ENSRegistry.sol
 */
contract ENSRegistry {
  struct Record {
    address owner;
    address resolver;
    uint64 ttl;
  }

  mapping(bytes32 => Record) private records;

  // events

  event NewOwner(
    bytes32 indexed node,
    bytes32 indexed label,
    address owner
  );

  event Transfer(
    bytes32 indexed node,
    address owner
  );

  event NewResolver(
    bytes32 indexed node,
    address resolver
  );

  event NewTTL(
    bytes32 indexed node,
    uint64 ttl
  );

  // modifiers

  modifier onlyNodeOwner(
    bytes32 node
  ) {
    require(
      records[node].owner == msg.sender,
      "ENSRegistry: msg.sender is not the node owner"
    );

    _;
  }

  /**
   * @dev public constructor
   */
  constructor()
    public
  {
    // solhint-disable-next-line avoid-tx-origin
    records[0x0].owner = tx.origin;
  }

  // external functions

  function setOwner(
    bytes32 node,
    address owner
  )
    external
    onlyNodeOwner(node)
  {
    records[node].owner = owner;

    emit Transfer(node, owner);
  }

  function setSubnodeOwner(
    bytes32 node,
    bytes32 label,
    address owner
  )
    external
    onlyNodeOwner(node)
  {
    bytes32 subNode = keccak256(
      abi.encodePacked(
        node,
        label
      )
    );

    records[subNode].owner = owner;

    emit NewOwner(node, label, owner);
  }

  function setResolver(
    bytes32 node,
    address resolver
  )
    external
    onlyNodeOwner(node)
  {
    records[node].resolver = resolver;

    emit NewResolver(node, resolver);
  }

  function setTTL(
    bytes32 node,
    uint64 ttl
  )
    external
    onlyNodeOwner(node)
  {
    records[node].ttl = ttl;

    emit NewTTL(node, ttl);
  }

  // external functions (views)

  function owner(
    bytes32 node
  )
    external
    view
    returns (address)
  {
    return records[node].owner;
  }

  function resolver(
    bytes32 node
  )
    external
    view
    returns (address)
  {
    return records[node].resolver;
  }

  function ttl(
    bytes32 node
  )
    external
    view
    returns (uint64)
  {
    return records[node].ttl;
  }
}
