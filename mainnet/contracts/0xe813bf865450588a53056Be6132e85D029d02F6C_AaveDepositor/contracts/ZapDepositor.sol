// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.11;
pragma abicoder v2;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "contracts/interfaces/IERC20.sol";
import "contracts/interfaces/IDepositorRegistry.sol";

abstract contract ZapDepositor is Initializable, OwnableUpgradeable {
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;
    using SafeERC20Upgradeable for IERC20;

    uint256 internal constant MAX_UINT256 =
        0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

    IDepositorRegistry public depositorRegistry;
    EnumerableSetUpgradeable.AddressSet private tokens;

    event TokenAdded(address _token);
    event TokenRemoved(address _token);

    modifier onlyZaps() {
        require(
            depositorRegistry.isRegisteredZap(msg.sender),
            "ZapDepositor: Invalid caller"
        );
        _;
    }

    modifier tokenIsValid(address _token) {
        require(tokens.contains(_token), "ZapDepositor: invalid token address");
        _;
    }

    /**
     * @notice ZapDepositor initializer
     * @param _depositorRegistry the depositor registry
     */
    function initialize(IDepositorRegistry _depositorRegistry)
        public
        initializer
    {
        __Ownable_init();
        depositorRegistry = _depositorRegistry;
    }

    /**
     * @notice Deposit a defined underling in the depositor protocol
     * @param _token the token to deposit
     * @param _underlyingAmount the amount to deposit
     * @return the amount ibt generated and sent back to the caller
     */
    function depositInProtocol(address _token, uint256 _underlyingAmount)
        public
        virtual
        onlyZaps
        tokenIsValid(_token)
        returns (uint256)
    {}

    /**
     * @notice Deposit a defined underling in the depositor protocol from the caller adderss
     * @param _token the token to deposit
     * @param _underlyingAmount the amount to deposit
     * @param _from the address from which the underlying need to be pulled
     * @return the amount ibt generated
     */
    function depositInProtocolFrom(
        address _token,
        uint256 _underlyingAmount,
        address _from
    ) public virtual onlyZaps tokenIsValid(_token) returns (uint256) {}

    /**
     * @notice Add a token to the depositor's list of underlyings
     * @param _token the token to add
     */
    function addToken(address _token) external onlyOwner {
        require(tokens.add(_token), "ZapDepositor: token already added");
        emit TokenAdded(_token);
    }

    /**
     * @notice Remove a token from the depositor's list of underlyings
     * @param _token the token to remove
     */
    function removeToken(address _token) external onlyOwner {
        require(tokens.add(_token), "ZapDepositor: invalid token address");
        emit TokenRemoved(_token);
    }

    /**
     * @notice Getter for the length of the token list
     * @return the length of the list
     */
    function getTokensLength() external view returns (uint256) {
        return tokens.length();
    }

    /**
     * @notice Getter for a particular token address of the list
     * @param _index the index of the token to get the address of
     * @return the address of the token
     */
    function getTokensAt(uint256 _index) external view returns (address) {
        return tokens.at(_index);
    }
}
