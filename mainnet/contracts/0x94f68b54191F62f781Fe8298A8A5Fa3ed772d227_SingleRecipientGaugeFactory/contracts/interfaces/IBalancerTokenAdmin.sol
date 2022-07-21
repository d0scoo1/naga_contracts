// SPDX-License-Identifier: GPL-3.0-or-later
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity ^0.7.0;

import "@balancer-labs/v2-solidity-utils/contracts/helpers/IAuthentication.sol";
import "@balancer-labs/v2-vault/contracts/interfaces/IVault.sol";

import "./IBalancerToken.sol";

interface IBalancerTokenAdmin is IAuthentication {
    // solhint-disable func-name-mixedcase
    function INITIAL_RATE() external view returns (uint256);

    function RATE_REDUCTION_TIME() external view returns (uint256);

    function RATE_REDUCTION_COEFFICIENT() external view returns (uint256);

    function RATE_DENOMINATOR() external view returns (uint256);

    // solhint-enable func-name-mixedcase

    /**
     * @notice Returns the address of the Balancer Governance Token
     */
    function getBalancerToken() external view returns (IBalancerToken);

    /**
     * @notice Returns the Balancer Vault.
     */
    function getVault() external view returns (IVault);

    function activate() external;

    function rate() external view returns (uint256);

    function startEpochTimeWrite() external returns (uint256);

    function mint(address to, uint256 amount) external;
}
