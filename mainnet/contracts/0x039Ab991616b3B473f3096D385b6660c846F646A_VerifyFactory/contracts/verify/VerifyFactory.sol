// SPDX-License-Identifier: CAL
pragma solidity =0.8.10;

import {Factory} from "../factory/Factory.sol";
import {Verify, VerifyConfig} from "./Verify.sol";

import "@openzeppelin/contracts/proxy/Clones.sol";

/// @title VerifyFactory
/// @notice Factory for creating and deploying `Verify` contracts.
contract VerifyFactory is Factory {
    /// Template contract to clone.
    /// Deployed by the constructor.
    address public immutable implementation;

    /// Build the reference implementation to clone for each child.
    constructor() {
        address implementation_ = address(new Verify());
        emit Implementation(msg.sender, implementation_);
        implementation = implementation_;
    }

    /// @inheritdoc Factory
    function _createChild(bytes calldata data_)
        internal
        virtual
        override
        returns (address)
    {
        VerifyConfig memory config_ = abi.decode(data_, (VerifyConfig));
        address clone_ = Clones.clone(implementation);
        Verify(clone_).initialize(config_);
        return clone_;
    }

    /// Typed wrapper for `createChild` with admin address.
    /// Use original `Factory` `createChild` function signature if function
    /// parameters are already encoded.
    ///
    /// @param config_ Initialization config for the new `Verify` child.
    /// @return New `Verify` child contract address.
    function createChildTyped(VerifyConfig calldata config_)
        external
        returns (Verify)
    {
        return Verify(this.createChild(abi.encode(config_)));
    }
}
