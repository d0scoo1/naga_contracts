// SPDX-License-Identifier: LGPL-3.0-only
// Created By: Art Blocks Inc.

import "../interfaces/0.8.x/IArtblocksRoyaltyOverride.sol";
import "../interfaces/0.8.x/IGenArt721CoreV2_PBAB.sol";

import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

pragma solidity 0.8.9;

/**
 * @title Royalty Registry override for Art Blocks PBAB token contracts.
 * @author Art Blocks Inc.
 */
contract GenArt721RoyaltyOverride_PBAB is ERC165, IArtblocksRoyaltyOverride {
    /**
     * @notice Platform royalty payment address for `contractAddress`
     * updated to be `platformRoyaltyAddress`.
     */
    event PlatformRoyaltyAddressForContractUpdated(
        address indexed contractAddress,
        address payable indexed platformRoyaltyAddress
    );

    /**
     * @notice Render provider royalty payment basis points for `tokenAddress`
     * updated to be `bps` if `useOverride`, else updated to use default BPS.
     */
    event RenderProviderBpsForContractUpdated(
        address indexed tokenAddress,
        bool indexed useOverride,
        uint256 bps
    );

    /**
     * @notice Platform royalty payment basis points for
     * `tokenAddress` updated to be `bps` if `useOverride`, else
     * updated to use default BPS.
     */
    event PlatformBpsForContractUpdated(
        address indexed tokenAddress,
        bool indexed useOverride,
        uint256 bps
    );

    /// token contract => Platform royalty payment address
    mapping(address => address payable)
        public tokenAddressToPlatformRoyaltyAddress;

    struct BpsOverride {
        bool useOverride;
        uint256 bps;
    }

    /// Default Render Provider royalty basis points if no BPS override is set.
    uint256 public constant RENDER_PROVIDER_DEFAULT_BPS = 250; // 2.5 percent
    /// Default Platform royalty basis points if no BPS override is set.
    uint256 public constant PLATFORM_DEFAULT_BPS = 250; // 2.5 percent
    /// token contract => if render provider bps override is set, and bps value.
    mapping(address => BpsOverride)
        public tokenAddressToRenderProviderBpsOverride;
    /// token contract => if Platform bps override is set, and bps value.
    mapping(address => BpsOverride) public tokenAddressToPlatformBpsOverride;

    modifier onlyAdminOnContract(address _tokenContract) {
        require(
            IGenArt721CoreV2_PBAB(_tokenContract).admin() == msg.sender,
            "Only core admin for specified token contract"
        );
        _;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC165, IERC165)
        returns (bool)
    {
        return
            // register interface 0x9ca7dc7a - getRoyalties(address,uint256)
            interfaceId == type(IArtblocksRoyaltyOverride).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @notice Updates platform royalty payment address for `_tokenContract`
     * to be `_platformRoyaltyAddress`.
     * @param _tokenContract Token contract to be updated.
     * @param _platformRoyaltyAddress Address to receive royalty payments.
     */
    function updatePlatformRoyaltyAddressForContract(
        address _tokenContract,
        address payable _platformRoyaltyAddress
    ) external onlyAdminOnContract(_tokenContract) {
        tokenAddressToPlatformRoyaltyAddress[
            _tokenContract
        ] = _platformRoyaltyAddress;
        emit PlatformRoyaltyAddressForContractUpdated(
            _tokenContract,
            _platformRoyaltyAddress
        );
    }

    /**
     * @notice Updates render provider royalty payment BPS for `_tokenContract`
     * to be `_bps`.
     * @param _tokenContract Token contract to be updated.
     * @param _bps Render provider royalty payment basis points.
     */
    function updateRenderProviderBpsForContract(
        address _tokenContract,
        uint256 _bps
    ) external onlyAdminOnContract(_tokenContract) {
        require(_bps <= 10000, "invalid bps");
        tokenAddressToRenderProviderBpsOverride[_tokenContract] = BpsOverride(
            true,
            _bps
        );
        emit RenderProviderBpsForContractUpdated(_tokenContract, true, _bps);
    }

    /**
     * @notice Updates platform royalty payment BPS for `_tokenContract` to be
     * `_bps`.
     * @param _tokenContract Token contract to be updated.
     * @param _bps Platform royalty payment basis points.
     */
    function updatePlatformBpsForContract(address _tokenContract, uint256 _bps)
        external
        onlyAdminOnContract(_tokenContract)
    {
        require(_bps <= 10000, "invalid bps");
        tokenAddressToPlatformBpsOverride[_tokenContract] = BpsOverride(
            true,
            _bps
        );
        emit PlatformBpsForContractUpdated(_tokenContract, true, _bps);
    }

    /**
     * @notice Clears any overrides of render provider royalty payment BPS
     * for `_tokenContract`.
     * @param _tokenContract Token contract to be cleared.
     * @dev token contracts without overrides use default BPS value.
     */
    function clearRenderProviderBpsForContract(address _tokenContract)
        external
        onlyAdminOnContract(_tokenContract)
    {
        tokenAddressToRenderProviderBpsOverride[_tokenContract] = BpsOverride(
            false,
            0
        ); // initial values
        emit RenderProviderBpsForContractUpdated(_tokenContract, false, 0);
    }

    /**
     * @notice Clears any overrides of platform provider royalty payment BPS
     * for `_tokenContract`.
     * @param _tokenContract Token contract to be cleared.
     * @dev token contracts without overrides use default BPS value.
     */
    function clearPlatformBpsForContract(address _tokenContract)
        external
        onlyAdminOnContract(_tokenContract)
    {
        tokenAddressToPlatformBpsOverride[_tokenContract] = BpsOverride(
            false,
            0
        ); // initial values
        emit PlatformBpsForContractUpdated(_tokenContract, false, 0);
    }

    /**
     * @notice Gets royalites of token ID `_tokenId` on token contract
     * `_tokenAddress`.
     * @param _tokenAddress Token contract to be queried.
     * @param _tokenId Token ID to be queried.
     * @return recipients_ array of royalty recipients
     * @return bps array of basis points for each recipient, aligned by index
     */
    function getRoyalties(address _tokenAddress, uint256 _tokenId)
        external
        view
        returns (address payable[] memory recipients_, uint256[] memory bps)
    {
        recipients_ = new address payable[](4);
        bps = new uint256[](4);
        // get standard royalty data for artist and additional payee
        (
            address artistAddress,
            address additionalPayee,
            uint256 additionalPayeePercentage,
            uint256 royaltyFeeByID
        ) = IGenArt721CoreV2_PBAB(_tokenAddress).getRoyaltyData(_tokenId);
        // translate to desired output
        recipients_[0] = payable(artistAddress);
        bps[0] = (uint256(100) - additionalPayeePercentage) * royaltyFeeByID;
        recipients_[1] = payable(additionalPayee);
        bps[1] = additionalPayeePercentage * royaltyFeeByID;
        // append platform provider royalty
        require(
            tokenAddressToPlatformRoyaltyAddress[_tokenAddress] != address(0),
            "Platform royalty address must be defined for contract"
        );
        recipients_[2] = tokenAddressToPlatformRoyaltyAddress[_tokenAddress];
        bps[2] = tokenAddressToPlatformBpsOverride[_tokenAddress].useOverride
            ? tokenAddressToPlatformBpsOverride[_tokenAddress].bps
            : PLATFORM_DEFAULT_BPS;
        // append render provider royalty
        recipients_[3] = payable(
            IGenArt721CoreV2_PBAB(_tokenAddress).renderProviderAddress()
        );
        bps[3] = tokenAddressToRenderProviderBpsOverride[_tokenAddress]
            .useOverride
            ? tokenAddressToRenderProviderBpsOverride[_tokenAddress].bps
            : RENDER_PROVIDER_DEFAULT_BPS;
        return (recipients_, bps);
    }
}
