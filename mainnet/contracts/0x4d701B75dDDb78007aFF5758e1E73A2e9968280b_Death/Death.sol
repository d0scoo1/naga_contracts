// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @creator: The Muse
/// @author: manifold.xyz

import "@manifoldxyz/libraries-solidity/contracts/access/AdminControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MMMNNMMNNNNNNNNMNNNMMNNNNMNNNNNNNNNNNMMNNNNhyhhhddddddhyhNNNNNMMNNMMNNMMNNMNNNMNMMNMNNMNMNNNNMMMMMNNMMNNNNNMNMMNMNMMNNNNMNNNMMNNMN //
// MNMNNNNMNNNMMNNMNMMMMNNNNNNNNNNNMMNNMMMMdyymMMMMMMMMMMMMmshdMNMNMNNMMNNNMMNNMNMNNMNMMMMMNNMMMMNNNMMNMMNNNMMNNNMMMMNNNMNNMMMMNNMMNN //
// NNNNNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMmhydMMMMMMMMMMMMMMMMMMdoMMNNNMNNMNNNMNNMNMMMMMMMMMMMMMMMNMNNNNNMMNNNMMMMMNMNNNMMNMMNMMNMNNNNN //
// NNNNNNNMNMMMMMmmmNNNMMMMMMMMMMMMMMMohdNMMMMMMMMMMMMMMMMMMMMMomMMNMMMNNNMNNNNNNMMMMMMMMMMMMMMMMMMMMMMNNNNMMNNNNNMNNMMMMMNNNMMMMNMNM //
// MNNMMMMMMMMMMNddmdmdddmmmmNNNNNNMmohMMMMMNMMMMMMMMMMMMMMMMMM+NNNNNMNMNMNMNNMNMMMMMMMMMMMMMMMMNMNNMMMMMNNMMMNMNMMMMNMMMMMNMMMMMMMMM //
// MMMNNMMMMMMMMNdmMNNmmmMNNNNNNNdoshNMNNMMMNMMMMMMMMMMMMMMMMMmoNNNNNNMMMMNNMMMMMMMNMMNNMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNMNMNMM //
// MNNNMMMMMMMMNhdNNMMMNNmmmmdhdsoohNMMMNNNMmNMMMMMMMMMMMMMMMMshNNNNNMMMMMNMNMMNMMMMMMNNMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNMMNMMNMM //
// NMNNMMMMMMMMMmmddNNNmhhyyyysooomyNMMMMNmNNNMNMMMMMMMMMMMMMd+mNNMMMMMMNMMMMNMMMMMMMMNNNNMMNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNNNNNNMN //
// NNNNNNNMMMMMMMMMMMMMNNmhhyssshsdmNNNMMMNNMNMMmMMMMMMMMMMMN+mNmNMMMMMMMMMMMMMMMMMMMMMMMMNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNNNNMMNNN //
// NMNNNNMMMMMMMMMMMMMMMMyhmmmNNMMNNmmMmhdNmMNNMNMMMMMMMMMMMssmNNNMMMMMMMMMMMMMMMMMMMMMMMNMNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNMMMMMNNN //
// NNNMNNMMNNMMMMMMMMMMNM+mNMNNmNMNNhyhd+hMdMMMMMmMMMMMMMMMMNdysNNNMMMMMMMMMMMMMMMMMMMMNNMMMMNMMMMMNMMMMMMMMMMMMMMMMMMMMMMMMNNMMMMNNN //
// NNMNNNNNMMMMMMMMMNNNMmomNMMMdNNNM+NMdomMmmMNNMMMMMMMMMMMMMMM+dmNNMMMMMMMMMMMMMNMMMNNMNMMMMNMMNMMMNMMMMMMMMMMMMMMMMMMMMMMMMNNNNMMNN //
// NNNNMMMMMMMMMMMMMMNNNsmMNMMMdMNNMohyymmNMmNmNMMMMMMMMMMMMMMMmodmNNMMMMMMMMMMMMMMMNNNNMMMMMMMNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNMN //
// NNNMNNNMMMMMMNNNNMNMN+NNNMMMmMMNMNNMMNmMmNNMMNNNMNNMMMMMMNMMMNysdNNMMMMMMMMMMMNNNNNMMMMNMMMMNMNNNNMMNMNMMMMNMMMMMMMMMMMMMMMMMMNNMM //
// MMMNNMNMMMMMMNNMMNNNN+NNMMMMNMMMMMMMNNMNmmNmNNNMMNMMMMMMMMMMMMMNhodNMMMMMMMMMMMNNMMMMMMNMNNNNNNNMMMMNMMMMMMMMMMMMNMMMMMMMMMMMMNNMN //
// MNNMNMMMMMMNMMMNNNMNN/NMMMMMNMMMMMMNNmNmMMNNMNNMMMMMMMMMMMMMMMMMMNoymNMMNMMMNNMMmhddddmNNNNNMNNNNMMNMMMNNNNMMMMMMMMMMMMMMMMMNNNNNM //
// MMMMNNNNMNNNMMMNNNNNyyNMMMMMNMNMMMNNmNMMMNMMMMMMMMMMMMMMMMMMMMMMMMNhomNNNMNMNNNhsmNNNmdhhhddmNNNMNMNMNNNMNMNMMMMMMMMMMMMMMMMNNNNNM //
// NMNMNMNNNNNMMMNNNNNNomNMMNMNNMNMMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMNMMMMMdsNNNNNNNmoshyoshhNMNNNmhhhhdNNMMNNMMNNMMMNNMMMMMMMMMNNNNMNNMM //
// NNNNNNNNNNNMMMNMNMNNm+dNMMNNMMNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+NNNMNNmodmoysoMhdMMMMMMMMNmdhydNNMMMNNNNNNMNNNMMMMMMNMMNNNMM //
// MMNNNMNNMNNNNNNNNNNNNNyyyhhdNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNMMMMhhNMNNNshd++ssNMdyNNNMMMMMMMMMNmhyhmNNNNNNNMNNMMNMMMNNNNNNNMM //
// MNMNNNNMNNNNMMMMNNNNNNNNNNNdoyMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNNNoNNMNyoo/oosNMMNNddhydmmNMMMMMMMMNhhhmNNNNNNMNNMNNMNMNNNNNMN //
// MMNNMMNMMNNNNNNNNMMNMNNNNNNNN/MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNMMNNsdMMy+myhssMMMMMMMMmdMNdyyyhhmMMMMMMNdhhmMNMNNNNNNMMMNNNNNNM //
// MNMMNNNNMNNMNNMMMNNNNMNNNNNNhyMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNMMNN+NyhssossNMMMMMMMNdNMMMdyhyyymMMMMMMMMNhyhNNNNMNNNNNMNNMMNM //
// MNMNMNMNNMMNNNNNNNNNMMNNNNNNoNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNNd+hNhsooNMMMMMMMMMMMMMMNhmMmyyyhdNMMMMMMMmyhNMNNNNNNMNNNNMN //
// MNMNNNNNMNMNMNNNNMNNMNMNNNNN+MNMMMMMMMMMMMMMMNMMMMMMMMMMMMMMMMMMMMNNMMNyoMdoo+mMMMMMNNMMMMMmMMNmMMMdddhhydmNNMMMMMNyymNMMNMNNNNMMM //
// MMMNNNMNNNNNMMNMMMMNNMNNNNNdsMNMMMMMMMMMMMMMNmMMMMMMMMMMMMMMMMMMMMMMNNm/yyyydshMMMMmmNMMMMNdNMMMMMMMMMMMNmyyydMMMMMMNysmMMNNNNNNNM //
// NMMMNNNNNNNMMMMMMMMMMMNNNNNydMMMMMMMMMMMMMMMNmNMMMMMMMMMMMMMMMMMMMMNNNMNMMMNMMdyMMMNmMMMMMMMMMMMMMMMMMMMMMhhmdyhdNMMMMmsyNMNNNMMNN //
// MMNNNMMMMNMMMMMMMMMMNNNNNmNoNMMMMMMMMMMMMMMMMNNMMMMMMMMMMMMMMMMMMNmmMMMMMNNMMMm+NMMMMMMMMMMNNNMMMMMMMMMMMMNdNMmyhmmNMMMNmsyNNNNNNN //
// MMNNNMMMMMMMMMMMMMMNNNNNNNN+MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNNMMMMMMMMMMMN+NMMMMMMMmhhhydMMMmNMMMMMMMMNMMNNmdyhNMMMMNhomNNMNN //
// MNMMMMMMMMMMMMMMMMMNNNNmNNdyMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNNmMMMMMMMMMMMM+MMMMMMMMMNmdmMMMNdMMMMMdNNMNMMMMNNdyhmMMMMMm+NNMMM //
// MNMMMMMMMMMMMMMMMMMNNNNNNNomMMMMMMMMMMMMMMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMdsMMMMMMMMMMMMMMMMMMMMMMMdhNMMMMMMmNNmmhhNMMMMsdMMMM //
// MMMMMMMMMMMMMMMMMMNNNNNNNN+MMMMMMMMMMMMMMMMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMmsNMMMMMMMMMMMMMMMMMMMMMMMNNMMMMMMMMMMMMMmhyNNM+mNMNN //
// MNNMMMMMMMMMMMMMMMNNMNNNNNoMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd:NMMMMMMMMMdyNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMdMMNNmmMMMMNhhhhyNNMMN //
// MNNNMMMMMMNMMMMMMNNMMNNNNyhMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN/:NMMMMMNNNMdhMMMMMMMMMMMMMMMMMMMMNddNMMMMMMmMMMNdNMMMMMdyyyNNNMMM //
// MNMMNNMMNNNMMMMMNNMMMNNNN+NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMoy+NMMMMNMMNMNyMMMMMMMMMMMMMMMMMMMMhhhhNMMMMMMMMMMMMMMMMMmyhdMMNMMM //
// NNMMMNMMNNNMMNNNNMNNNNNNN+MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMhomsddNNMMMNMMNyMMMMMMMMMMMMMmMMMMMMNMMNNMMMMMMMMMMMMNNMMMNyydMNNMMM //
// NNMMMNMNNMNMMNNNNNMNNNNNyhMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN/hmhmhNNMNNNMMMsMMMMMMMMMMMMMNNMMMMMMMMMmmNMMMMMMMMMMmNNMMMmhNMNNMMM //
// NMMMMMMNNNNMNMNNMNNMNNNN+NMNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+dhhdyNMNMMNMMNNsMMMMMMMMMMMMMMdNMMMMMMMMNmMMMNNNNMMMmNMNMMMNmMMNNMMM //
// NMMNNMNNNNMMNMNNNNMMNNNN+MMMNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMdodhdysMMNMMMMMNmsMMMMMMMMMMMMMMMMMMMMMMMMMNNMMMdmMMMMNMMNMMNmMMMNNNMM //
// NMNNNMMMNNMNNNNNNNNNNNNdyMMNNMMMMMMMMMMMMMMMMNMMMMMMMMMMMMMM/ddhmydhMMMMMMMMNsMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNmNmNMMMMNNNMMMMMMNNNMM //
// MNNMMNNNNNNNMNMMNNNMNNNsmMMNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMdohhmydmmyNMMMMMMdyMMMMMMMMMMMMMMmNmMMMMMMMMMMMMMMMMmMMMMNNMMNNMMMNNMMM //
// NNNMNNMNNNNMNNNNNNMNNNN+NMMNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+mddmhmNMmymNMMMNhdMMMMMMMMMMMMMMdmMMMMMMMMMMMMMMMMMMMMMMNNMMMMMMMNNNNM //
// MMNNNMNNNNMMNNNNNMMNMNN+MNNNNMMMMMMMMMMMMMMMMMMNMMMMMMMMMMmodhNNhNMMMMNmdddmNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNNMMM //
// MMNMNMNNMNNMNNNMNNMNNNmsMNNMNMMMMMMMMMMMMMMMMMMNMMMMMMMMMM+hdhNhmMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNMMMM //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
contract Death is ReentrancyGuard, AdminControl, ERC721 {

    using Address for address;
    using Strings for uint256;

    string private _name;
    string private _symbol;

    uint256 private _royaltyBps;
    address payable private _royaltyRecipient;
    bytes4 private constant _INTERFACE_ID_ROYALTIES_CREATORCORE = 0xbb3bafd6;
    bytes4 private constant _INTERFACE_ID_ROYALTIES_EIP2981 = 0x2a55205a;
    bytes4 private constant _INTERFACE_ID_ROYALTIES_RARIBLE = 0xb7799584;

    address _muse;
    string _tokenURI;
    bool _hasDied;
    bool _hasMinted;
    string _dyingTokenURI;
    string _deadTokenURI;
    string _aliveTokenURI;

    constructor() ERC721("Death", "DEATH") {
        _name = "Death";
        _symbol = "DEATH";
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(AdminControl, ERC721) returns (bool) {
        return interfaceId == type(IERC721).interfaceId || AdminControl.supportsInterface(interfaceId) ||
            ERC721.supportsInterface(interfaceId) || interfaceId == type(IERC721Metadata).interfaceId || interfaceId == _INTERFACE_ID_ROYALTIES_CREATORCORE || 
            interfaceId == _INTERFACE_ID_ROYALTIES_EIP2981 || interfaceId == _INTERFACE_ID_ROYALTIES_RARIBLE;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function tokenURI(uint256) public view virtual override returns (string memory) {
        return _tokenURI;
    }

    function updateTokenURI(string memory newURI) public adminRequired {
        _tokenURI = newURI;
    }

    function updateDyingTokenURI(string memory newURI) public adminRequired {
        _dyingTokenURI = newURI;
    }

    function updateDeadTokenURI(string memory newURI) public adminRequired {
        _deadTokenURI = newURI;
    }

    function updateAliveTokenURI(string memory newURI) public adminRequired {
        _aliveTokenURI = newURI;
    }

    function _beforeTokenTransfer(address, address to, uint256 tokenId) internal virtual override {
        if (_exists(tokenId) && !_hasDied && to != address(0xdead)) {
            _tokenURI = _dyingTokenURI;
        }
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view override returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ERC721.ownerOf(tokenId);
        return (isAdmin(spender) || spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    function mint() public adminRequired {
        require(!_hasMinted, "Can't mint twice");
        _hasMinted = true;
        _mint(msg.sender, 1);
    }

    function unplug() public {
        require(ownerOf(1) == msg.sender, "Only collector can unplug");
        require(!_hasDied, "Can only die once");
        _hasDied = true;
        _tokenURI = _deadTokenURI;
        _transfer(ownerOf(1), address(0xdead), 1);
    }

    function identifyMuse(address muse) public adminRequired {
        _muse = muse;
    }

    function resuscitate(address recipient) public {
        require(msg.sender == _muse, "Only the muse can resuscitate");
        _tokenURI = _aliveTokenURI;
        _transfer(address(0xdead), recipient, 1);
    }

    /**
     * ROYALTY FUNCTIONS
     */
    function updateRoyalties(address payable recipient, uint256 bps) external adminRequired {
        _royaltyRecipient = recipient;
        _royaltyBps = bps;
    }

    function getRoyalties(uint256) external view returns (address payable[] memory recipients, uint256[] memory bps) {
        if (_royaltyRecipient != address(0x0)) {
            recipients = new address payable[](1);
            recipients[0] = _royaltyRecipient;
            bps = new uint256[](1);
            bps[0] = _royaltyBps;
        }
        return (recipients, bps);
    }

    function getFeeRecipients(uint256) external view returns (address payable[] memory recipients) {
        if (_royaltyRecipient != address(0x0)) {
            recipients = new address payable[](1);
            recipients[0] = _royaltyRecipient;
        }
        return recipients;
    }

    function getFeeBps(uint256) external view returns (uint[] memory bps) {
        if (_royaltyRecipient != address(0x0)) {
            bps = new uint256[](1);
            bps[0] = _royaltyBps;
        }
        return bps;
    }

    function royaltyInfo(uint256, uint256 value) external view returns (address, uint256) {
        return (_royaltyRecipient, value*_royaltyBps/10000);
    }
}