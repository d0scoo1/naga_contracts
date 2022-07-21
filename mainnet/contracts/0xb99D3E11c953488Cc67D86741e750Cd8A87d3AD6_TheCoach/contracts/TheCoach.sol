// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./tools/ERC721.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "./interfaces/ITheCoachFunds.sol";
import "hardhat/console.sol";

contract TheCoach is ERC721, Ownable, Pausable, IERC2981, VRFConsumerBaseV2 {
    using Strings for uint256;
    using Address for address payable;

    enum TokenType {
        WarmUp,
        Match,
        Celebration
    }

    // The royalties taken on each sale. Can range from 0 to 10000
    // 500 => 5%
    uint16 internal constant ROYALTIES = 500;

    //current minted supply
    uint256 public totalSupply;

    string public baseURI = "";

    uint256 public currentIndex;

    uint256 public randomStart;

    uint256 public randomIncrementor;

    address public fundsRecipient = 0x1D2720071D79B8D472de0fBe06c7EC8B1278fCFB;

    VRFCoordinatorV2Interface private vrfCoordinator;
    LinkTokenInterface private linkToken;

    // Your subscription ID.
    uint64 private s_subscriptionId;

    event RandomNumbersReceived(uint256 start, uint256 incrementor);

    bytes32 private keyHash;

    ITheCoachFunds private fundsContract;

    uint256 private mintIndex;

    constructor(
        address _fundsContract,
        address _vrfCoordinator,
        address _linkToken,
        bytes32 _keyHash,
        uint64 subscriptionId
    ) ERC721("The Coach", "COACH") VRFConsumerBaseV2(_vrfCoordinator) {
        require(
            _vrfCoordinator != address(0) &&
                _linkToken != address(0) &&
                _fundsContract != address(0),
            "Invalid address"
        );
        vrfCoordinator = VRFCoordinatorV2Interface(_vrfCoordinator);
        linkToken = LinkTokenInterface(_linkToken);
        keyHash = _keyHash;
        s_subscriptionId = subscriptionId;
        fundsContract = ITheCoachFunds(_fundsContract);
    }

    /**
     * @param count - number of premint addresses to drop
     */
    function batchMint(uint256 count) external onlyOwner {
        // The contract receiving the funds has to be paused before
        // doing the batch mint
        require(fundsContract.paused(), "ongoing premint");
        require(randomIncrementor != 0, "Random not initialized");
        uint256 end = mintIndex + count;
        for (uint256 i = mintIndex; i < end; i++) {
            address to = fundsContract.preMintAddresses(i);
            // Make sure to take into account already minted tokens
            // in a previous batch mint
            if (balanceOf(to) >= fundsContract.preMintAllowance(to)) {
                continue;
            }
            uint256 allowance = fundsContract.preMintAllowance(to) -
                balanceOf(to);
            for (uint256 j = 0; j < allowance; j++) {
                uint256 tokenId = getCurrentTokenId();
                _owners[tokenId] = to;
                emit Transfer(address(0), to, tokenId);
            }
            _balances[to] += allowance;
            totalSupply += allowance;
        }
        mintIndex = end;
    }

    function requestRandomNumber() external onlyOwner {
        vrfCoordinator.requestRandomWords(
            keyHash,
            s_subscriptionId,
            // 10 confirmations
            10,
            // up to 1 million gas
            1000000,
            // 2 random numbers
            2
        );
    }

    function fulfillRandomWords(uint256, uint256[] memory _randomWords)
        internal
        override
    {
        // Limit the size of the starting point
        randomStart = _randomWords[0] % 1000000;
        // Limit the size of the incrementor
        randomIncrementor = _randomWords[1] % 100000;
        if (randomIncrementor % 2011 <= 1) {
            randomIncrementor += 10;
        }
        emit RandomNumbersReceived(randomStart, randomIncrementor);
    }

    /**
     * @dev Set the base URI of every token URI
     */
    function setBaseURI(string memory uri) external onlyOwner {
        baseURI = uri;
    }

    /**
     * @dev Set the recipient of most of the funds of this contract
     * and all of the royalties
     */
    function setFundsRecipient(address addr) external onlyOwner {
        require(addr != address(0), "Invalid address");
        fundsRecipient = addr;
    }

    /**
     * @dev Get the URI for a given token
     */
    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(_exists(tokenId), "URI query for nonexistent token");
        // Concatenate the baseURI and the tokenId as the tokenId should
        // just be appended at the end to access the token metadata
        return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
    }

    /**
     * @dev Called with the sale price to determine how much royalty is owed and to whom.
     * @param tokenId - the NFT asset queried for royalty information
     * @param salePrice - the sale price of the NFT asset specified by `tokenId`
     * @return receiver - address of who should be sent the royalty payment
     * @return royaltyAmount - the royalty payment amount for `salePrice`
     */
    function royaltyInfo(uint256 tokenId, uint256 salePrice)
        external
        view
        override
        returns (address receiver, uint256 royaltyAmount)
    {
        receiver = fundsRecipient;
        // We divide it by 10000 as the royalties can change from
        // 0 to 10000 representing percents with 2 decimals
        royaltyAmount = (salePrice * ROYALTIES) / 10000;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function getCurrentTokenId() private returns (uint256) {
        uint256 tokenId;
        do {
            tokenId =
                ((randomIncrementor * currentIndex++) + randomStart) %
                2011;
        } while (tokenId >= 2000 || _exists(tokenId));
        return tokenId;
    }

    /**
     * @dev Get the type of NFT (either Warm up, Match or Celebration) according to the id
     * of the token
     */
    function getTokenType(uint256 tokenId) external view returns (TokenType) {
        require(tokenId < 2000, "Wrong id");
        if (tokenId < 5) {
            return TokenType.Celebration;
        } else if (tokenId < 275) {
            return TokenType.Match;
        } else {
            return TokenType.WarmUp;
        }
    }
}
