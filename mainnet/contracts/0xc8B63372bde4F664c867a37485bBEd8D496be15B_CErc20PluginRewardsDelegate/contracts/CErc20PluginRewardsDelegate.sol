pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

import "./CErc20PluginDelegate.sol";

contract CErc20PluginRewardsDelegate is CErc20PluginDelegate {
    /**
     * @notice Delegate interface to become the implementation
     * @param data The encoded arguments for becoming
     */
    function _becomeImplementation(bytes calldata data) external {
        require(msg.sender == address(this) || hasAdminRights());

        (address _plugin, address _rewardsDistributor, address _rewardToken) = abi.decode(
            data,
            (address, address, address)
        );

        require(address(plugin) == address(0), "plugin");
        plugin = IERC4626Draft(_plugin);

        EIP20Interface(underlying).approve(_plugin, uint256(-1));
        EIP20Interface(_rewardToken).approve(_rewardsDistributor, uint256(-1));
    }

    /// @notice A reward token claim function 
    /// to be overriden for use cases where rewardToken needs to be pulled in
    function claim() external {}
}