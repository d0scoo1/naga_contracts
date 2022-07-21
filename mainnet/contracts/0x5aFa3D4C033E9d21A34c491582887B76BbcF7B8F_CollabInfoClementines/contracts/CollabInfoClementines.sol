pragma solidity ^0.8.12;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "./SkyFarm.sol";

contract CollabInfoClementines is
    Initializable,
    ContextUpgradeable,
    UUPSUpgradeable,
    OwnableUpgradeable
{
    ERC721 public skyverseContract;
    SkyFarm public skyfarmContract;

    mapping(uint256 => bool) public clementinesNFT;

    //======================INIT=====================//

    function initialize(address nftContract, address farmContract)
        public
        initializer
    {
        __Ownable_init();
        skyverseContract = ERC721(nftContract);
        skyfarmContract = SkyFarm(farmContract);
    }

    //======================OVERRIDES=====================//

    function _authorizeUpgrade(address) internal override onlyOwner {}

    //======================OWNER FUNCTION=====================//

    function setContract(address nftContract, address farmContract)
        external
        onlyOwner
    {
        skyverseContract = ERC721(nftContract);
        skyfarmContract = SkyFarm(farmContract);
    }

    function setClementines(uint256[] calldata clementines, bool state) external onlyOwner{
        for(uint256 i = 0; i < clementines.length; i++){
            clementinesNFT[clementines[i]] = state;
        }
    }

    //======================PUBLIC=====================//

    /// @notice For collab.land to give a role based on staking status / in wallet NFT
    function balanceOf(address owner) public view virtual returns (uint256) {
        uint256[] memory stakedIds = skyfarmContract.getStakedIds(owner);
        uint256 balance = 0;
        
        for(uint256 i = 0; i < stakedIds.length; i++){
            if(clementinesNFT[stakedIds[i]]) balance++;
        }

        return balance;
    }

    /// @notice For collab.land to give a role based on staking status / in wallet NFT for collab specific
    function ownerOf(uint256 tokenId) public view virtual returns (address) {
        address owner = skyverseContract.ownerOf(tokenId);
        if (owner == address(skyfarmContract))
            owner = skyfarmContract.stakedBy(tokenId);
        require(
            owner != address(0),
            "ERC721: owner query for nonexistent token"
        );
        return owner;
    }
}
