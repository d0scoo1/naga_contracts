// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

//   ____  _  _  ____    ____   __    ___  __  ____  ____  _  _
//  (_  _)/ )( \(  __)  / ___) /  \  / __)(  )(  __)(_  _)( \/ )
//    )(  ) __ ( ) _)   \___ \(  O )( (__  )(  ) _)   )(   )  /
//   (__) \_)(_/(____)  (____/ \__/  \___)(__)(____) (__) (__/
//

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/interfaces/IERC721Receiver.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Society membership is captured in this contract.
//
// It is an NFT (ERC721) with a few custom enhancements:
//
//  1. Captcha Scheme
//      We use a captcha scheme to prevent bots from minting.
//        #isProbablyHuman() - matches a captcha signature signed elsewhere
//
//  2. Money-back Warranty
//      We promise your money back if we don't get enough members:
//               #withdraw()  - locks the money unless there are >=2000 members
//             #refundFull(), - these return your money during refunding
//          #refundKeepArt()    and they're enabled automatically after time has elapsed
//
//      (see "Refund Warranty Process" below for more details)
//
//  3. Minting Limits
//      A single wallet may only mint 2 memberships.
//
//  4. Founding Team
//      During contract construction, we mint 7 memberships,
//      one for each member of the founding team and the first artist.
//
//  5. Member Migration
//      This contract is an improved edition of an earlier membership contract.
//      Early token holders can migrate into this and receive an additional token
//      for their continued loyalty.
//
//  6. Gold/Standard Tokens
//      The first 2,000 memberships will get a Gold token, these are
//      identified by having an ID number 1-2000.
//
//  7. Limited Sales Window
//      After the Feb. 18 sales deadline one of two things will happen:
//        - if there are <2,000 members, then refunds are enabled and the society winds down.
//        - if there are 2,000+ members, then membership is capped to the number already sold.
//
//  Refund Warranty Process
//
//  If 2,000+ memberships are sold by Feb 18 there are no refunds.
//  But if less than 2,000 are sold by Feb 18, then the refund
//  implementation operates within three phases:
//
//   Phase 1: Jan 18 - Feb 18
//     After contract creation, until the sales deadline or >2,000 sold,
//     all minting fees remain locked in the contract.
//       - The Society's #withdraw() is disabled
//       - Member's #refund...() are also disabled
//
//   Phase 2: Feb 18 - Mar 18
//     After the sales deadline (if <2,000 sold), until the refund deadline,
//     Members may claim a #refund...() for the sale price.
//       - The Society's #withdraw() is still disabled
//       - Member's #refund...() are now enabled
//
//   Phase 3: after Mar 18
//     After the refund deadline, Members can no longer claim a #refund...()
//     and The Society can #withdraw() any unrefunded fees.
//       - The Society's #withdraw() is enabled
//       - Member's #refund...() are disabled

