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
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// The Society mints artwork for the initial collection using this contract.
//
// Each piece of artwork comes along with the membership purchase.
// So the minting mechanism can only be called by the membership contract.
// And the total supply is capped to the membership total supply.
contract SocietyInitialArtSale is ERC721, IERC2981, IERC721Receiver, Ownable {
    // This references the SocietyMember contract.
    // It is authorized to call `mintTo` in the context of selling membership.
    address public mintingContract;

    // We generate the next token ID by incrementing this counter.
    uint16 private ids;

    // This contains the base URI (e.g. "https://example.com/tokens/")
    // that is used to produce a URI for the metadata about
    // each token (e.g. "https://example.com/tokens/1234")
    string private baseURI;

    // This indicates that the base URI has been sealed.
    // This lets The Society make the metadata immutable once it
    // has been placed into permanent IPFS storage.
    bool public isSealed;
    event Sealed(uint256 totalSupply, string baseURI);

    // For exchanges that support ERC2981, this sets our royalty rate.
    // NOTE: whereas "percent" is /100, this uses "per mille" which is /1000
    uint256 private royaltyPerMille;

    // To enable gas-free listings on OpenSea we integrate with the proxy registry.
    address private openSeaProxyRegistry;
    // The Society can disable gas-free listings in case OpenSea is compromised.
    bool private isOpenSeaProxyEnabled = true;

    struct Config {
        address mintingContract;
        uint256 royaltyPerMille;
        address openSeaProxyRegistry;
    }

    constructor(Config memory config) ERC721("Art", "ART") {
        mintingContract = config.mintingContract;
        royaltyPerMille = config.royaltyPerMille;
        openSeaProxyRegistry = config.openSeaProxyRegistry;
    }

    // This is called by the membership contract to mint artwork to a new member.
    // See SocietyMember#mint()
    function mintTo(address to) external {
        require(
            mintingContract == msg.sender,
            "this art is minted in the context of purchasing membership"
        );
        _mint(to, generateTokenId());
    }

    //
    // Admin Methods
    //

    // This allows the Society to withdraw any received funds.
    // NOTE: This method exists to avoid the sad scenario where someone
    //       accidentally sends tokens to this address and the tokens get stuck.
    function withdraw() public onlyOwner {
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
    // NOTE: This method exists to avoid the sad scenario where someone
    //       accidentally sends tokens to this address and the tokens get stuck.
    function withdrawERC721Token(IERC721 token, uint256 tokenId)
        external
        onlyOwner
    {
        token.transferFrom(address(this), msg.sender, tokenId);
    }

    // The society can update the baseURI for metadata
    //  e.g. if there is a hosting change
    function setBaseURI(string memory uri) public onlyOwner {
        require(!isSealed, "base URI cannot change after it has been sealed");
        baseURI = uri;
    }

    // This lets The Society make the metadata immutable once it
    // has been placed into permanent IPFS storage.
    function seal() public onlyOwner {
        mintingContract = address(0);
        isSealed = true;
        emit Sealed(ids, baseURI);
    }

    // The society can update the ERC2981 royalty rate
    // NOTE: whereas "percent" is /100, this uses "per mille" which is /1000
    function setRoyalty(uint256 _royaltyPerMille) public onlyOwner {
        royaltyPerMille = _royaltyPerMille;
    }

    // The society can disable gas-less listings for security in case OpenSea is compromised.
    function setOpenSeaProxyEnabled(bool isEnabled) external onlyOwner {
        isOpenSeaProxyEnabled = isEnabled;
    }

    // The society can change the minting contract in case the membership drive fails and
    // we need to conduct the remainder of the sale directly.
    function setMintingContract(address mintingContract_) external onlyOwner {
        require(!isSealed, "minting contract cannot be changed after sealing");
        mintingContract = mintingContract_;
    }

    //
    // Interface Override Methods
    //

    // The sale contract can receive ETH deposits.
    receive() external payable {}

    // The sale contract can receive ERC721 tokens.
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

    // This exposes the ERC2981 royalty rate.
    function royaltyInfo(uint256 tokenId, uint256 salePrice)
        external
        view
        returns (address receiver, uint256 royaltyAmount)
    {
        require(_exists(tokenId), "not a valid token");
        return (owner(), (salePrice * royaltyPerMille) / 1000);
    }

    // This is a partial implementation of ERC721Enumerable
    function totalSupply() external view returns (uint256) {
        return ids;
    }

    // This is a partial implementation of ERC721Enumerable
    function tokenByIndex(uint256 _index) external view returns (uint256) {
        require(_exists(_index + 1), "bad token index");
        return _index + 1;
    }

    // This hooks into approvals to allow gas-free listings on OpenSea.
    // It also allows single-transaction membership refunds.
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
        // NOTE: mintingContract is set to address(0) when this sale is #seal()-ed.
        if (mintingContract == operator) {
            return true;
        }

        return super.isApprovedForAll(owner, operator);
    }

    // This implements ERC165 and announces that we
    // support the ERC2981 (royalty info) interface.
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
        return super.supportsInterface(interfaceId);
    }

    //
    // Private Helper Methods
    //

    // Create the next token ID to be used.
    function generateTokenId() private returns (uint256) {
        ids += 1;
        return ids;
    }
}

// These types define our interface to the OpenSea proxy registry.
// We use these to support gas-free listings.
contract OwnableDelegateProxy {

}

contract ProxyRegistry {
    mapping(address => OwnableDelegateProxy) public proxies;
}
