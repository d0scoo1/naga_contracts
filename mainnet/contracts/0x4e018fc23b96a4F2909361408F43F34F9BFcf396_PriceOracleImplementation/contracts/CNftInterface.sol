// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.5.16;

/// @dev Keep in sync with CNftInterface080.sol.
contract CNftInterface {
    address public underlying;
    bool is1155;
    address public comptroller;
    bool public constant isCNft = true;

    /// @notice Mapping from user to number of tokens.
    mapping(address => uint256) public totalBalance;

    /**
     * @notice Event emitted when cNFTs are minted
     */
    event Mint(address minter, uint[] mintIds, uint[] mintAmounts);

    /**
     * @notice Event emitted when tokens are redeemed
     */
    event Redeem(address redeemer, uint[] redeemIds, uint[] redeemAmounts);

    function seize(address liquidator, address borrower, uint256[] calldata seizeIds, uint256[] calldata seizeAmounts) external;
}
