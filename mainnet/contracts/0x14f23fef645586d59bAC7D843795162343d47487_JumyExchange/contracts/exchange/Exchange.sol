pragma solidity 0.8.12;

// __/~~~~\_/~~\__/~~\_/~~\__/~~\_/~~\__/~~\_/~~\__/~~\_\__/~~\~
// ___/~~\__/~~\__/~~\_/~~~\/~~~\__/~~\/~~\__/~~\__/~~\_\__/~~\~
// ___/~~\__/~~\__/~~\_/~~~~~~~~\___/~~~~\___/~~\__/~~\_/~~\__/~
// ___/~~\__/~~\__/~~\_/~~\__/~~\____/~~\____/~~\__/~~\_/~~\__/~
// /~~~~\____/~~~~~~\__/~~\__/~~\____/~~\____/~~\__/~~\_/~~\__/~
// /~~\__/~░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░/~~\__/~~\_
// /~~\__/~░░░░░░░░██╗██╗░░░██╗███╗░░░███╗██╗░░░██╗░░░░░/~~\__/~
// /~~\__/~░░░░░░░░██║██║░░░██║████╗░████║╚██╗░██╔╝░░░░/~~\__/~~
// ___/~~\~░░░░░░░░██║██║░░░██║██╔████╔██║░╚████╔╝░░░░░░░/~~\__/
// ___/~~\~░░░██╗░░██║██║░░░██║██║╚██╔╝██║░░╚██╔╝░░░░░░░░░░/~~\_
// ___/~~\~░░░██╗░░██░╚██████╔╝██║░╚═╝░██║░░░██║░░░░░░░░░/~~\__/
// ___/~~\~░░░██╗░░██░░╚═════╝░╚═╝░░░░░╚═╝░░░██║░░░░░░/~~\__/~~\
// /\__/~\~░░░╚█████╝░░░░░░░░░░░░░░░░░░░░░░░░██║░░░░░░░░░░░/~~\_
// \_/~\~/~░░░░╚════╝░░░░░░░░░░░░░░░░░░░░╚═════╝░░░░░░░░/~~\__/~
// /\_/~\_~░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░/~~\__/
// __/~~~~\_/~~\__/~~\_/~~\__/~~\_/~~\__/~~\_/~~\__/~~\_~\__/~\~
// ___/~~\__/~~\__/~~\_/~~~\/~~~\__/~~\/~~\__/~~\__/~~\_~\__/~\~
// ___/~~\__/~~\__/~~\_/~~~~~~~~\___/~~~~\___/~~\__/~~\_/~~\__/\
// ___/~~\__/~~\__/~~\_/~~\__/~~\____/~~\____/~~\__/~~\_/~~\_/~\
// /~~~~\____/~~~~~~\__/~~\__/~~\____/~~\____/~~\__/~~\_\__/~\~/
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IWETH} from "./interfaces/IWETH.sol";
import {ExchangeCore} from "./core/ExchangeCore.sol";
import {ExchangeManager} from "./core/ExchangeManager.sol";
import {ERC721FixedPrice} from "./ERC721/FixedPrice.sol";
import {ReserveAuction} from "./ERC721/ReserveAuction.sol";
import {ERC1155FixedPrice} from "./ERC1155/FixedPrice.sol";

/**
 * @title JumyExchange
 * @notice The entry contract
 * @author <Abderrahmen Hanafi> uranium93
 * @notice ExchangeCore core functionality needed by other contracts
 * @notice ExchangeManager manage and control the exchange feature
 * @notice ERC721FixedPrice ERC721 collections list/purchase/remove/offer
 * @notice ReserveAuction ERC721 reserve auction create/remove/bid/claim
 * @notice ERC1155FixedPrice ERC1155 collections list/purchase/remove/offer
 * @notice RoyaltyFeeManager get collections royalty details custom/admin/owner/EIP2981 (Inspired from LookRare)
 * @notice CollectionRegistry register jumy creator collections to be whitelisted automatically
 * @notice Rewards jumy reward token logic
 */
contract JumyExchange is
    ExchangeCore,
    ExchangeManager,
    ERC721FixedPrice,
    ReserveAuction,
    ERC1155FixedPrice
{
    constructor(
        address weth,
        address jumyNftCollection,
        address royaltyManagerContract,
        address collectionRegistryContract,
        address protocolFeesRecipientWallet
    )
        ExchangeCore(
            weth,
            jumyNftCollection,
            royaltyManagerContract,
            collectionRegistryContract,
            protocolFeesRecipientWallet
        )
    {}

    receive() external payable {}
}
