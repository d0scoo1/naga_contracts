// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.11;
pragma abicoder v2;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "contracts/interfaces/IZapDepositor.sol";
import "contracts/interfaces/IAMM.sol";
import "contracts/interfaces/IAMMRegistry.sol";

interface IDepositorRegistry {
    event ZapDepositorSet(address _amm, IZapDepositor _zapDepositor);

    function ZapDepositorsPerAMM(address _address)
        external
        view
        returns (IZapDepositor);

    function registry() external view returns (IAMMRegistry);

    function setZapDepositor(address _amm, IZapDepositor _zapDepositor)
        external;

    function isRegisteredZap(address _zapAddress) external view returns (bool);

    function addZap(address _zapAddress) external returns (bool);

    function removeZap(address _zapAddress) external returns (bool);

    function zapLength() external view returns (uint256);

    function zapAt(uint256 _index) external view returns (address);
}
