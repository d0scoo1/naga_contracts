// SPDX-License-Identifier: MIT

/*
                                                                                
                    .',:cllol:'.                                                
                  'dKXK0kxdddxOOxooooooolc;'.                                   
                 ;KWx,.       .',,,,,,,;::looodl;'.                             
               'dXWx.  ..'''.      ..        .,cdOOd:.                          
            .ckKOo,.  'kNNWWx.   :OK0Okdddoc;.   .,lxOxc.                       
          .lKXx,      lWMMMMd   '0MMMMMMMMMMMXkl,.   .:k0d,                     
        'dKXd'        dMMMMWc   ;XMMMMMMMMMMMMMMN0o,.   ,kXx'                   
      .lXXo.   .ckc  .kMMMMX;   cWMMMMMMMMMMMMMMMMMW0l.  .cKXl.                 
     'kNk'    ;0WMd  '0MMMM0'   oMMMMMMMMMMMMMMMMMMMMMK:   'kXx.                
    :KNo.   'xNMMMo  ,KMMMMk.  '0MMMMMMMMMMMMMMMMMMMMMMNd.   :KO'               
   cXWo.   :KMMMMWc  ;XMMMMo   oWMMMMMMMMMMMMMMMMMMMMMWWWx.   ;OOo;.            
  ;XWd.   cXMMMMM0'  'xOOOk;  '0MMMMMMMMMMMMMMMMMMMXxc;,;lc.   .'ck0o.          
 .OMO.   cXMMMW0l.            .xWMMMMMMMMMMMMMMMMM0,  .'.     .,.  lXx.         
 oWX:   ;XMMMKl.    .'',;,..   .cOWMMMMMMMMMMMMMMX; .xNWKl.  cXW0;  dNc         
'0Mx.  .kMMWk.   .;xKNNWMWN0x:.  .:KMMMMMMWKOKWMMx. :NMMMK, .xMMMk. ;Xo         
:NNc   lNMMk.   'kWMMMMMMMMMMWk.   ,0MMMMKc. .cKMo  lWMMMN:  dMMMk. .Oo         
lWK,  '0MMX:   ,0MMMMMMMMMMMMMM0'   cNMXO:    .xMd  lWMMMWl  lWMMO. .Od         
lWO.  :NMMk.  'OMMMMMMMMMMMMMMMWo   ;XMk,. ;c. :Xx. ;KMMMNc  ;XMMk. cNO'        
cWd   lWMWl   cWMMMMMMMMMMMMMMMMd   :NNc  .xX: .oKc  ;xOx;    ;oo' .kWWKdc;.    
;Xd   cNMWl   cWMMMMMMMMMMMMMMMN:   cNO.  ;XMK; .l0x;... .;dx:.     .;:lloxkk;  
'0x.  '0MMo   ,KMMMMMMMMMMMMMMMx.  .kK;   oMMMK;  'xXX0OOKWMMWX00ko:'.     .:ko.
.kK,   cNMO.   :XMMMMMMMMMMMMWO'   lXo    ,xxo,  .  ;xXWMMMMMMMMMMMMWX0kd'   ,0l
 oNo   .kMWd.   'o0NMMMMMMMMXo.   :K0'  .      .xKd.  .;lx0NMMMMMMMMMMMMNc   .xx
 .OK;   :NMNx,    .':oxkxdoc'    cXMx. .,:dd;  oWMWO.     .';coxkOO00Oxl,    :0o
  ,0O.  .dWMMNk;.             .;xNMMo .xWWMNo. ,k0x; .ckd'               .'ck0o.
   :Ko   .dWMMMW0o:,'..  ..,cxXWMMMMx. oXKd,..,..    .lOd' ;xkxdolllcloxkxxdc.  
    oXo.  .cKMMMMMMWNK0OO0XWMMMMMMMMX: ... 'xNWK,  ;xd;.  .lc;:o0WMW0dlc;.      
    .xNO'   'xNMMMMMMMMMMMMMMMMMMMMMMk.   :XMMMK, ;XWNx.        .oNK,           
     .lXK:    ,kWMMMMMMMMMMMMMMMMMMMMNl   .oO00l. 'c;..   .;oOo. .dX:           
       'kXx'   .;o0WMMMMMMMMMMMMMMMMMMNo,.   .     ..'';lxKWMMK,  :K:           
         :OKd,    .;o0WMMMMMMMMMMMMMMMMWWKdlc::clok0XNWMMMMMMWk.  ck'           
          .:xKOl,.   .;okXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWOc.  'Oo            
             'ckK0d;.    .;ok0XWMMMMMMMMMMMMMMMMMMMMMMMNKko;.   ;0K,            
                'cx00xc'     ..,:ldkO0KXXXXXXXXK0Oxdlc;'.   .,lkXO,             
                   .:dOKOo:'.        ...........        .,cd0NNk:.              
                       .;ldxkkdoc:,'.....       ..';ccox0NNKxl'                 
                            .;ldk0KKKKKK00000OOO0XNNXKOxl:'.                    
                                 ...',:::ccccllllc;'..                          
                                                                                
                                                                                
*/

