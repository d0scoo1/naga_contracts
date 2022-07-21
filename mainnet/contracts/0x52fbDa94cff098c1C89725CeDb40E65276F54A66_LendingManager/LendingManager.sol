// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "Ownable.sol";
import "Math.sol";
import "ReentrancyGuard.sol";

import "IBasketFacet.sol";
import "ILendingRegistry.sol";

contract LendingManager is Ownable, ReentrancyGuard {
    using Math for uint256;

    ILendingRegistry public lendingRegistry;
    IBasketFacet public basket;

    event Lend(
        address indexed underlying,
        uint256 amount,
        bytes32 indexed protocol
    );
    event UnLend(address indexed wrapped, uint256 amount);

    /**
        @notice Constructor
        @param _lendingRegistry Address of the lendingRegistry contract
        @param _basket Address of the pool/pie/basket to manage
    */
    constructor(address _lendingRegistry, address _basket) {
        require(_lendingRegistry != address(0), "INVALID_LENDING_REGISTRY");
        require(_basket != address(0), "INVALID_BASKET");
        lendingRegistry = ILendingRegistry(_lendingRegistry);
        basket = IBasketFacet(_basket);
    }

    /**
        @notice Move underlying to a lending protocol
        @param _underlying Address of the underlying token
        @param _amount Amount of underlying to lend
        @param _protocol Bytes32 protocol key to lend to
    */
    function lend(
        address _underlying,
        uint256 _amount,
        bytes32 _protocol
    ) public onlyOwner nonReentrant {
        // _amount or actual balance, whatever is less
        uint256 amount = _amount.min(
            IERC20(_underlying).balanceOf(address(basket))
        );

        //lend token
        (address[] memory _targets, bytes[] memory _data) = lendingRegistry
            .getLendTXData(_underlying, amount, _protocol);

        basket.callNoValue(_targets, _data);

        // if needed remove underlying from basket
        removeToken(_underlying);

        // add wrapped token
        addToken(
            lendingRegistry.underlyingToProtocolWrapped(_underlying, _protocol)
        );

        emit Lend(_underlying, _amount, _protocol);
    }

    /**
        @notice Unlend wrapped token from its lending protocol
        @param _wrapped Address of the wrapped token
        @param _amount Amount of the wrapped token to unlend
    */
    function unlend(address _wrapped, uint256 _amount)
        public
        onlyOwner
        nonReentrant
    {
        // unlend token
        // _amount or actual balance, whatever is less
        uint256 amount = _amount.min(
            IERC20(_wrapped).balanceOf(address(basket))
        );

        //Unlend token
        (address[] memory _targets, bytes[] memory _data) = lendingRegistry
            .getUnlendTXData(_wrapped, amount);
        basket.callNoValue(_targets, _data);

        // if needed add underlying
        addToken(lendingRegistry.wrappedToUnderlying(_wrapped));

        // if needed remove wrapped
        removeToken(_wrapped);

        emit UnLend(_wrapped, _amount);
    }

    /**
        @notice Unlend and immediately lend in a different protocol
        @param _wrapped Address of the wrapped token to bounce to another protocol
        @param _amount Amount of the wrapped token to bounce to the other protocol
        @param _toProtocol Protocol to deposit bounced tokens in
        @dev Uses reentrency protection of unlend() and lend()
    */
    function bounce(
        address _wrapped,
        uint256 _amount,
        bytes32 _toProtocol
    ) external {
        unlend(_wrapped, _amount);
        // Bounce all to new protocol
        lend(
            lendingRegistry.wrappedToUnderlying(_wrapped),
            type(uint256).max,
            _toProtocol
        );
    }

    function removeToken(address _token) internal {
        uint256 balance = basket.balance(_token);
        bool inPool = basket.getTokenInPool(_token);
        //if there is a token balance of the token is not in the pool, skip
        if (balance != 0 || !inPool) {
            return;
        }

        // remove token
        basket.singleCall(
            address(basket),
            abi.encodeWithSelector(basket.removeToken.selector, _token),
            0
        );
    }

    function addToken(address _token) internal {
        uint256 balance = basket.balance(_token);
        bool inPool = basket.getTokenInPool(_token);
        // If token has no balance or is already in the pool, skip
        if (balance == 0 || inPool) {
            return;
        }

        // add token
        basket.singleCall(
            address(basket),
            abi.encodeWithSelector(basket.addToken.selector, _token),
            0
        );
    }
}