contract SocietyMember is
    ERC721,
    IERC2981,
    IERC721Receiver,
    Ownable,
    ReentrancyGuard
{
    using ECDSA for bytes32;

    // This indicates what mode this contract is operating in.
    // See #updateMode() for implementation
    enum Mode {
        // Happy path:
        SellingPreThreshold, // before sales deadline < 2,000 sold
        SellingPostThreshold, // > 2,000 sold, < 5,000 sold
        SoldOut, // 5,000 sold (or 2,000+ sold after sales deadline)
        // Sad path:
        Refunding, // < 2,000 sold, after sales deadline before refund deadline
        ClosingAfterRefundPeriod // < 2,000 sold, after refund deadline
    }

    // This is the sale price of each membership.
    uint256 public constant SALE_PRICE = 0.15 ether;
    // This is the price of individual pieces of art.
    // NOTE: we only use this if people opt for partial refund.
    uint256 public constant ART_PRICE = 0.1 ether;

    // A single wallet may only mint 2 memberships.
    uint256 public constant MINTS_PER_WALLET = 2;

    // There can be only 5,000 members (2,000 gold).
    // However many memberships have been sold at the sales deadline,
    // that number becomes the new maximum total member count.
    uint256 public MAXIMUM_TOTAL_MEMBER_COUNT;
    uint256 public immutable MAXIMUM_GOLD_MEMBER_COUNT;

    // When members rollover a token from the original membership contract
    // they will receive 3 memberships. They receive 2 memberships immediately
    // and then receive a 3rd when the sales threshold is reached.
    // For each membership token, members also receives a piece of artwork.
    // This records where to send the token post-threshold.
    mapping(uint16 => address) private pendingTransfers;
    // Emitted when `tokenId` token is minted and pending transfer to `to`.
    event PendingTransfer(address indexed to, uint256 indexed tokenId);
    // This records the migrated token so the old refund can be claimed.
    mapping(uint16 => uint16) private pendingRefundTokens;
    // The old member contract is used to verify migration.
    IOldMember private oldMemberK;

    // There need to be 2,000 members to proceed.
    // NOTE: permanently fixed upon contract creation
    uint256 public immutable ENOUGH_MEMBERS_TO_PROCEED;

    // Sales must exceed 2,000 members for the Society to proceed.
    // If we fail to get 2,000 members then the first #refund() request
    // after this time will start refunding.
    //   See note re "Refund Warrant Process" for more details.
    // NOTE: permanently fixed upon contract creation
    uint256 public immutable SALES_DEADLINE; // timestamp in seconds

    // If we fail to get 2,000 members then Members have until
    // this time to claim their #refund()
    //   See note re "Refund Warrant Process" for more details.
    // NOTE: permanently fixed upon contract creation
    uint256 public immutable REFUND_DEADLINE; // timestamp in seconds

    // During contract construction, we mint 7 tokens,
    // one for each member of the founding team and the first artist.
    // NOTE: permanently fixed upon contract creation
    uint256 private immutable FOUNDING_TEAM_COUNT;

    // This indicates the current mode (selling, refunding etc)
    Mode public mode;

    // We generate the next token ID by incrementing these counters.
    // Gold tokens have an ID <= 2,000.
    uint16 private goldIds; // 1 - 2000
    uint16 private standardIds; // 2001 - 5000

    // This tracks mint counts to help limit mints per wallet.
    mapping(address => uint8) private mintCountsByAddress;

    // This tracks gold token count per owner.
    mapping(address => uint16) private goldBalances;

    // Minting membership includes an item from the initial art collection.
    IInitialArtSale private artSale;

    // This contains the base URI (e.g. "https://example.com/tokens/")
    // that is used to produce a URI for the metadata about
    // each token (e.g. "https://example.com/tokens/1234")
    string private baseURI;

    // For exchanges that support ERC2981, this sets our royalty rate.
    // NOTE: whereas "percent" is /100, this uses "per mille" which is /1000
    uint256 private royaltyPerMille;

    // To combat bots, minting requests include a captcha signed elsewhere.
    // To verify the captcha, we compare its signature with this signer.
    address private captchaSigner;

    // To enable gas-free listings on OpenSea we integrate with the proxy registry.
    address private openSeaProxyRegistry;
    // The Society can disable gas-free listings in case OpenSea is compromised.
    bool private isOpenSeaProxyEnabled = true;

    struct Config {
        address[] foundingTeam;
        uint256 maximumTotalMemberCount;
        uint256 maximumGoldMemberCount;
        uint256 enoughMembersToProceed;
        uint256 salesDeadline;
        uint256 refundDeadline;
        uint256 royaltyPerMille;
        address captchaSigner;
        address openSeaProxyRegistry;
        IOldMember oldMemberK;
    }

    constructor(Config memory config) ERC721("Collector", "COLLECTOR") {
        require(
            config.enoughMembersToProceed <= config.maximumTotalMemberCount
        );
        require(
            config.maximumGoldMemberCount <= config.maximumTotalMemberCount
        );
        require(config.salesDeadline <= config.refundDeadline);

        MAXIMUM_TOTAL_MEMBER_COUNT = config.maximumTotalMemberCount;
        MAXIMUM_GOLD_MEMBER_COUNT = config.maximumGoldMemberCount;
        ENOUGH_MEMBERS_TO_PROCEED = config.enoughMembersToProceed;
        SALES_DEADLINE = config.salesDeadline;
        REFUND_DEADLINE = config.refundDeadline;
        royaltyPerMille = config.royaltyPerMille;
        captchaSigner = config.captchaSigner;
        openSeaProxyRegistry = config.openSeaProxyRegistry;
        oldMemberK = config.oldMemberK;
        mode = Mode.SellingPreThreshold;

        // Grant the founding team the first 7 tokens.
        FOUNDING_TEAM_COUNT = config.foundingTeam.length;
        for (uint256 i = 0; i < config.foundingTeam.length; i++) {
            _mint(config.foundingTeam[i], generateTokenId());
            // NOTE: the accompanying art is minted later when we #setInitialArtSale().
        }
    }

    //
    // Public Read Methods
    //

    // See how many memberships have been minted by the specified wallet.
    // NOTE: this is not the same as ownership
    function getMintCountByAddress(address minter_)
        external
        view
        returns (uint8)
    {
        return mintCountsByAddress[minter_];
    }

    // How many gold tokens have been issued.
    function goldSupply() external view returns (uint256) {
        return goldIds;
    }

    // Returns the number of gold tokens held by `owner`.
    function goldBalanceOf(address owner) external view returns (uint256) {
        return goldBalances[owner];
    }

    //
    // Public Write Methods
    //

    // This mints membership tokens to the sender.
    // Each token also includes a mint of artwork from the current collection.
    // It requires a `captcha` which is used to verify that
    // the sender is probably human and came here via our web flow.
    function mint(bytes memory captcha, uint8 numberOfTokens)
        external
        payable
        nonReentrant
    {
        require(numberOfTokens > 0, "missing number of tokens to mint");
        updateMode();
        require(
            mode == Mode.SellingPreThreshold ||
                mode == Mode.SellingPostThreshold,
            "minting is not available"
        );
        require(
            memberCount() + numberOfTokens <= MAXIMUM_TOTAL_MEMBER_COUNT,
            "not enough memberships remaining"
        );
        require(
            msg.value == SALE_PRICE * numberOfTokens,
            "incorrect ETH payment amount"
        );
        require(isProbablyHuman(captcha, msg.sender), "you seem like a robot");
        uint8 mintCount = mintCountsByAddress[msg.sender];
        require(
            mintCount + numberOfTokens <= MINTS_PER_WALLET,
            "you can only mint two memberships per wallet"
        );

        mintCountsByAddress[msg.sender] = mintCount + numberOfTokens;

        for (uint256 i = 0; i < numberOfTokens; i++) {
            mintWithArt(msg.sender, generateTokenId());
        }
    }

    // This mints 3 memberships for the user when they migrate the old token.
    // The first 2 memberships are transferred immediately along with 2 art pieces.
    // The 3rd token is marked as pending until reaching the sales threshold.
    function migrateMint(uint256[] memory oldTokenIds) external nonReentrant {
        updateMode();
        require(
            mode == Mode.SellingPreThreshold ||
                mode == Mode.SellingPostThreshold,
            "minting is not available"
        );
        require(
            memberCount() + 3 * oldTokenIds.length <=
                MAXIMUM_TOTAL_MEMBER_COUNT,
            "not enough memberships remaining"
        );
        require(oldTokenIds.length < 4, "migrating too many in a single call");
        for (uint256 i = 0; i < oldTokenIds.length; i++) {
            uint256 oldTokenId = oldTokenIds[i];
            require(
                oldTokenId > FOUNDING_TEAM_COUNT,
                "founding team tokens cannot migrate"
            );

            // The first 2 tokens transfer immediately.
            oldMemberK.transferFrom(msg.sender, address(this), oldTokenId);
            mintFromOldWithArt(oldTokenId, msg.sender, generateTokenId());
            mintFromOldWithArt(oldTokenId, msg.sender, generateTokenId());

            // And we mint the 3rd token and record where it should eventually go.
            // It is transferred upon reaching the sales threshold. See #claimPending()
            uint256 pendingTokenId = generateTokenId();
            _mint(address(this), pendingTokenId);
            pendingTransfers[uint16(pendingTokenId)] = msg.sender;
            emit PendingTransfer(msg.sender, pendingTokenId);
        }
    }

    // After reaching the sales threshold, this transfers the
    // pending 3rd token for migrated members.
    function claimPending(uint256[] memory tokenIds) external nonReentrant {
        updateMode();
        require(
            mode == Mode.SellingPostThreshold || mode == Mode.SoldOut,
            "token remains pending until post-threshold"
        );
        require(tokenIds.length < 8, "claiming too many in a single call");
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uint256 tokenId = tokenIds[i];
            address to = pendingTransfers[uint16(tokenId)];
            require(to != address(0), "token is not pending transfer");
            pendingTransfers[uint16(tokenId)] = address(0);
            _transfer(address(this), to, tokenId);
            artSale.mintTo(to);
        }
    }

    //
    // Refund Options
    // If we fail to get >2,000 members members can call these to receive their ETH back.
    // During a refund, the member can decide what to do with the artwork they received during mint:
    //
    //     refundFull:  a member returns both their membership and the artwork they received.
    //                  The member receives a full refund (.15E).
    //
    //  refundKeepArt:  a member returns their membership but keeps the artwork.
    //                  The member receives the full price minus the art price (.15E - .1E = .05E)
    //

    // This lets a member return both their membership and the artwork they received.
    // The member receives a full refund (.15E).
    // NOTE: to receive the full refund, the member does NOT retain the artwork.
    // NOTE: after the sales deadline this is enabled automatically.
    function refundFull(uint256 memberTokenId, uint256 artTokenId)
        external
        nonReentrant
    {
        require(
            ownerOf(memberTokenId) == msg.sender,
            "only the owner may claim a refund"
        );
        require(
            memberTokenId > FOUNDING_TEAM_COUNT,
            "founding team tokens do not get a refund"
        );
        updateMode();
        require(mode == Mode.Refunding, "refunding is not available");

        claimAnyOldRefunds(memberTokenId);
        artSale.transferFrom(msg.sender, address(this), artTokenId);
        _burn(memberTokenId);
        payable(msg.sender).transfer(SALE_PRICE);
    }

    // This lets a member returns their membership but keeps the artwork.
    // The member receives the full price minus the art price (.15E - .1E = .05E)
    // NOTE: the amount refunded is reduced by the price of the artwork.
    // NOTE: after the sales deadline this is enabled automatically.
    function refundKeepArt(uint256 memberTokenId) external nonReentrant {
        require(
            ownerOf(memberTokenId) == msg.sender,
            "only the owner may claim a refund"
        );
        require(
            memberTokenId > FOUNDING_TEAM_COUNT,
            "founding team tokens do not get a refund"
        );
        updateMode();
        require(mode == Mode.Refunding, "refunding is not available");

        claimAnyOldRefunds(memberTokenId);
        _burn(memberTokenId);
        payable(msg.sender).transfer(SALE_PRICE - ART_PRICE);
    }

    //
    // Admin Methods
    //

    // This allows the Society to withdraw funds from the treasury.
    // NOTE: this is locked until there are at least 2,000 members.
    function withdraw() external onlyOwner {
        updateMode();
        require(
            mode == Mode.SellingPostThreshold ||
                mode == Mode.SoldOut ||
                mode == Mode.ClosingAfterRefundPeriod,
            "locked until there are enough members (or after refund period)"
        );
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    // This allows the Society to withdraw any received ERC20 tokens.
    // NOTE: This method exists to avoid the sad scenario where someone
    //       accidentally sends tokens to this address and the tokens get stuck.
    function withdrawERC20Tokens(IERC20 token) external onlyOwner {
        uint256 balance = token.balanceOf(address(this));
        token.transfer(msg.sender, balance);
    }

    // This allows the Society to withdraw any received ERC721 tokens.
    // NOTE: This method locks to secure old memberships used for refunds.
    // NOTE: This method also exists to avoid the sad scenario where someone
    //       accidentally sends tokens to this address and the tokens get stuck.
    function withdrawERC721Token(IERC721 token, uint256 tokenId)
        external
        onlyOwner
    {
        updateMode();
        require(
            mode == Mode.SellingPostThreshold ||
                mode == Mode.SoldOut ||
                mode == Mode.ClosingAfterRefundPeriod,
            "locked until there are enough members (or after refund period)"
        );
        token.transferFrom(address(this), msg.sender, tokenId);
    }

    // The society can update the baseURI for metadata.
    //  e.g. if there is a hosting change
    function setBaseURI(string memory uri) external onlyOwner {
        baseURI = uri;
    }

    // The society can update the ERC2981 royalty rate.
    // NOTE: whereas "percent" is /100, this uses "per mille" which is /1000
    function setRoyalty(uint256 _royaltyPerMille) external onlyOwner {
        royaltyPerMille = _royaltyPerMille;
    }

    // The society can set the initial art sale.
    function setInitialArtSale(IInitialArtSale _artSale) external onlyOwner {
        require(
            address(artSale) == address(0),
            "initial art sale already specified"
        );
        artSale = _artSale;
        // The art to accompany the founding team's memberships (#1..#7) can now be minted.
        for (uint256 i = 0; i < FOUNDING_TEAM_COUNT; i++) {
            artSale.mintTo(ownerOf(i + 1));
        }
    }

    // The society can update the signer of the captcha used to secure #mint().
    function setCaptchaSigner(address _captchaSigner) external onlyOwner {
        captchaSigner = _captchaSigner;
    }

    // The society can disable gas-less listings for security in case OpenSea is compromised.
    function setOpenSeaProxyEnabled(bool isEnabled) external onlyOwner {
        isOpenSeaProxyEnabled = isEnabled;
    }

    //
    // Interface Override Methods
    //

    // The membership contract can receive ETH deposits.
    receive() external payable {}

    // The membership contract can receive ERC721 tokens.
    // See IERC721Receiver
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    // This hooks into the ERC721 implementation
    // it is used by `tokenURI(..)` to produce the full thing.
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    ///
    /// IERC2981 Implementation
    ///

    /**
     * @dev See {IERC2981-royaltyInfo}.
     * This exposes the ERC2981 royalty rate.
     */
    function royaltyInfo(uint256 tokenId, uint256 salePrice)
        external
        view
        returns (address receiver, uint256 royaltyAmount)
    {
        require(_exists(tokenId), "not a valid token");
        return (owner(), (salePrice * royaltyPerMille) / 1000);
    }

    ///
    /// IERC721Enumerable Implementation (partial)
    ///   NOTE: to reduce gas costs, we don't implement tokenOfOwnerByIndex()
    ///

    /**
     * @dev See {IERC721Enumerable-totalSupply}.
     * Returns the total amount of tokens stored by the contract.
     */
    function totalSupply() external view returns (uint256) {
        return memberCount();
    }

    /**
     * @dev See {IERC721Enumerable-tokenByIndex}.
     * Returns a token ID at a given `index` of all the tokens stored by the contract.
     * Use along with {totalSupply} to enumerate all tokens.
     */
    function tokenByIndex(uint256 _index) external view returns (uint256) {
        if (_index >= goldIds) {
            _index = MAXIMUM_GOLD_MEMBER_COUNT + (goldIds - _index);
        }
        require(_exists(_index + 1), "bad token index");
        return _index + 1;
    }

    // This hooks into transfers to track gold balances.
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        if (tokenId > MAXIMUM_GOLD_MEMBER_COUNT) {
            // We only do the extra bookkeeping
            // when a gold token is being transferred.
            return;
        }
        if (from != address(0)) {
            goldBalances[from] -= 1;
        }
        if (to != address(0)) {
            goldBalances[to] += 1;
        }
    }

    // This hooks into approvals to allow gas-free listings on OpenSea.
    function isApprovedForAll(address owner, address operator)
        public
        view
        override
        returns (bool)
    {
        if (isOpenSeaProxyEnabled) {
            ProxyRegistry registry = ProxyRegistry(openSeaProxyRegistry);
            if (address(registry.proxies(owner)) == operator) {
                return true;
            }
        }

        return super.isApprovedForAll(owner, operator);
    }

    ///
    /// IERC165 Implementation
    ///

    /**
     * @dev See {IERC165-supportsInterface}.
     * This implements ERC165 which announces our other supported interfaces:
     *   - ERC2981 (royalty info)
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(IERC165, ERC721)
        returns (bool)
    {
        if (interfaceId == type(IERC2981).interfaceId) {
            return true;
        }
        // NOTE: we don't include IERC721Enumerable
        //       because ours is only a partial implementation.
        return super.supportsInterface(interfaceId);
    }

    //
    // Private Helper Methods
    //

    // This tries to prevent robots from minting a membership.
    // The `captcha` contains a signature (generated via web captcha flow)
    // that was made using the Society's private key.
    //
    // This method checks the signature to see:
    //  - if it was signed by the Society's key and
    //  - if it was for the current msg.sender
    function isProbablyHuman(bytes memory captcha, address sender)
        private
        view
        returns (bool)
    {
        // First we recreate the same message that was originally signed.
        // This is equivalent to how we created it elsewhere:
        //      message = ethers.utils.solidityKeccak256(
        //                  ["string", "address"],
        //                  ["member", sender]);
        bytes32 message = keccak256(abi.encodePacked("member", sender));

        // Now we can see who actually signed it
        address signer = message.toEthSignedMessageHash().recover(captcha);

        // And finally check if the signer was us!
        return signer == captchaSigner;
    }

    // This updates the current mode based on the member count and the time.
    // The contract calls this before any use of the current mode.
    // See "Refund Warranty Process" above for more details.
    function updateMode() private {
        if (mode == Mode.SoldOut) {
            // After selling out, the mode cannot change.
            return;
        }
        uint256 count = memberCount();

        // After the sales deadline, the total supply is fixed to the number sold.
        if (
            block.timestamp >= SALES_DEADLINE &&
            count >= ENOUGH_MEMBERS_TO_PROCEED
        ) {
            MAXIMUM_TOTAL_MEMBER_COUNT = count;
        }

        // Update the mode based on the sales count and time.
        if (count >= MAXIMUM_TOTAL_MEMBER_COUNT) {
            mode = Mode.SoldOut;
        } else if (count >= ENOUGH_MEMBERS_TO_PROCEED) {
            mode = Mode.SellingPostThreshold;
        } else {
            // count < enoughMembersToProceed
            // When there are not enough members to proceed
            // then the mode depends on the time.
            if (block.timestamp < SALES_DEADLINE) {
                // Before sales deadline
                mode = Mode.SellingPreThreshold;
            } else if (block.timestamp < REFUND_DEADLINE) {
                // After sales deadline, before refund deadline
                mode = Mode.Refunding;
            } else {
                // block.timestamp >= refundDeadline
                // After the refund deadline
                mode = Mode.ClosingAfterRefundPeriod;
            }
        }
    }

    // Create the next token ID to be used.
    // This is complicated because we shuffle between two ID ranges:
    //       1-2000 -> gold
    //    2001-5000 -> standard
    // So if there are gold remaining then we use the gold IDs.
    // Otherwise we use the standard IDs.
    function generateTokenId() private returns (uint256) {
        if (goldIds < MAXIMUM_GOLD_MEMBER_COUNT) {
            goldIds += 1;
            return goldIds;
        }
        standardIds += 1;
        return standardIds + MAXIMUM_GOLD_MEMBER_COUNT;
    }

    // Compute the total member count.
    function memberCount() private view returns (uint256) {
        return goldIds + standardIds;
    }

    // This claims any old pending refund to cover the refund of this `memberTokenId`.
    function claimAnyOldRefunds(uint256 memberTokenId) private {
        uint16 oldMemberTokenId = pendingRefundTokens[uint16(memberTokenId)];
        if (oldMemberTokenId != 0) {
            try oldMemberK.refund(oldMemberTokenId) {} catch (bytes memory) {}
        }
    }

    // This actually mints `memberTokenId` to `to` along with a piece of artwork.
    function mintWithArt(address to, uint256 memberTokenId) private {
        _safeMint(to, memberTokenId);
        artSale.mintTo(to);
    }

    // This actually mints `memberTokenId` to `to` along with a piece of artwork.
    // It also associates the minted `memberTokenId` with a pending refund for `oldMemberTokenId`
    function mintFromOldWithArt(
        uint256 oldMemberTokenId,
        address to,
        uint256 memberTokenId
    ) private {
        pendingRefundTokens[uint16(memberTokenId)] = uint16(oldMemberTokenId);
        mintWithArt(to, memberTokenId);
    }
}

// This is the interface to the old membership contract.
interface IOldMember is IERC721 {
    // This allows the membership contract to claim the refund for migrated tokens.
    function refund(uint256 tokenId) external;
}

// This is the interface to the ongoing art sale.
interface IInitialArtSale is IERC721 {
    // This allows the membership contract to mint artwork to a new member.
    function mintTo(address to) external payable;
}

// These types define our interface to the OpenSea proxy registry.
// We use these to support gas-free listings.
contract OwnableDelegateProxy {

}

contract ProxyRegistry {
    mapping(address => OwnableDelegateProxy) public proxies;
}
