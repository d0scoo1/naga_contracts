// SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

// Get the latest ETH/USD price from chainlink price feed
import "AggregatorV3Interface.sol";
import "LinkTokenInterface.sol";
import "VRFCoordinatorV2Interface.sol";
import "VRFConsumerBaseV2.sol";
import "Ownable.sol";

contract MyFundStorage is VRFConsumerBaseV2, Ownable {

    address payable[] private payers;
    uint256 private usdEntryFee;
    uint256 private MINIMUM_ENTRY_FEE = 50;
   
    AggregatorV3Interface internal ethUsdPriceFeed;

    enum FUNDING_STATE {
        OPEN,
        CLOSED,
        END
    }
    FUNDING_STATE private funding_state;


    VRFCoordinatorV2Interface immutable COORDINATOR;
    LinkTokenInterface immutable LINKTOKEN;

  // Your subscription ID.
  uint64 immutable s_subscriptionId;

  // The gas lane to use, which specifies the maximum gas price to bump to.
  // For a list of available gas lanes on each network,
  bytes32 immutable s_keyHash;

  // Depends on the number of requested values that you want sent to the
  // fulfillRandomWords() function. Storing each word costs about 20,000 gas,
  // so 100,000 is a safe default for this example contract. Test and adjust
  // this limit based on the network that you select, the size of the request,
  // and the processing of the callback request in the fulfillRandomWords()
  // function.
  uint32 immutable s_callbackGasLimit = 100000;

  // The default is 3, but you can set this higher.
  uint16 immutable s_requestConfirmations = 3;

  // For this example, retrieve 2 random values in one request.
  // Cannot exceed VRFCoordinatorV2.MAX_NUM_WORDS.
  uint32 immutable s_numWords = 2;

  uint256[] public s_randomWords;
  uint256 public s_requestId;
  address s_owner;

  event ReturnedRandomness1_endFunding(uint256 requestId);
  event ReturnedRandomness2_withdraw(uint256 requestId);
  event ReturnedRandomness3_fulfill(uint256 requestId);

    /**
   * @notice Constructor inherits VRFConsumerBaseV2
   *
   * @param subscriptionId - the subscription ID that this contract uses for funding requests
   * @param vrfCoordinator - coordinator
   * @param keyHash - the gas lane to use, which specifies the maximum gas price to bump to
   */
    constructor(
    address _priceFeedAddress,
    uint64 subscriptionId,
    address vrfCoordinator,
    address link,
    bytes32 keyHash
  ) VRFConsumerBaseV2(vrfCoordinator) payable{
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        LINKTOKEN = LinkTokenInterface(link);
        s_keyHash = keyHash;
        s_owner = msg.sender;
        s_subscriptionId = subscriptionId;

        usdEntryFee = MINIMUM_ENTRY_FEE * (10**18);
        ethUsdPriceFeed = AggregatorV3Interface(_priceFeedAddress);
        funding_state = FUNDING_STATE.CLOSED;
  }
    function startFunding() external onlyOwner {
        require(
            funding_state == FUNDING_STATE.CLOSED,
            "Can't start a new fund yet! Current funding is not closed yet!"
        );
        funding_state = FUNDING_STATE.OPEN;
    }

    function fund() external payable {
        // $50 minimum

        require(funding_state == FUNDING_STATE.OPEN, "Can't fund yet.");
        require(msg.value >= this.getEntranceFee(), "Not enough ETH! Minimum $50 value of ETH require!");

        payers.push(payable(msg.sender));
    }

    function getETHprice() internal view returns (uint256) {
      
       (, int256 price, , , ) = ethUsdPriceFeed.latestRoundData();
        uint256 adjustedPrice = uint256(price) * 10**10; // 18 decimals
        return adjustedPrice;
    }

    // 1000000000
    function getETHpriceUSD() internal view returns (uint256) {
        uint256 ethPrice = getETHprice();
        uint256 ethAmountInUsd = ethPrice / 1000000000000000000;
        // the actual ETH/USD conversation rate, after adjusting the extra 0s.
        return ethAmountInUsd;
    }

    function getEntranceFee() external view returns (uint256) {

        uint256 adjustedPrice = getETHprice();

        // $50, $2,000 / ETH
        // 50/2,000
        // 50 * 100000 / 2000
        uint256 costToEnter = (usdEntryFee * 10**18) / adjustedPrice;
        return costToEnter;
    }

    function getCurrentFundingState() external view returns (FUNDING_STATE) {
        return funding_state;
    }

    function getUsersTotalAmount() external view returns (uint256) {
        return uint256(address(this).balance);
    }

   /* function getUserAmount(address user) public view returns (uint256) {
        return payable(payers[user]).balance;
    }
    */

    function endFunding() external onlyOwner {
        require(funding_state == FUNDING_STATE.OPEN, "Funding is not opened yet.");
        funding_state = FUNDING_STATE.END;
      //  this.requestRandomWords();
       
        //funding_state = FUNDING_STATE.CLOSED;
      //  emit ReturnedRandomness1_endFunding(s_requestId);
    }

    function withdraw() external onlyOwner {
        
        require(
            funding_state == FUNDING_STATE.END,
            "Funding must be ended before withdraw!"
        );
        //require(address(this).balance > 0, "balance: 0");
        requestRandomWords();
       // payable(msg.sender).transfer(address(this).balance);
      //  payers = new address payable[](0);
      //  funding_state = FUNDING_STATE.CLOSED;
        emit ReturnedRandomness2_withdraw(s_requestId);
        funding_state = FUNDING_STATE.CLOSED;
    }

    function withdraw2() external onlyOwner {
        
        require(
            funding_state == FUNDING_STATE.END,
            "Funding must be ended before withdraw!"
        );
        payable(msg.sender).transfer(address(this).balance);
        payers = new address payable[](0);
        funding_state = FUNDING_STATE.CLOSED;
        emit ReturnedRandomness2_withdraw(s_requestId);
    }

    function updateFundingState(FUNDING_STATE _funding_state) external onlyOwner {
        funding_state = _funding_state;
    }

    /**
    * @notice Requests randomness
    * Assumes the subscription is funded sufficiently; "Words" refers to unit of data in Computer Science
     */
    function requestRandomWords() internal {
    // Will revert if subscription is not set and funded.
        s_requestId = COORDINATOR.requestRandomWords(
        s_keyHash,
        s_subscriptionId,
        s_requestConfirmations,
        s_callbackGasLimit,
        s_numWords
        );
    }

    /*
    * @notice Callback function used by VRF Coordinator
    *
    * @param requestId - id of the request
    * @param randomWords - array of random results from VRF Coordinator
    */
    function fulfillRandomWords(
    uint256, /* requestId */
    uint256[] memory randomWords
    ) internal override {
        emit ReturnedRandomness3_fulfill(s_requestId);
        s_randomWords = randomWords;

        payable(msg.sender).transfer(uint256(address(this).balance));
        payers = new address payable[](0);
        funding_state = FUNDING_STATE.CLOSED;
    }

  }