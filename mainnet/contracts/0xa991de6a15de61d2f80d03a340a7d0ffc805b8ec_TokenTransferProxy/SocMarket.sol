// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import {Ownable} from "./Ownable.sol";
import {IERC20, SafeERC20} from "./SafeERC20.sol";
import {IERC721} from "./IERC721.sol";
import {SignatureChecker} from "./SignatureChecker.sol";

interface TokenTransferManager {
    function transferERC721Token(address collection, address from, address to,uint256 tokenId) external;
    function transferERC20Tokens(address token, address from, address to, uint amount ) external;
}

contract SocMarket  is Ownable{
    using SafeERC20 for IERC20;

    // keccak256("SellOrder(uint8 saleKind,address maker,address collection,uint256 tokenId,address fToken,uint256 price,uint256 nonce,uint256 startTime,uint256 endTime)")
    bytes32 internal constant SELL_ORDER_HASH = 0x179868c752420cd3366071e2bfc82d70428afb225a818c94ae9a2acbb53c6a30;

    struct SellOrder {
        uint8 saleKind; // 0: FungibleToken , 1: NonFungibleToken
        address maker; // maker of the sell order
        address collection; // collection address
        uint256 tokenId; // id of the token
        address fToken; // FungibleToke address, 0x : ETH
        uint256 price; // price (used as )
        uint256 nonce; // order nonce (must be unique unless new maker order is meant to override existing one e.g., lower ask price)
        uint256 startTime; // startTime in timestamp
        uint256 endTime; // endTime in timestamp
    }

    struct BuyOrder {
        uint8 saleKind; // 0: FungibleToken , 1: NonFungibleToken
        address maker; // maker of the buy order
        address collection; // collection address
        uint256 tokenId; // id of the token
        address fToken; // FungibleToke address, 0x : ETH
        uint256 price; // price (used as )
    }

    struct Sig {
        uint8 v; // v: parameter (27 or 28)
        bytes32 r; // r: parameter
        bytes32 s; // s: parameter
    }

    uint256 public maxFee = 10000; // 100%
    uint256 public protocolFee = 500; //2.5%

    mapping(address => uint256) public vipBalance;
    mapping(address => uint256) public addressMinNonce;
    /* Cancelled / finalized orders, by hash. */
    mapping(bytes32 => bool) internal cancelledOrFinalized;

    bytes32 public DOMAIN_SEPARATOR;
    address public protocolFeeRecipient;
    address public tokenTransferProxy;

    event OrderCancelled          (bytes32 indexed hash);

    /**
    * @notice Constructor
    * @param _protocolFeeRecipient protocol fee recipient
    */
    constructor(
        address _protocolFeeRecipient,
        address _tokenTransferProxy
    ) {
        // Calculate the domain separator
        //0xc778417e063141139fce010982780140aa0cd5ab, 0x30e3178f621f552707F5419569360ef17C39Af69
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f, // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
                0x1c1b2235c991f3ce05809fcc1344ce9a62eed16b1318e97cbc80edf4de923088, // keccak256("SocMarket")
                0x4e03657aea45a94fc7d47ba826c8d667c0d1e6e33a64a036ec44f58fa12d6c45, // keccak256(bytes("1")) for versionId = 1
                block.chainid,
                address(this)
            )
        );

        protocolFeeRecipient = _protocolFeeRecipient;
        tokenTransferProxy = _tokenTransferProxy;
    }

    //sell nft or other token.
    function hash(SellOrder memory order) internal pure returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    SELL_ORDER_HASH,
                    order.saleKind,
                    order.maker,
                    order.collection,
                    order.tokenId,
                    order.fToken,
                    order.price,
                    order.nonce,
                    order.startTime,
                    order.endTime
                )
            );
    }

    function updateProtocolFeeRecipient(address _protocolFeeRecipient) public onlyOwner{
        require(_protocolFeeRecipient != address(0), "SocMarket: Invalid recipient.");
        protocolFeeRecipient = _protocolFeeRecipient;
    }

    function updateTokenTransferProxy(address _tokenTransferProxy) public onlyOwner{
        require(_tokenTransferProxy != address(0), "SocMarket: Invalid proxy.");
        tokenTransferProxy = _tokenTransferProxy;
    }

    function updateAddressMinNonce(uint256 nonce) public {
        require(addressMinNonce[msg.sender] < nonce, "SocMarket: nonce too small");
        addressMinNonce[msg.sender] = nonce;
    }

    /**
    * @notice Verify the validity of the maker order
    * @param sell maker order
    * @param orderHash computed hash for the order
    */
    function _validateOrder(
        SellOrder memory sell,
        bytes32 orderHash,
        Sig memory sig
    ) internal view {
        /* Order must have not been canceled or already filled. */
        require(
            cancelledOrFinalized[orderHash] != true,
            "Order: order was cancelled or finalized."
        );

        // Verify the maker is not address(0)
        require(sell.maker != address(0), "Order: Invalid signer");

        // Verify whether order nonce has expired
        require(
            sell.nonce >= addressMinNonce[sell.maker],
            "Order: Matching order expired"
        );


        // Verify the validity of the signature
        require(SignatureChecker.verify(
                orderHash,
                sell.maker,
                sig.v,
                sig.r,
                sig.s,
                DOMAIN_SEPARATOR
            ),
            "Order: Invalid signer");

    }

    /**
    * @notice Transfer ERC721 token
    * @param collection address of the collection
    * @param from address of the sender
    * @param to address of the recipient
    * @param tokenId tokenId
    * @dev For ERC721, amount is not used
    */
    function transferERC721Token(
        address collection,
        address from,
        address to,
        uint256 tokenId
    ) internal {
        require(from != address(0), "SocMarket: Invalid from");
        require(to != address(0), "SocMarket: Invalid to");

        TokenTransferManager(tokenTransferProxy).transferERC721Token(collection, from, to, tokenId);
    }

    /**
    * @dev Transfer tokens
    * @param token Token to transfer
    * @param from Address to charge fees
    * @param to Address to receive fees
    * @param amount Amount of protocol tokens to charge
    */
    function transferERC20Tokens(
        address token,
        address from,
        address to,
        uint amount
    ) internal {
        require(from != address(0), "SocMarket: Invalid from");
        require(to != address(0), "SocMarket: Invalid to");
        if (from == address(this)){
            IERC20(token).transfer(to, amount);
        }else {
            TokenTransferManager(tokenTransferProxy).transferERC20Tokens(token, from, to, amount);
        }
    }

    /**
    * @notice Check whether a taker bid order can be executed against a maker ask
    * @param buy taker bid order
    * @param sell maker ask order
    */
    function _orderMatch(
        BuyOrder memory buy,
        SellOrder memory sell
    ) internal view {
        require(
            ((sell.fToken == buy.fToken) &&
                (sell.price == buy.price) &&
                (sell.collection == buy.collection) &&
                (sell.tokenId == buy.tokenId) &&
                (sell.saleKind != buy.saleKind) &&
                (sell.startTime <= block.timestamp) &&
                (sell.endTime >= block.timestamp)
            ), "SocMarket: buy and sell does not match."
        );
    }

    /**
    * Call atomicMatch_ to exchange NFT with Token
    */
    function atomicMatch_(
        address[6] memory addrs,
        uint8[2] memory saleKinds,
        uint256[4] memory tokenAndPrice,
        uint256[3] memory nonceAndTimes,
        uint8 v,
        bytes32[2] memory rss
    ) public {
        require(msg.sender == addrs[3], "SocMarket: buy.maker not equal to msg.sender");
        return atomicMatch(
            //kind, maker,collection,tokenid,ftoken,price,nonce, startTime,endTime
            SellOrder(saleKinds[0],addrs[0],addrs[1],tokenAndPrice[0],addrs[2],tokenAndPrice[1],nonceAndTimes[0],nonceAndTimes[1],nonceAndTimes[2]),
            // v, r, s
            Sig(v, rss[0], rss[1]),
            //kind, maker,collection,tokenid,ftoken,price
            BuyOrder(saleKinds[1],addrs[3],addrs[4],tokenAndPrice[2],addrs[5],tokenAndPrice[3])
        );
    }

    //msg.sender always equals to buy.taker
    function atomicMatch(
        SellOrder memory sell,
        Sig memory sellSig,
        BuyOrder memory buy
    ) internal {
        require(
            //Only ERC20 token
            (msg.value == 0 && sell.fToken != address(0)),
            "Order: Invalid msg.value or token Type."
        );

        bytes32 _orderHash = hash(sell);
        _orderMatch(buy, sell);
        _validateOrder(sell, _orderHash, sellSig);

        //default sellOrder maker is NFT owner
        address nftOwner = sell.maker;
        address ftOwner = buy.maker;

        //sellOrder maker is FungibleToken owner
        if(sell.saleKind == 0 && buy.saleKind == 1){
            nftOwner = buy.maker;
            ftOwner = sell.maker;
        }

        uint256 protocolFeeAmount = sell.price * protocolFee / maxFee;
        uint256 sellAmount = sell.price  - protocolFeeAmount;

        // PART1.2.2: Transfer ERC20 Token
        if(sell.fToken != address(0)){
            //Transfer sellAmount to nftOwner
            transferERC20Tokens(sell.fToken, ftOwner ,nftOwner, sellAmount);

            //Transfer protocol FEE
            transferERC20Tokens(sell.fToken, ftOwner, protocolFeeRecipient, protocolFeeAmount);

            // PART2: Transfer NFT
            transferERC721Token(sell.collection, nftOwner, ftOwner, sell.tokenId);
        }

        cancelledOrFinalized[_orderHash] = true;
    }

    function cancelOrder_(
        uint8 saleKind,
        address maker,
        address collection,
        uint256 tokenId,
        address ftoken,
        uint256 price,
        uint256 nonce,
        uint256 startTime,
        uint256 endTime
    ) public {
        cancelOrder(SellOrder(saleKind,maker,collection,tokenId,ftoken,price,nonce, startTime,endTime));
    }

    function cancelOrder(SellOrder memory order)
        internal
    {
        /* Assert sender is authorized to cancel order. */
        require(msg.sender == order.maker);

        /* Calculate order hash. */
        bytes32 _orderHash = hash(order);

        /* Mark order as cancelled, preventing it from being matched. */
        cancelledOrFinalized[_orderHash] = true;

        /* Log cancel event. */
        emit OrderCancelled(_orderHash);
    }
}



