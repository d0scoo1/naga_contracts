// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.10;

// types
import "../types/BaseAllocator.sol";

// interfaces
import "../interfaces/ITreasury.sol";
import "../interfaces/IERC20.sol";
import "../libraries/SafeERC20.sol";

interface IveFXS is IERC20 {
    function create_lock(uint256 _value, uint256 _unlock_time) external;

    function increase_amount(uint256 _value) external;

    function increase_unlock_time(uint256 _unlock_time) external;

    function locked(address _addr) external view returns (uint128, uint256);

    function locked__end(address _addr) external view returns (uint256);

    function withdraw() external;
}

interface IveFXSYieldDistributorV4 {
    function getYield() external returns (uint256);

    function earned(address _address) external view returns (uint256);

    function checkpointOtherUser(address _address) external;
}

error FxsAllocator_InvalidAddress();

contract FxsAllocatorV2 is BaseAllocator {
    using SafeERC20 for IERC20;

    uint256 private constant MAX_TIME = 4 * 365 * 86400 + 1; // 4 years and 1 second
    ITreasury public treasury;
    IveFXS public veFXS;
    IveFXSYieldDistributorV4 public veFXSYieldDistributorV4;

    uint256 public lockEnd;

    constructor(
        AllocatorInitData memory data,
        address treasury_,
        address veFXS_,
        address veFXSYieldDistributorV4_
    ) BaseAllocator(data) {
        if (treasury_ == address(0) || veFXS_ == address(0) || veFXSYieldDistributorV4_ == address(0))
            revert FxsAllocator_InvalidAddress();

        treasury = ITreasury(treasury_);
        veFXS = IveFXS(veFXS_);
        veFXSYieldDistributorV4 = IveFXSYieldDistributorV4(veFXSYieldDistributorV4_);

        IERC20(data.tokens[0]).approve(address(veFXS), type(uint256).max);
    }

    /*************************************
     * Allocator Operational Functions
     *************************************/

    function _update(uint256 id) internal override returns (uint128 gain, uint128 loss) {
        // Get FXS balance and quantity locked in veFXS
        uint256 balance = _tokens[0].balanceOf(address(this));
        (uint256 veBalance, ) = veFXS.locked(address(this));

        // If we have FXS and none locked, create a new lock
        if (balance > 0 && veBalance == 0) {
            lockEnd = block.timestamp + MAX_TIME;

            veFXS.create_lock(balance, lockEnd);

            // This registers the deposit so we can claim yield in the future
            veFXSYieldDistributorV4.checkpointOtherUser(address(this));

            // Otherwise get current yield, and increase lock
        } else if (balance > 0 || veBalance > 0) {
            uint256 amount = veFXSYieldDistributorV4.getYield();
            if (balance + amount > 0) {
                veFXS.increase_amount(balance + amount);
                if (_canExtendLock()) {
                    lockEnd = block.timestamp + MAX_TIME;
                    veFXS.increase_unlock_time(lockEnd);
                }
            }
        }

        (veBalance, ) = veFXS.locked(address(this));
        uint256 last = extender.getAllocatorAllocated(id) + extender.getAllocatorPerformance(id).gain;

        if (veBalance >= last) gain = uint128(veBalance - last);
        else loss = uint128(last - veBalance);
    }

    function deallocate(uint256[] memory amounts) public override {
        _onlyGuardian();
        veFXSYieldDistributorV4.getYield();

        // If lock is up, claim FXS out of veFXS
        if (block.timestamp >= veFXS.locked__end(address(this))) {
            veFXS.withdraw();
        }
    }

    function _deactivate(bool panic) internal override {
        uint256[] memory amounts = new uint256[](1);
        deallocate(amounts);

        if (panic) {
            _tokens[0].transfer(address(treasury), _tokens[0].balanceOf(address(this)));
        }
    }

    function _prepareMigration() internal override {
        uint256[] memory amounts = new uint256[](1);
        deallocate(amounts);
    }

    /************************
     * View Functions
     ************************/

    function amountAllocated(uint256 id) public view override returns (uint256) {
        (uint256 amount, ) = veFXS.locked(address(this));
        uint256 fxsBalance = _tokens[0].balanceOf(address(this));
        return amount + fxsBalance;
    }

    function rewardTokens() public view override returns (IERC20[] memory) {
        IERC20[] memory rewards = new IERC20[](1);
        rewards[0] = _tokens[0];
        return rewards;
    }

    // Can't put veFXS in here as it's not transferable and thus would break
    // BaseAllocator's migrate function
    function utilityTokens() public view override returns (IERC20[] memory) {
        IERC20[] memory empty = new IERC20[](0);
        return empty;
    }

    function name() external view override returns (string memory) {
        return "FxsAllocatorV2";
    }

    /************************
     * Utility Functions
     ************************/

    function _canExtendLock() internal view returns (bool) {
        return lockEnd < block.timestamp + MAX_TIME - 7 * 86400;
    }
}
