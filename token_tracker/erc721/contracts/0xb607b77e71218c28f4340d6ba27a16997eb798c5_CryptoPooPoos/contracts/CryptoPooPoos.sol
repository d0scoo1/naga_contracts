//SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

/**
iiii>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Good girl, RayRay>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>iii
iii>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>iiii
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<!WOOF<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<~ChhhhhhhhhahO~<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<~hahhhhhhhhhh?<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<q@@@@@@@@@@@k~~<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<~~@@@@@@@@@@@@?<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<~<<<~q@@@@@@@@@@@k<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<~B@@@@@@@@@@@?<<<~<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<[]]]]]q%%%%%%%%%%8b][]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]?}&%%%%%%%%%%8(]]]][-<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<<<<<<<<<<<<<<<<<<<<<<<<<_%B@@@@wYYYYYYYYYYYL@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@UYYYYYYYYYYYW@@@BBQ~<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<<<<<<<<<<<<<<<<<<<<<<<~~-@@@@@@mYYYYYYYYYXYL@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@YYYYYYYYYYYY&@@B@@Q~<~<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<<<<<<<<<<<<<<<<<<<<~<<~~-@@B@BBZYYYYYYYYYYYC@B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BYYYYYYYYYYYX&@@@@BL~~<~~~<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<<<<<<<<<<<<<<<<<<<{B@$@@BYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYZZZZOZJYYYYYYYYYYYYYYYYYYOZZZOOUYYYYYYYYYYYm@@@@@O<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<<<<<<<<<<<<<<<<<<<{B@$@@BYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYZZZZOZJYYYYYYYYYYYYYYYYYYOZZZOOUYYYYYYYYYYYm@@@@@O<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<<<<<<<<<<<<<<<<<<<{B@$@@BYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYZZZZOZJYYYYYYYYYYYYYYYYYYOZZZOOUYYYYYYYYYYYm@@@@@O<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<<<<<<~wB$$$$$$$$$@WYYYXXYXYYYYYYYYYYza@@@@@MUXYYYYYYYYYYUYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYm@@@@@O<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<<<<<<<q@@@@@@@@@@@WXXYXYYYYYYYYYYYYYYo@B@@@&YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYm@@@@@O<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<<<<<~<q@$$$$$$$$$@&XYYYYYYYYYYYYYYYYXo@@@@@&YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYm@@@@@O<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><~?[[[[[q&888888888%#XYYYYYYYYYYYYYYYYXo@@@@@&YYYYYYYYYYYYUUUUYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYUXYYYYYm@@@@@O<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<bB%@@@ZYYYYYYYYYYXXYYYYYYYYYYYYYYYYYXo@@@@@&YYYYYYYYYYYYOOZZZZZZZZZOLYYYYYYYYYYXYZZZZZZZZZZZZUYYYYYm@@@@@O<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<b@@@@@ZYYYYYYYYYYYYYYYYYYYYYYYYYYYYYXo@@@@@&YYYYYYYYYYYUZZZZOOOZOZOOLYYYYYYYYYYYYOOZZZZZZZZZOYYYYYYm@@@@@O<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<b@@@@@ZYYYYYYYYYYYYYYYYYYYYYYYYYYYYYXo@@@@@&YYYYYYYYYYYUZZZZZZZOZZZZCYYYYYYYYYYYYZZZZZZOZZZZOJYYYYYm@@@@@O<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<b@@@@@ZYYYYYYYYYYYYYYYYYYYYYYYYYYYYYXo@@@@@&YYYYYYYYYYYY@@@@@@c|((((xYYYYYYYYYYUY@@@@@@f(((((zUYYYYm@@@@@O<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<b@@@@@ZYYYYYYYYYYYYYYYYYYYYYYYYYYYYYXo@@@@@&YYYYYYYYYYYY@@@@@@c|((((xYYYYYYYYYYUY@@@@@@f(((((zUYYYYm@@@@@O<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<b@@@@@ZYYYYYYYYYYYYYYYYYYYYYYYYYYYYYXo@@@@@&YYYYYYYYYYYY@@@@@@c|((((xYYYYYYYYYYUY@@@@@@f(((((zUYYYYm@@@@@O<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<b@@@@@ZYYYYYYYYYYYYYYYYYYYYYYYYYYYYYXo@@@@@&YYYYYYYYYYYJLCCCCCUzzXXXXYYYYYYYYYXYYJCCCJJXXXXXzYYYYXYYCCCCLZ#MMMMk+<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<b@@@@@ZYYYYYYYYYYYYYYYYYYYYYYYYYYYYYXo@@@@@&YYYYYYYYYYYXYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYXYYYYYYYYYYYYYYYYYZ@@@@@&_<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<b@@@@@ZYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYo@@@@@&YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYm@@@@@&_<~<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<b@@@@@ZYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYdMMMMMoO00000YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY0#MMMM*f/t/////////+<<<<<<<<<<<<<<>>>>
>>>><<b@@@@@ZYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYXXXXL@@@@@%UYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYXXXXY%@@B@@@@@@B@1~<<<<<<<<<<<<<>>>>
>>>><<b@@@@@ZYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYL@@@@@%YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY%@@@@@@@@@@B)~<<<<<<<<<<<<<>>>>
>>>><<b@@@@@ZYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYL@@@@@%YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYX8@B@BBBBB@@%1~~~~~~<<<<<<<<>>>>
>>>><<b@@@@@ZYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYL@@@@@%YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY*@$$$$L<<<<<<<<>>>>
>>>><<b@@@@@ZYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYL@@@@@%YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY*@$$$$L<<<<<<<<>>>>
>>>><<b@@@@@ZYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYL@@@@@%YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY*@$$$$L<<<<<<<<>>>>
>>>><<b@@@@@ZYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYL@@@@@%YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYQ00000000000qdbbbbpkkkkkJ<<>>>>
>>>><<b@@@@@ZYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYL@@@@@%YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYOZZZZZZZZZZOOZZZZZd@@@@@w<<>>>>
>>>><<b@B@B@mXYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYL@@@@@%YYYYYYYYYYYYYYYYYXYYYYYYYXYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYOZZZZZZZZZZZZZZZZZd@@@@@w<<>>>>
>>>><<O*#*oomLCCCLJYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYL@@@@@%YYYYYYYYYYYYYYYYYYUUUUUUUYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYX0OOOO0OOZZZZZZZZZZd@@@@@w<<>>>>
>>>><<<<<<<<q@@@@@#YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYL@@@@@%YYYYYYYYYYYYYYYYYYLZZZZOQXYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYX0ZOZZZZZZZZZd@@@@@w<<>>>>
>>>><<<<<<<<q@@@@@#YYYYYXYYYYYYYYYYYYYYYYYYYYYXYYL@@@@@%YYYYYYYYYYYYYYYYYYCZZZZZQXYYYYYYYYYYXXYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY0OZOOOOOOOOOd@@@@@w<<>>>>
>>>><<<<<<<~w@@@B@#XXXXXYYYYYYYYYYYYYYYYYYYYXXYXXC@@@@@8YYYYYYYYYYYYYYYYYYLOOOOOOYXXXXXXXXXXXYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY0ZZZZZZZZZZZdBB@@Bw~<>>>>
>>>><<<<<<<<<<<<<<t@@@@@WYYYYYYYYYYYYYYYYYYo@@@@@&YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYO@@@@@@@@@@@BCYYYYYYYYYYYYYYYYYYYYYYYYYYYYYX&@@$$$$$$$$$L<<<<<<<<>>>>
>>>><<<<<<<<<<<<<<t$$$$@WYYYYYYYYYYYYYYYYYXo@@@@@&YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYO@@@@$$$$@@@BCYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYW@@$$$$$$$$$L<<<<<<<<>>>>
>>>><<<<<<<<<<<<<<t$$$$@WYYYYYYYYYYYYYYYYYXo@@@@@&YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYO@@@@$$$$@@@BCYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYW@@$$$$$$$$$L<<<<<<<<>>>>
>>>><<<<<<<<<<<<<~+----?/W&888WXXYYYYYYYYYXo@@@@@&YYYYYYYYYYYYYYYYYYYYYYYYq88888Z?----------[o88888888888888888888888888888&1-----------?><<<<<<<>>>>
>>>><<<<<<<<<<<<<<<<<<<~1@@@@@BYYYYYYYYYYYXo@@@@@&YYYYYYYYYYYYYYYYYYYYYYYYb@@@@@m<<~<<<<<~<<~&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B}<~<<<<<<<<<<<<<<<<<<>>>>
>>>><<<<<<<<<<<<<<<<<<<<1@@@@@BYYYYYYYYYYYYo@B@@@&UXYYYYYYYYYYYYYYYYYYYYYYd@@@@@m<<<<<<<<<<<~&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%[<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<<<<<<<<<<<<<<<<<<<{MMMMM#YYXXXXXXXXXXh%BBBBWYYYYYYYYYYYYYYYYYYYYYYYYbBBBBBd~+____<<<<<+hMMMMMMMMMMMMMMMMMMMMMMMMMMMMM#[<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<<<<<<<<<<<<<<<<<<~<<~<~~_B@@@@@@@@@@@mYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY0@@@@B@~<~<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<<<<<<<<<<<<<<<<<<<<<<<<<_@%@@@@@$$$$@mYXYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYO@@@@@B~<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<<<<<<<<<<<<<<<<<<<<<<<<<_B@@@@@@$$$$@mYXYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYO@@@@@B~<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<~q$$$$@mYXYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYO@@@@@B~<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<q$$$$@mYXYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYO@@@@@B~<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<q$$$$@mYXYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYO@@@@@B~<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<q$$$$@mYXYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYUCCCCCLWW&&W#?<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<q$$$$@mYXYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYUY@@@@@%-<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>
*/

