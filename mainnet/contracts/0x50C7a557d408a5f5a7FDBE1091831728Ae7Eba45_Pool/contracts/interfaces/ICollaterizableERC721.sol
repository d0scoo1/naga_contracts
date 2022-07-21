// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.10;

/**
 * @title ICollaterizableERC721
 * @author Parallel
 * @notice Defines the basic interface for an CollaterizableERC721.
 **/
interface ICollaterizableERC721 {
    /**
     * @dev get the collaterized balance of a specific user
     */
    function collaterizedBalanceOf(address user)
        external
        view
        virtual
        returns (uint256);

    /**
     * @dev get the the collateral configuation of a spefifc token
     */
    function isUsedAsCollateral(uint256 tokenId) external view returns (bool);

    /**
     * @dev changes the collateral state/config of a token
     * @return bool (if the state has changed), address (the owner address), uint256 (user's new collaterized balance)
     */
    function setIsUsedAsCollateral(uint256 tokenId, bool useAsCollateral)
        external
        virtual
        returns (
            bool,
            address,
            uint256
        );
}
