// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "./interfaces/IWETH.sol";
import "./interfaces/IERC20.sol";
import "./interfaces/IMorpho.sol";
import "./interfaces/ICompound.sol";
import "./interfaces/IERC3156FlashLender.sol";
import "./interfaces/IERC3156FlashBorrower.sol";

contract FlashMatchDai is IERC3156FlashBorrower {
    address public constant dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public constant cDai = 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643;
    IMorpho public constant morpho =
        IMorpho(0x8888882f8f843896699869179fB6E4f7e3B58888);
    IComptroller public constant comptroller =
        IComptroller(0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B);
    IERC3156FlashLender public constant lender =
        IERC3156FlashLender(0x1EB4CF3A948E7D72A198fe073cCb8C7a948cD853);

    constructor() {
        address[] memory cTokens = new address[](1);
        cTokens[0] = cDai;
        comptroller.enterMarkets(cTokens);
    }

    /// @dev ERC-3156 Flash loan callback
    function onFlashLoan(
        address initiator,
        address, // token = dai
        uint256 amount,
        uint256, // fee = 0
        bytes calldata data
    ) external override returns (bytes32) {
        require(msg.sender == address(lender), "FlashMatch: Untrusted lender");
        require(
            initiator == address(this),
            "FlashMatch: Untrusted loan initiator"
        );

        uint256 maxGasForMatching = abi.decode(data, (uint256));

        // supply on Morpho
        IERC20(dai).approve(address(morpho), amount);
        morpho.supply(cDai, address(this), amount, maxGasForMatching);
        // transfer withdraw on Morpho
        morpho.withdraw(cDai, type(uint256).max);

        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }

    /// @dev Match dai market on Morpho.
    ///     - initiate a DAI flash loan
    ///     - supply them into Morpho to match on pool borrowers
    ///     - withdraw to do a transfer withdraw, and match on pool suppliers.
    ///     - reimburse the flash loan
    /// @dev Send some DAI dust on the contract, to avoid revert because of
    /// Morpho rounding errors.
    /// @param amount the amount of token to supply.
    /// @param maxGasForMatching the `maxGasForMatching` to use for the supply.
    function flashMatchDai(uint256 amount, uint256 maxGasForMatching) public {
        bytes memory data = abi.encode(maxGasForMatching);
        require(lender.flashFee(dai, amount) == 0, "Flashloan is not free");
        IERC20(dai).approve(
            address(lender),
            IERC20(dai).allowance(address(this), address(lender)) + amount
        );
        lender.flashLoan(this, dai, amount, data);
    }
}
