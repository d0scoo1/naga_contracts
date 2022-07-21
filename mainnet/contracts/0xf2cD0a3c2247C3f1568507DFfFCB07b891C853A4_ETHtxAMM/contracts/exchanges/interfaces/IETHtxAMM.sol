// SPDX-License-Identifier: Apache-2.0

/**
 * Copyright 2021-2022 weiWard LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

pragma solidity 0.7.6;

interface IETHtxAMM {
	/* Views */

	function ethmx() external view returns (address);

	function weth() external view returns (address);

	/* Mutators */

	function burnETHmx(uint256 amountIn, bool asWETH) external;

	function pause() external;

	function recoverUnsupportedERC20(
		address token,
		address to,
		uint256 amount
	) external;

	function unpause() external;

	/* Events */

	event BurnedETHmx(address indexed author, uint256 amount);
	event RecoveredUnsupported(
		address indexed author,
		address indexed token,
		address indexed to,
		uint256 amount
	);
}