pragma solidity ^0.8.0;

import 'erc721a/contracts/ERC721A.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/access/AccessControl.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/common/ERC2981.sol';

contract CREYZIES is ERC721A, ERC2981, ReentrancyGuard, AccessControl, Ownable {
    struct SendData {
        address receiver;
        uint256 amount;
    }

    bytes32 public constant SUPPORT_ROLE = keccak256('SUPPORT');
    string public provenance;
    string private _baseURIextended;
    mapping(uint256 => bool) public unclaimedTokenIds;

    IERC721Enumerable public immutable baseContractAddress;

    constructor(
        address contractAddress,
        string memory name,
        string memory symbol
    ) ERC721A(name, symbol) {
        require(
            IERC721Enumerable(contractAddress).supportsInterface(0x780e9d63),
            'Contract address does not support ERC721Enumerable'
        );

        // set immutable variables
        baseContractAddress = IERC721Enumerable(contractAddress);

        // setup roles
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(SUPPORT_ROLE, msg.sender);
    }

    ////////////////
    // tokens
    ////////////////
    /**
     * @dev sets the base uri for {_baseURI}
     */
    function setBaseURI(string memory baseURI_) external onlyRole(SUPPORT_ROLE) {
        _baseURIextended = baseURI_;
    }

    /**
     * @dev See {ERC721-_baseURI}.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIextended;
    }

    /**
     * @dev sets the provenance hash
     */
    function setProvenance(string memory provenance_) external onlyRole(SUPPORT_ROLE) {
        provenance = provenance_;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(AccessControl, ERC721A, ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    ////////////////
    // royalty
    ////////////////
    /**
     * @dev See {ERC2981-_setDefaultRoyalty}.
     */
    function setDefaultRoyalty(address receiver, uint96 feeNumerator) external onlyRole(SUPPORT_ROLE) {
        _setDefaultRoyalty(receiver, feeNumerator);
    }

    /**
     * @dev See {ERC2981-_deleteDefaultRoyalty}.
     */
    function deleteDefaultRoyalty() external onlyRole(SUPPORT_ROLE) {
        _deleteDefaultRoyalty();
    }

    /**
     * @dev See {ERC2981-_setTokenRoyalty}.
     */
    function setTokenRoyalty(
        uint256 tokenId,
        address receiver,
        uint96 feeNumerator
    ) external onlyRole(SUPPORT_ROLE) {
        _setTokenRoyalty(tokenId, receiver, feeNumerator);
    }

    /**
     * @dev See {ERC2981-_resetTokenRoyalty}.
     */
    function resetTokenRoyalty(uint256 tokenId) external onlyRole(SUPPORT_ROLE) {
        _resetTokenRoyalty(tokenId);
    }

    /**
     * @dev executes an airdrop
     */
    function airdrop(SendData[] calldata sendData) external onlyRole(SUPPORT_ROLE) nonReentrant {
        uint256 ts = baseContractAddress.totalSupply();

        // loop through all addresses
        for (uint256 index = 0; index < sendData.length; index++) {
            require(totalSupply() + sendData[index].amount <= ts, 'Exceeds original supply');
            _safeMint(sendData[index].receiver, sendData[index].amount);
        }
    }

    /**
     * @dev explicitly set token ids that have not been claimed
     */
    function setUnclaimedTokenIds(uint256[] calldata tokenIds) external onlyRole(SUPPORT_ROLE) {
        for (uint256 index = 0; index < tokenIds.length; index++) {
            unclaimedTokenIds[tokenIds[index]] = true;
        }
    }

    /**
     * @dev redeems an array of token ids
     */
    function redeem(uint256[] calldata tokenIds) external nonReentrant {
        uint256 numberOfTokens = tokenIds.length;

        for (uint256 index = 0; index < numberOfTokens; index++) {
            require(unclaimedTokenIds[tokenIds[index]], 'Token has already been claimed');

            try baseContractAddress.ownerOf(tokenIds[index]) returns (address ownerOfAddress) {
                require(ownerOfAddress == msg.sender, 'Caller must own NFTs');
            } catch (bytes memory) {
                revert('Bad token contract');
            }

            unclaimedTokenIds[tokenIds[index]] = false;
        }

        uint256 ts = baseContractAddress.totalSupply();
        require(totalSupply() + numberOfTokens <= ts, 'Exceeds original supply');

        _safeMint(msg.sender, numberOfTokens);
    }
}
