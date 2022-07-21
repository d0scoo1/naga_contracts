// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./ReentrancyGuard.sol";
import "./TransferHelper.sol";
import "./Ownable.sol";

interface OracleWrapper {
    function latestAnswer() external view returns (uint128);
}

interface Token {
    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}

contract ReitPublicSale is Ownable, ReentrancyGuard {
    uint256 public totalTokenSold;
    uint256 public totalTokenSoldUSD;
    uint128 public decimalsValue;
    uint8 public totalPhases;
    uint8 public defaultPhase;
    address public tokenAddress;
    uint32 public ICOStartTime;

    address public BNBOracleAddress =
        0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;
    address public BUSDOracleAddress =
        0x3E7d1eAB13ad0104d2750B8863b489D65364e32D;
    address public BUSDAddress = 0xdAC17F958D2ee523a2206206994597C13D831ec7;

    address public receiverAddress = 0x783b966bC8049bf33D0A573B36127184aDE9C8A7;

    /* ============= STRUCT SECTION ============= */

    // Stores instances of Phases
    struct PhaseInfo {
        uint256 tokenSold;
        uint256 tokenLimit;
        uint32 expirationTimestamp;
        uint32 price; //10**2
        bool isComplete;
    }
    mapping(uint8 => PhaseInfo) public phaseInfo;

    /* ============= EVENT SECTION ============= */

    // Emits when tokens are bought
    event TokensBought(
        uint256 buyAmount,
        uint256 noOfTokens,
        uint8 tokenType,
        address userAddress
    );

    /* ============= CONSTRUCTOR SECTION ============= */

    constructor(address _tokenAddress) {
        tokenAddress = _tokenAddress;
        decimalsValue = uint128(10**Token(tokenAddress).decimals());
        ICOStartTime = uint32(block.timestamp);

        defaultPhase = 1;
        totalPhases = 4;

        phaseInfo[1] = PhaseInfo({
            tokenLimit: 1_000_000_000 * decimalsValue,
            tokenSold: 0,
            expirationTimestamp: ICOStartTime + 60 days,
            price: 5,
            isComplete: false
        });
        phaseInfo[2] = PhaseInfo({
            tokenLimit: 1_000_000_000 * decimalsValue,
            tokenSold: 0,
            expirationTimestamp: phaseInfo[1].expirationTimestamp + 15 days,
            price: 10,
            isComplete: false
        });
        phaseInfo[3] = PhaseInfo({
            tokenLimit: 1_000_000_000 * decimalsValue,
            tokenSold: 0,
            expirationTimestamp: phaseInfo[2].expirationTimestamp + 15 days,
            price: 15,
            isComplete: false
        });
        phaseInfo[4] = PhaseInfo({
            tokenLimit: 1_000_000_000 * decimalsValue,
            tokenSold: 0,
            expirationTimestamp: phaseInfo[3].expirationTimestamp + 15 days,
            price: 20,
            isComplete: false
        });
    }

    /* ============= BUY TOKENS SECTION ============= */

    function buyTokens(uint8 _type, uint256 _busdAmount)
        public
        payable
        nonReentrant
    {
        //_type=1 for BNB and type =2 for BUSD
        require(
            block.timestamp < phaseInfo[totalPhases].expirationTimestamp,
            "Buying Phases are over"
        );

        uint256 buyAmount;
        if (_type == 1) {
            buyAmount = msg.value;
        } else {
            buyAmount = _busdAmount;

            // Balance Check
            require(
                (Token(BUSDAddress).balanceOf(msg.sender)) >= buyAmount,
                "check your balance."
            );

            // Allowance Check
            require(
                Token(BUSDAddress).allowance(msg.sender, address(this)) >=
                    buyAmount,
                "Approve BUSD."
            );
        }

        // Zero value not possible
        require(buyAmount > 0, "Enter valid amount");

        // Calculates token amount
        (
            uint256 _tokenAmount,
            uint8 _phaseValue,
            uint256 _amountGivenInUsd
        ) = calculateTokens(_type, buyAmount);

        setPhaseInfo(_tokenAmount, defaultPhase);
        totalTokenSoldUSD += _amountGivenInUsd;
        totalTokenSold += _tokenAmount;
        defaultPhase = _phaseValue;

        // Transfers the tokens bought to the user
        TransferHelper.safeTransfer(tokenAddress, msg.sender, _tokenAmount);

        // Sending the amount to the receiver address
        if (_type == 1) {
            TransferHelper.safeTransferETH(receiverAddress, msg.value);
        } else {
            TransferHelper.safeTransferFrom(
                BUSDAddress,
                msg.sender,
                receiverAddress,
                buyAmount
            );
        }
        // Emits event
        emit TokensBought(buyAmount, _tokenAmount, _type, msg.sender);
    }

    /* ============= TOKEN CALCULATION SECTION ============= */
    // Calculates Tokens
    function calculateTokens(uint8 _type, uint256 _amount)
        public
        view
        returns (
            uint256,
            uint8,
            uint256
        )
    {
        (uint256 _amountToUSD, uint256 _typeDecimal) = cryptoValues(_type);
        uint256 _amountGivenInUsd = ((_amount * _amountToUSD) / _typeDecimal);
        (uint256 _tokenAmount, uint8 _phaseValue) = calculateTokensInternal(
            _amountGivenInUsd,
            defaultPhase,
            0
        );
        return (_tokenAmount, _phaseValue, _amountGivenInUsd);
    }

    // Internal Function to calculate tokens
    function calculateTokensInternal(
        uint256 _amount,
        uint8 _phaseNo,
        uint256 _previousTokens
    ) internal view returns (uint256, uint8) {
        // Phases cannot exceed totalPhases
        require(
            _phaseNo <= totalPhases,
            "Not enough tokens in the contract or Phase expired"
        );

        PhaseInfo memory pInfo = phaseInfo[_phaseNo];

        // If phase is still going on
        if (pInfo.expirationTimestamp > block.timestamp) {
            uint256 _tokensAmount = tokensUserWillGet(_amount, pInfo.price);

            uint256 _tokensLeftToSell = (pInfo.tokenLimit + _previousTokens) -
                pInfo.tokenSold;

            // If token left are 0. Next phase will be executed
            if (_tokensLeftToSell == 0) {
                return
                    calculateTokensInternal(
                        _amount,
                        _phaseNo + 1,
                        _previousTokens
                    );
            }
            // If the phase have enough tokens left
            else if (_tokensLeftToSell >= _tokensAmount) {
                return (_tokensAmount, _phaseNo);
            }
            // If the phase doesn't have enough tokens
            else {
                _tokensAmount =
                    pInfo.tokenLimit +
                    _previousTokens -
                    pInfo.tokenSold;

                uint256 _tokenPriceInPhase = tokenValueInPhase(
                    pInfo.price,
                    _tokensAmount
                );

                (
                    uint256 _remainingTokens,
                    uint8 _newPhase
                ) = calculateTokensInternal(
                        _amount - _tokenPriceInPhase,
                        _phaseNo + 1,
                        0
                    );

                return (_remainingTokens + _tokensAmount, _newPhase);
            }
        }
        // In case the phase is expired. New will begin after sending the left tokens to the next phase
        else {
            uint256 _remainingTokens = pInfo.tokenLimit - pInfo.tokenSold;
            return
                calculateTokensInternal(
                    _amount,
                    _phaseNo + 1,
                    _remainingTokens + _previousTokens
                );
        }
    }

    // Returns the value of tokens in the phase in dollors
    function tokenValueInPhase(uint32 _price, uint256 _tokenAmount)
        internal
        view
        returns (uint256)
    {
        return ((_tokenAmount * uint256(_price) * (10**8)) /
            (100 * decimalsValue));
    }

    // Calculate tokens user will get for an amount
    // **@ making this method public for testing
    // Tokens user will get according to the price
    function tokensUserWillGet(uint256 _amount, uint32 _price)
        public
        view
        returns (uint256)
    {
        return ((_amount * decimalsValue * 100) / ((10**8) * uint256(_price)));
    }

    // Returns the crypto values used
    function cryptoValues(uint8 _type)
        internal
        view
        returns (uint256, uint256)
    {
        uint128 _amountToUsd;
        uint128 _decimalValue;

        if (_type == 1) {
            _amountToUsd = OracleWrapper(BNBOracleAddress).latestAnswer();
            _decimalValue = 10**18;
        } else if (_type == 2) {
            _amountToUsd = OracleWrapper(BUSDOracleAddress).latestAnswer();
            _decimalValue = uint128(10**Token(BUSDAddress).decimals());
        }
        return (_amountToUsd, _decimalValue);
    }

    /* ============= SETS PHASE INFO SECTION ============= */

    // Updates phase struct instances according to the new tokens bought
    function setPhaseInfo(uint256 _totalTokens, uint8 _phase) internal {
        require(_phase <= totalPhases, "All phases have been exhausted");
        PhaseInfo storage pInfo = phaseInfo[_phase];

        if (block.timestamp < pInfo.expirationTimestamp) {
            // Case 1: Tokens left in the current phase are more than the tokens bought
            if ((pInfo.tokenLimit - pInfo.tokenSold) > _totalTokens) {
                pInfo.tokenSold += _totalTokens;
            }
            // Case 2: Tokens left in the current phase are equal to the tokens bought
            else if ((pInfo.tokenLimit - pInfo.tokenSold) == _totalTokens) {
                pInfo.tokenSold = pInfo.tokenLimit;
                pInfo.isComplete = true;
            }
            // Case 3: Tokens left in the current phase are less than the tokens bought (Recursion)
            else {
                uint256 _leftTokens = _totalTokens -
                    (pInfo.tokenLimit - pInfo.tokenSold);
                pInfo.tokenSold = pInfo.tokenLimit;
                pInfo.isComplete = true;

                setPhaseInfo(_leftTokens, _phase + 1);
            }
        } else {
            uint256 _remainingTokens = pInfo.tokenLimit - pInfo.tokenSold;
            pInfo.tokenLimit = pInfo.tokenSold;
            pInfo.isComplete = true;

            // Limit of next phase is increased
            phaseInfo[_phase + 1].tokenLimit += _remainingTokens;
            setPhaseInfo(_totalTokens, _phase + 1);
        }
    }

    /* ============= TRANSFER LEFTOVER TOKENS TO receiver SECTION ============= */

    // Transfers left over tokens to the receiver
    function transferToReceiverAfterICO() external onlyOwner {
        uint256 _contractBalance = Token(tokenAddress).balanceOf(address(this));

        // Phases should have ended
        require(
            (phaseInfo[totalPhases].expirationTimestamp < block.timestamp),
            "ICO is running."
        );

        // Balance should not already be claimed
        require(_contractBalance > 0, "Already Claimed.");

        // Transfers the left over tokens to the receiver
        TransferHelper.safeTransfer(
            tokenAddress,
            receiverAddress,
            _contractBalance
        );
    }

    /* ============= OTHER FUNCTION SECTION ============= */
    // Updates receiver address
    function updateReceiverAddress(address _receiverAddress)
        external
        onlyOwner
    {
        receiverAddress = _receiverAddress;
    }

    // Updates BUSD Address
    function updateBUSDAddress(address _BUSDAddress) external onlyOwner {
        BUSDAddress = _BUSDAddress;
    }

    // Updates BNB Oracle Address
    function updateBNBOracleAddress(address _BNBOracleAddress)
        external
        onlyOwner
    {
        BNBOracleAddress = _BNBOracleAddress;
    }

    // Updates BUSD Oracle Address
    function updateBUSDOracleAddress(address _BUSDOracleAddress)
        external
        onlyOwner
    {
        BUSDOracleAddress = _BUSDOracleAddress;
    }
}
