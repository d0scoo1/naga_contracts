// SPDX-License-Identifier: CAL
pragma solidity =0.8.10;

import {Factory} from "../factory/Factory.sol";
import "./Sale.sol";

import "@openzeppelin/contracts/proxy/Clones.sol";

/// @title SaleFactory
/// @notice Factory for creating and deploying `Sale` contracts.
contract SaleFactory is Factory {
    /// Template contract to clone.
    /// Deployed by the constructor.
    address private immutable implementation;

    /// Build the reference implementation to clone for each child.
    constructor(SaleConstructorConfig memory config_) {
        address implementation_ = address(new Sale(config_));
        // silence slither.
        require(implementation_ != address(0), "0_IMPLEMENTATION");
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
        (
            SaleConfig memory config_,
            SaleRedeemableERC20Config memory saleRedeemableERC20Config_
        ) = abi.decode(data_, (SaleConfig, SaleRedeemableERC20Config));
        address clone_ = Clones.clone(implementation);
        Sale(clone_).initialize(config_, saleRedeemableERC20Config_);
        return clone_;
    }

    /// Allows calling `createChild` with `SeedERC20Config` struct.
    /// Use original `Factory` `createChild` function signature if function
    /// parameters are already encoded.
    ///
    /// @param config_ `SaleConfig` constructor configuration.
    /// @return New `Sale` child contract.
    function createChildTyped(
        SaleConfig calldata config_,
        SaleRedeemableERC20Config calldata saleRedeemableERC20Config_
    ) external returns (Sale) {
        return
            Sale(
                this.createChild(
                    abi.encode(config_, saleRedeemableERC20Config_)
                )
            );
    }
}
