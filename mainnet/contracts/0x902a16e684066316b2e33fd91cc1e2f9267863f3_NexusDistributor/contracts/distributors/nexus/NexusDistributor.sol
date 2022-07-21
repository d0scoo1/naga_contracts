/* Copyright (C) 2021 NexusMutual.io

  This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

  This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
    along with this program.  If not, see http://www.gnu.org/licenses/ */

pragma solidity ^0.7.4;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/SafeERC20Upgradeable.sol";

import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts/math/Math.sol";
import "./interfaces/IGateway.sol";
import "./interfaces/IPool.sol";
import "./interfaces/INXMaster.sol";
import "../../IDistributor.sol";
import "./interfaces/IQuotationData.sol";
import "../AbstractDistributor.sol";
import "./interfaces/IwnxmToken.sol";
import "./utils/NexusHelper.sol";
import "../../dependencies/interfaces/IUniswapV2Router02.sol";
import "../../helpers/interfaces/IExchangeAdapter.sol";
import "../../dependencies/token/IWETH.sol";

contract NexusDistributor is
    AbstractDistributor,
    ERC721Upgradeable,
    OwnableUpgradeable,
    ReentrancyGuardUpgradeable
{
    using SafeMathUpgradeable for uint256;
    using Math for uint256;

    string public constant DEFAULT_BASE_URI =
        "https://brightunion.io/documents/nfts/nexus/cover.png";
    // @dev DEPRECATED
    uint256 public feePercentage;
    bool public buysAllowed;
    /*
    address where `buyCover` distributor fees and `ethOut` from `sellNXM` are sent. Controlled by Owner.
  */
    address payable public treasury;

    /*
    NexusMutual contracts
  */
    IGateway public gateway;
    IERC20Upgradeable public nxmToken;
    IWETH public wEthToken;
    INXMaster public master;
    IWNXMToken public wnxmToken;
    address public exchangeAdapter;

    modifier onlyTokenApprovedOrOwner(uint256 tokenId) {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "NexusDistributor: Not approved or owner"
        );
        _;
    }

    /**
     * @dev Standard pattern of constructing proxy contracts with the same signature as the constructor.
     */
    function __NexusDistributor_init(
        address _gatewayAddress,
        address _nxmTokenAddress,
        address _masterAddress,
        address _wnxmTokenAddress,
        address _wETHAddress,
        address payable _treasury,
        string memory _tokenName,
        string memory _tokenSymbol,
        address _exchangeAdapterAddress
    ) public initializer {
        __Ownable_init();
        __ReentrancyGuard_init();
        __ERC721_init(_tokenName, _tokenSymbol);

        _setBaseURI(DEFAULT_BASE_URI);
        buysAllowed = true;
        treasury = _treasury;
        gateway = IGateway(_gatewayAddress);
        nxmToken = IERC20Upgradeable(_nxmTokenAddress);
        wEthToken = IWETH(_wETHAddress);
        wnxmToken = IWNXMToken(_wnxmTokenAddress);
        master = INXMaster(_masterAddress);
        exchangeAdapter = _exchangeAdapterAddress;
    }

    function getCover(
        address _owner,
        uint256 _coverId,
        bool _isActive,
        uint256 _loopLimit
    ) external view returns (NexusHelper.Cover memory _cover) {
        uint256 limit;
        uint256 arraySize;
        if (_isActive == true) {
            uint256[] memory userCovers = IQuotationData(
                master.getLatestAddress("QD")
            ).getAllCoversOfUser(_owner);
            limit = userCovers.length.min(_loopLimit);
            arraySize = userCovers.length;
        } else {
            uint256 ownerBalance = balanceOf(_owner);
            limit = ownerBalance.min(_loopLimit);
            arraySize = ownerBalance;
        }

        NexusHelper.Cover[] memory covers = new NexusHelper.Cover[](arraySize);
        for (uint256 i = 0; i < limit; i++) {
            uint256 tokenId = _isActive == true
                ? i
                : tokenOfOwnerByIndex(_owner, i);

            NexusHelper.Cover memory cover;

            (
                cover.status,
                cover.coverAmount,
                cover.productId,
                cover.expiration,
                cover.contractAddress,
                cover.currency,
                cover.premium,
                cover.refAddress
            ) = gateway.getCover(tokenId);

            covers[i] = cover;
        }
        return covers.length > 0 ? covers[_coverId] : _cover;
    }

    // @dev buy cover for a coverable identified by its contractAddress
    // @param contractAddress contract address of coverable
    // @param coverAsset asset of the premium and of the sum assured.
    // @param sumAssured amount payable if claim is submitted and considered valid
    // @param amountOut amount of expected wNXM out after swap
    // @param coverType cover type dermining how the data parameter is decoded
    // @param maxPriceWithFee max price (including fee) to be spent on the cover.
    // @param data abi-encoded field with additional cover data fields
    function buyCover(
        address contractAddress,
        address coverAsset,
        uint256 sumAssured,
        uint256 amountOut,
        uint16 coverPeriod,
        uint8 coverType,
        uint256 maxPriceWithFee,
        bytes calldata data
    ) external payable nonReentrant {
        require(buysAllowed, "NexusDistributor: buys not allowed");

        // Init buying asset token
        IERC20Upgradeable tokenAsset = IERC20Upgradeable(coverAsset);

        // Buy wNXM with Ether or ERC20 asset
        (uint256 wNXMAmount, uint256 coverPriceNXM) = _buyWNXM(
            tokenAsset,
            amountOut,
            maxPriceWithFee,
            data
        );

        // Unwrap wNXM
        wnxmToken.approve(address(this), wNXMAmount);
        wnxmToken.unwrap(wNXMAmount);
        require(
            nxmToken.balanceOf(address(this)) >= coverPriceNXM,
            "Distributor not enough NXM"
        );

        // approve gateway coverprice in NXM - this price is given by nexus quote API
        nxmToken.approve(address(gateway), coverPriceNXM);

        // Buy nexus cover with NXM
        // Balance of NXM after coverbuy is sent to treasury
        uint256 coverId = gateway.buyCover(
            contractAddress,
            address(nxmToken),
            sumAssured,
            coverPeriod,
            IGateway.CoverType(coverType),
            data
        );

        // mint token using the coverId as a tokenId (guaranteed unique)
        _mint(_msgSender(), coverId);

        if (nxmToken.balanceOf(address(this)) > 0) {
            // Returning remainder of NXM to treasury
            SafeERC20Upgradeable.safeTransfer(
                IERC20Upgradeable(address(nxmToken)),
                address(treasury),
                nxmToken.balanceOf(address(this))
            );
        }

        // Returning remainder of asset to treasury
        if (wEthToken.balanceOf(address(this)) > 0) {
            wEthToken.transfer(
                address(treasury),
                wEthToken.balanceOf(address(this))
            );
        } else if (tokenAsset.balanceOf(address(this)) > 0) {
            SafeERC20Upgradeable.safeTransfer(
                tokenAsset,
                address(treasury),
                tokenAsset.balanceOf(address(this))
            );
        }

        emit BuyCoverEvent(
            contractAddress,
            coverType,
            coverPeriod,
            coverAsset,
            sumAssured,
            maxPriceWithFee
        );
    }

    // @notice Internal logic to buy wNXM
    // @dev solves function stack limit of buyCover method
    // @param tokenAsset ERC20 paye to buy cover
    // @param amountOut uint256 expected amount out from SDK
    // @param maxPriceWithFee uint256 price with fee
    function _buyWNXM(
        IERC20Upgradeable tokenAsset,
        uint256 amountOut,
        uint256 maxPriceWithFee,
        bytes calldata data
    ) internal returns (uint256, uint256) {
        (
            uint256 coverPrice,
            uint256 _coverPriceNXM,
            address swapVia,
            uint24 poolFeeA,
            uint24 poolFeeB
        ) = abi.decode(data, (uint256, uint256, address, uint24, uint24));
        require(
            coverPrice <= maxPriceWithFee,
            "NexusDistributor: cover price with fee exceeds max"
        );
        uint256 _wNXMAmount;
        uint256 expectedAmountOut = amountOut; // Solves deep stack error on swap
        if (address(tokenAsset) == ETH) {
            require(
                msg.value >= coverPrice,
                "NexusDistributor: Insufficient ETH sent"
            );
            uint256 remainder = msg.value.sub(coverPrice);
            if (remainder > 0) {
                // solhint-disable-next-line avoid-low-level-calls
                (
                    bool ok, /* data */

                ) = address(_msgSender()).call{value: remainder}("");
                require(
                    ok,
                    "Distributor: Returning ETH remainder to sender failed."
                );
            }
            // Wrap ETH into WETH
            wEthToken.deposit{value: msg.value}();
            require(
                wEthToken.balanceOf(address(this)) >= coverPrice,
                "NexusDistr: Not enpugh wETH"
            );
            _wNXMAmount = IExchangeAdapter(exchangeAdapter).exactOutputSingle(
                address(wEthToken),
                address(wnxmToken),
                address(this),
                expectedAmountOut, // Expected wNXM out froim SDK
                coverPrice, // _amountInMaximum,
                poolFeeA
            );
        } else {
            require(
                tokenAsset.allowance(_msgSender(), address(this)) >= coverPrice,
                "NexusDistributor need cover price allowance"
            );
            SafeERC20Upgradeable.safeTransferFrom(
                tokenAsset,
                _msgSender(),
                address(this),
                coverPrice
            );
            SafeERC20Upgradeable.safeApprove(
                tokenAsset,
                address(exchangeAdapter),
                coverPrice
            );
            if (swapVia != address(0)) {
                // Using uniswap v3
                _wNXMAmount = IExchangeAdapter(exchangeAdapter).exactOutput(
                    address(tokenAsset),
                    swapVia,
                    address(wnxmToken),
                    address(this),
                    expectedAmountOut, // Expected wNXM out froim SDK
                    coverPrice, // _amountInMaximum,
                    poolFeeA,
                    poolFeeB
                );
            } else {
                _wNXMAmount = IExchangeAdapter(exchangeAdapter)
                    .exactOutputSingle(
                        address(tokenAsset),
                        address(wnxmToken),
                        address(this),
                        expectedAmountOut, // Expected wNXM out froim SDK
                        coverPrice, // _amountInMaximum,
                        poolFeeA
                    );
            }
        }
        return (_wNXMAmount, _coverPriceNXM);
    }

    // @notice Submit a claim for the cover
    // @param tokenId cover token id
    // @param data abi-encoded field with additional claim data fields
    function submitClaim(uint256 tokenId, bytes calldata data)
        external
        onlyTokenApprovedOrOwner(tokenId)
        returns (uint256)
    {
        // coverId = tokenId
        uint256 claimId = gateway.submitClaim(tokenId, data);
        emit NexusHelper.ClaimSubmitted(tokenId, claimId, _msgSender());
        return claimId;
    }

    // @notice Submit a claim for the cover
    // @param tokenId cover token id
    // @param incidentId id of the incident
    // @param coveredTokenAmount amount of yield tokens covered
    // @param coverAsset yield token that is covered
    function claimTokens(
        uint256 tokenId,
        uint256 incidentId,
        uint256 coveredTokenAmount,
        address coverAsset
    )
        external
        onlyTokenApprovedOrOwner(tokenId)
        returns (
            uint256 claimId,
            uint256 payoutAmount,
            address payoutToken
        )
    {
        SafeERC20Upgradeable.safeTransferFrom(
            IERC20Upgradeable(coverAsset),
            _msgSender(),
            address(this),
            coveredTokenAmount
        );
        SafeERC20Upgradeable.safeApprove(
            IERC20Upgradeable(coverAsset),
            address(gateway),
            coveredTokenAmount
        );
        // coverId = tokenId
        (claimId, payoutAmount, payoutToken) = gateway.claimTokens(
            tokenId,
            incidentId,
            coveredTokenAmount,
            coverAsset
        );
        _burn(tokenId);
        if (payoutToken == ETH) {
            (
                bool ok, /* data */

            ) = address(_msgSender()).call{value: payoutAmount}("");
            require(ok, "Distributor: ETH transfer to sender failed.");
        } else {
            SafeERC20Upgradeable.safeTransfer(
                IERC20Upgradeable(payoutToken),
                _msgSender(),
                payoutAmount
            );
        }
        emit NexusHelper.ClaimSubmitted(tokenId, claimId, _msgSender());
    }

    /**
     * @notice Redeem the claim to the cover. Requires that the payout is completed.
     * @param tokenId cover token id
     */
    function redeemClaim(uint256 tokenId, uint256 claimId)
        public
        onlyTokenApprovedOrOwner(tokenId)
        nonReentrant
    {
        require(
            gateway.getClaimCoverId(claimId) == tokenId,
            "Distributor: coverId claimId mismatch"
        );
        (
            IGateway.ClaimStatus status,
            uint256 amountPaid,
            address coverAsset
        ) = gateway.getPayoutOutcome(claimId);
        require(
            status == IGateway.ClaimStatus.ACCEPTED,
            "Distributor: Claim not accepted"
        );

        _burn(tokenId);
        if (coverAsset == ETH) {
            (
                bool ok, /* data */

            ) = _msgSender().call{value: amountPaid}("");
            require(ok, "Distributor: Transfer to NFT owner failed");
        } else {
            SafeERC20Upgradeable.safeTransfer(
                IERC20Upgradeable(coverAsset),
                _msgSender(),
                amountPaid
            );
        }

        emit NexusHelper.ClaimPayoutRedeemed(
            tokenId,
            claimId,
            _msgSender(),
            amountPaid,
            coverAsset
        );
    }

    /**
  * @notice Execute an action on specific cover token. The action is identified by an `action` id.
      Allows for an ETH transfer or an ERC20 transfer.
      If less than the supplied assetAmount is needed, it is returned to `_msgSender()`.
  * @dev The purpose of this function is future-proofing for updates to the cover buy->claim cycle.
  * @param tokenId id of the cover token
  * @param assetAmount optional asset amount to be transferred along with the action executed
  * @param asset optional asset to be transferred along with the action executed
  * @param action action identifier
  * @param data abi-encoded field with action parameters
  * @return response (abi-encoded response, amount withheld from the original asset amount supplied)
  */
    function executeCoverAction(
        uint256 tokenId,
        uint256 assetAmount,
        address asset,
        uint8 action,
        bytes calldata data
    )
        external
        payable
        onlyTokenApprovedOrOwner(tokenId)
        nonReentrant
        returns (bytes memory response, uint256 withheldAmount)
    {
        if (assetAmount == 0) {
            return gateway.executeCoverAction(tokenId, action, data);
        }
        if (asset == ETH) {
            require(
                msg.value >= assetAmount,
                "Distributor: Insufficient ETH sent"
            );
            (response, withheldAmount) = gateway.executeCoverAction{
                value: msg.value
            }(tokenId, action, data);
            uint256 ethRemainder = assetAmount.sub(withheldAmount);
            (
                bool ok, /* data */

            ) = address(_msgSender()).call{value: ethRemainder}("");
            require(
                ok,
                "Distributor: Returning ETH remainder to sender failed."
            );
            return (response, withheldAmount);
        }

        IERC20Upgradeable token = IERC20Upgradeable(asset);
        SafeERC20Upgradeable.safeTransferFrom(
            IERC20Upgradeable(asset),
            _msgSender(),
            address(this),
            assetAmount
        );
        SafeERC20Upgradeable.safeApprove(IERC20Upgradeable(asset), address(gateway), assetAmount);
        (response, withheldAmount) = gateway.executeCoverAction(
            tokenId,
            action,
            data
        );
        uint256 remainder = assetAmount.sub(withheldAmount);

        SafeERC20Upgradeable.safeTransfer(IERC20Upgradeable(asset), _msgSender(), remainder);
        return (response, withheldAmount);
    }

    /**
     * @notice Switch NexusMutual membership to `newAddress`.
     * @param newAddress address
     */
    function switchMembership(address newAddress) external onlyOwner {
        nxmToken.approve(address(gateway), uint256(-1));
        gateway.switchMembership(newAddress);
    }

    /**
     * @notice Set if buyCover calls are allowed (true) or not (false).
     * @param _buysAllowed value set for buysAllowed
     */
    function setBuysAllowed(bool _buysAllowed) external onlyOwner {
        buysAllowed = _buysAllowed;
    }

    /**
     * @notice Set treasury address where `buyCover` distributor fees and `ethOut` from `sellNXM` are sent.
     *
     * @param _treasury new treasury address
     */
    function setTreasuryDetails(address payable _treasury) external onlyOwner {
        treasury = _treasury;
    }

    /**
     * @dev required to be allow for receiving ETH claim payouts
     */
    receive() external payable {}

    /**
     * @dev Function to set the base URI for all token IDs. It is
     * automatically added as a prefix to the value returned in {tokenURI},
     * or to the token ID if {tokenURI} is empty.
     */
    function setBaseURI(string memory baseURI_) public onlyOwner {
        _setBaseURI(baseURI_);
    }
}
