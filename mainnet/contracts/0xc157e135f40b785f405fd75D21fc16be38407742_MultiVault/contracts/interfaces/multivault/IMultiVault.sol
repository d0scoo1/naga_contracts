// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.2;

import "../IEverscale.sol";


interface IMultiVault is IEverscale {
    enum Fee { Deposit, Withdraw }
    enum TokenType { Native, Alien }

    struct TokenMeta {
        string name;
        string symbol;
        uint8 decimals;
    }

    struct Token {
        uint activation;
        bool blacklisted;
        uint depositFee;
        uint withdrawFee;
        bool isNative;
    }

    struct NativeWithdrawalParams {
        EverscaleAddress native;
        TokenMeta meta;
        uint256 amount;
        address recipient;
        uint256 chainId;
    }

    struct AlienWithdrawalParams {
        address token;
        uint256 amount;
        address recipient;
        uint256 chainId;
    }

    function defaultDepositFee() external view returns (uint);
    function defaultWithdrawFee() external view returns (uint);

    function apiVersion() external view returns (string memory api_version);

    function initialize(
        address _bridge,
        address _governance,
        EverscaleAddress memory _rewards
    ) external;

    function tokens(address _token) external view returns (Token memory);
    function natives(address _token) external view returns (EverscaleAddress memory);

    function blacklistAddToken(address token) external;
    function blacklistRemoveToken(address token) external;

    function setTokenDepositFee(address token, uint _depositFee) external;
    function setTokenWithdrawFee(address token, uint _withdrawFee) external;

    function setDefaultDepositFee(uint _defaultDepositFee) external;
    function setDefaultWithdrawFee(uint _defaultWithdrawFee) external;

    function rewards() external view returns (EverscaleAddress memory);
    function configuration() external view returns (EverscaleAddress memory);
    function withdrawalIds(bytes32) external view returns (bool);
    function bridge() external view returns(address);

    function governance() external view returns (address);
    function guardian() external view returns (address);
    function management() external view returns (address);

    function emergencyShutdown() external view returns (bool);
    function setEmergencyShutdown(bool active) external;

    function setConfiguration(EverscaleAddress memory _configuration) external;
    function setGovernance(address _governance) external;
    function acceptGovernance() external;
    function setGuardian(address _guardian) external;
    function setManagement(address _management) external;
    function setRewards(EverscaleAddress memory _rewards) external;

    function deposit(
        EverscaleAddress memory recipient,
        address token,
        uint amount
    ) external;

    function saveWithdrawNative(
        bytes memory payload,
        bytes[] memory signatures
    ) external;

    function saveWithdrawAlien(
        bytes memory payload,
        bytes[] memory signatures
    ) external;

    function migrateAlienTokenToVault(
        address token,
        address vault
    ) external;

    event BlacklistTokenAdded(address token);
    event BlacklistTokenRemoved(address token);

    event UpdateDefaultDepositFee(uint fee);
    event UpdateDefaultWithdrawFee(uint fee);

    event UpdateBridge(address bridge);
    event UpdateConfiguration(int128 wid, uint256 addr);
    event UpdateRewards(int128 wid, uint256 addr);

    event UpdateTokenDepositFee(address token, uint256 fee);
    event UpdateTokenWithdrawFee(address token, uint256 fee);

    event UpdateGovernance(address governance);
    event UpdateManagement(address management);
    event NewPendingGovernance(address governance);
    event UpdateGuardian(address guardian);

    event EmergencyShutdown(bool active);

    event TokenMigrated(address token, address vault);

    event TokenActivated(
        address token,
        uint activation,
        bool isNative,
        uint depositFee,
        uint withdrawFee
    );

    event TokenCreated(
        address token,
        int8 native_wid,
        uint256 native_addr,
        string name,
        string symbol,
        uint8 decimals
    );

    event AlienTransfer(
        uint256 base_chainId,
        uint160 base_token,
        string name,
        string symbol,
        uint8 decimals,
        uint256 amount,
        int8 recipient_wid,
        uint256 recipient_addr
    );

    event NativeTransfer(
        int8 native_wid,
        uint256 native_addr,
        uint256 amount,
        int8 recipient_wid,
        uint256 recipient_addr
    );

    event Deposit(
        TokenType _type,
        address sender,
        address token,
        int8 recipient_wid,
        uint256 recipient_addr,
        uint256 amount,
        uint256 fee
    );

    event Withdraw(
        TokenType _type,
        bytes32 payloadId,
        address token,
        address recipient,
        uint256 amunt,
        uint256 fee
    );
}