// Contract by: @backseats_eth

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

// Errors

error ExceedsMaxSupply();
error ClaimClosed();
error MintClosed();
error NoContracts();
error WrongAmount();
error WrongETHAmount();
error AlreadyMinted();
error RayRaysEmpty();

// CryptoRayRays Interface

interface IRayRay {
  function balanceOf(address owner) external returns (uint256);
  function tokenOfOwnerByIndex(address owner, uint256 index) external returns (uint256);
}

// CryptoPooPoos Contract

contract CryptoPooPoos is ERC721A, ERC2981, Ownable {

  // RayRay's home on-chain
  address public constant RAY_RAYS_CONTRACT = 0x8d4E2435c262eB6df10E5e4672A8f07E42D8d67e;

  // The withdraw address for contract funds
  address public _withdrawAddress = 0xF75a7D7cC5991630FB44EAA74D938bd28e35E87E;

  // A mapping of CryptoRayRay IDs to whether they've been used to mint a CryptoPooPoo
  mapping(uint256 => bool) public _rayRayClaimUsed;

  // The price is 0.0123 ETH
  uint256 public price = 0.0123 ether;

  // RayRay took 20,000 PooPoos. She's been busy!
  uint256 public constant MAX_SUPPLY = 20_000;

  // Reserving 100 CryptoPooPoos for the team
  uint256 public constant TEAM_MINT_SUPPLY = 100;

  // Whether the team has claimed their 100 CryptoPooPoos
  bool public _teamMintFinished;

  // The URI where our data can be found
  string public _baseTokenURI;

  // An enum and associated variable tracking the state of the mint
  enum MintState {
    CLOSED,
    CLAIM_OR_PURCHASE,
    PURCHASE
  }

  MintState public _mintState;

  // Modifiers

  modifier ensureSupply(uint256 _amount){
    if (totalSupply() + _amount > MAX_SUPPLY) revert ExceedsMaxSupply();
    _;
  }

  modifier noContracts() {
    if (msg.sender != tx.origin) revert NoContracts();
    _;
  }

  modifier squatting() {
    if (_mintState != MintState.CLAIM_OR_PURCHASE) revert ClaimClosed();
    _;
  }

  modifier mintOpen() {
    if (_mintState == MintState.CLOSED) revert MintClosed();
    _;
  }

  // Constructor

  constructor() ERC721A("CryptoPooPoos", "POOPOOS") {}

  /**
  @notice 10,000 CryptoPooPoos, claimable by RayRay holders. Use the `checkIfClaimed` method to see if your CryptoRayRay
  has been used to claim a CryptoPooPoo yet
  */
  function claimPooPoos() external squatting() noContracts() {
    IRayRay rr = IRayRay(RAY_RAYS_CONTRACT);
    uint256 tokenCount = rr.balanceOf(msg.sender);

    uint256[] memory _rayRayIDs = new uint256[](tokenCount);
    for(uint256 i; i < tokenCount; i++){
      _rayRayIDs[i] = rr.tokenOfOwnerByIndex(msg.sender, i);
    }

    uint256 length = _rayRayIDs.length;
    if (length == 0) revert RayRaysEmpty();

    uint256 count;
    for(uint256 i; i < length;) {
      if (_rayRayClaimUsed[_rayRayIDs[i]] == false) {
        _rayRayClaimUsed[_rayRayIDs[i]] = true;
        unchecked { ++count; }
      }

      unchecked {
        ++i;
      }
    }

    if (totalSupply() + count > MAX_SUPPLY) revert ExceedsMaxSupply();

    _mint(msg.sender, count);
  }

  /**
  @notice 10,000 PooPoos for sale
  */
  function mintYourPooPoo(uint256 _amount) external payable mintOpen() noContracts() ensureSupply(_amount) {
    if (_amount > 20) revert WrongAmount();
    if (_amount * price != msg.value) revert WrongETHAmount();

    _mint(msg.sender, _amount);
  }

  /**
  @notice Team reserves 100 CryptoPooPoos for promotion and marketing purposes
  */
  function teamMint() external onlyOwner ensureSupply(TEAM_MINT_SUPPLY) {
    if(_teamMintFinished) revert AlreadyMinted();
    _teamMintFinished = true;

    _mint(_withdrawAddress, TEAM_MINT_SUPPLY);
  }

  // Setters

  /**
  @notice Sets the contract-wide royalty info
  */
  function setRoyaltyInfo(address _receiver, uint96 _feeBasisPoints) external onlyOwner {
    _setDefaultRoyalty(_receiver, _feeBasisPoints);
  }

  /**
  @notice Sets the baseURI for the collection
  */
  function setBaseURI(string calldata _baseURI) external onlyOwner {
    _baseTokenURI = _baseURI;
  }

  /**
  @notice Sets the mint state for the contract
  */
  function setMintState(uint256 _status) external onlyOwner {
    require(_status <= uint256(MintState.PURCHASE), "Bad status");

    _mintState = MintState(_status);
  }

  /**
  @notice Sets the withdraw address
  */
  function setWithdrawAddress(address _val) external onlyOwner {
    _withdrawAddress = _val;
  }

  // Important: Set new price in wei (i.e. 50000000000000000 for 0.05 ETH)
  function setPrice(uint _newPrice) external onlyOwner {
    price = _newPrice;
  }

  // View Functions

  /**
  @notice Checks if the CryptoRayRay ID was used to mint a CryptoPooPoo yet
  */
  function checkIfClaimed(uint256 _id) external view returns (bool) {
    return _rayRayClaimUsed[_id];
  }

  /**
  @notice Returns the IDs of the CryptoPooPoos of the wallet in question
  */
  function tokensOfOwner(address _owner) external view returns (uint256[] memory) {
    unchecked {
      uint256 tokenIdsIdx;
      address currOwnershipAddr;
      uint256 tokenIdsLength = balanceOf(_owner);
      uint256[] memory tokenIds = new uint256[](tokenIdsLength);
      TokenOwnership memory ownership;
      for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
        ownership = _ownerships[i];
        if (ownership.burned) {
          continue;
        }
        if (ownership.addr != address(0)) {
          currOwnershipAddr = ownership.addr;
        }
        if (currOwnershipAddr == _owner) {
          tokenIds[tokenIdsIdx++] = i;
        }
      }
      return tokenIds;
    }
  }

  /**
  * @dev Returns the starting token ID.
  * To change the starting token ID, please override this function.
  */
  function _startTokenId() internal view virtual override returns (uint256) {
    return 1;
  }

  /**
  @notice Returns the baseURI of the collection
  */
  function _baseURI() internal view virtual override returns (string memory) {
    return _baseTokenURI;
  }

  /**
  @notice Boilerplate to support ERC721A and ERC2981
  */
  function supportsInterface(bytes4 interfaceId) public view override(ERC721A, ERC2981) returns (bool) {
    return super.supportsInterface(interfaceId);
  }

  // Withdraw

  function withdrawFunds() external onlyOwner {
    (bool sent, ) = payable(_withdrawAddress).call{value: address(this).balance}('');
    require(sent);
  }

}
