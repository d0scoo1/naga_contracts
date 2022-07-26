// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import {Ownable2} from "../vendor/openzeppelin/contracts/access/Ownable2.sol";
import {MockProviderModule} from "./MockProviderModule.sol";
import {Address} from "../vendor/openzeppelin/contracts/utils/Address.sol";
import {GelatoString} from "../lib/GelatoString.sol";
import {
    IGelatoCore,
    Provider,
    Condition,
    Operation,
    DataFlow,
    Action,
    Task,
    TaskReceipt
} from "@gelatonetwork/core/contracts/gelato_core/interfaces/IGelatoCore.sol";
import {
    IGelatoProviders,
    TaskSpec
} from "@gelatonetwork/core/contracts/gelato_core/interfaces/IGelatoProviders.sol";
import {
    IGelatoProviderModule
} from "@gelatonetwork/core/contracts/gelato_provider_modules/IGelatoProviderModule.sol";

contract MockCheapTask is Ownable2, MockProviderModule {
    using Address for address payable;
    using GelatoString for string;

    // solhint-disable no-empty-blocks

    enum Log {ExecSuccess, ExecReverted, CanExecFailed}

    address public immutable gelatoCore;

    constructor(address _gelatoCore, address _executor) {
        gelatoCore = _gelatoCore;
        IGelatoProviderModule[] memory modules = new IGelatoProviderModule[](1);
        modules[0] = IGelatoProviderModule(this);
        try
            IGelatoProviders(_gelatoCore).multiProvide(
                _executor,
                new TaskSpec[](0),
                modules
            )
        {} catch {}
    }

    receive() external payable {
        require(
            msg.sender == gelatoCore,
            "MockCheapTask.receive:onlyGelatoCore"
        );
    }

    /// @dev only in case ETH gets stuck.
    function withdrawContractBalance() external onlyOwner {
        payable(msg.sender).sendValue(address(this).balance);
    }

    // solhint-disable-next-line function-max-lines
    function submitTask(
        Log _log,
        uint256 _selfProviderGasLimit,
        uint256 _selfProviderGasPriceCeil
    ) external {
        Provider memory provider =
            Provider({
                addr: address(this),
                module: IGelatoProviderModule(this)
            });

        bytes memory actionData;
        if (_log == Log.ExecSuccess)
            actionData = abi.encodeWithSelector(this.tAction.selector);
        else if (_log == Log.ExecReverted)
            actionData = abi.encodeWithSelector(this.tRevert.selector);

        Action memory action =
            Action({
                addr: address(this),
                data: actionData,
                operation: Operation.Call,
                dataFlow: DataFlow.None,
                value: 0,
                termsOkCheck: _log == Log.CanExecFailed ? true : false
            });

        Action[] memory actions = new Action[](1);
        actions[0] = action;

        Task memory task =
            Task({
                conditions: new Condition[](0),
                actions: actions,
                selfProviderGasLimit: _selfProviderGasLimit,
                selfProviderGasPriceCeil: _selfProviderGasPriceCeil
            });

        try
            IGelatoCore(gelatoCore).submitTask(provider, task, 0)
        {} catch Error(string memory error) {
            revert(
                string("MockCheapTask.submitTask.submitTask:").suffix(error)
            );
        } catch {
            revert("MockCheapTask.submitTask.submitTask:undefined");
        }
    }

    /// @dev Should trigger LogExecSuccess. This is what we pay for during execution
    function tAction() external {}

    /// @dev Should trigger LogExecReverted. This is what we pay for during execution
    function tRevert() external pure {
        revert("MockCheapTask.tRevert");
    }

    function multiProvide(
        address _executor,
        IGelatoProviderModule[] calldata _modules
    ) external payable onlyOwner {
        try
            IGelatoProviders(gelatoCore).multiProvide{value: msg.value}(
                _executor,
                new TaskSpec[](0),
                _modules
            )
        {} catch Error(string memory error) {
            revert(string("MockCheapTask.multiProvide:").suffix(error));
        } catch {
            revert("MockCheapTask.multiProvide:undefined");
        }
    }

    function unprovideFunds(uint256 _amount) external onlyOwner {
        try IGelatoProviders(gelatoCore).unprovideFunds(_amount) returns (
            uint256 withdrawAmount
        ) {
            payable(msg.sender).sendValue(withdrawAmount);
        } catch Error(string memory error) {
            revert(string("MockCheapTask.unprovideFunds:").suffix(error));
        } catch {
            revert("MockCheapTask.unprovideFunds:undefined");
        }
    }

    function provideFunds() public payable {
        try
            IGelatoProviders(gelatoCore).provideFunds{value: msg.value}(
                address(this)
            )
        {} catch Error(string memory error) {
            revert(string("MockCheapTask.provideFunds:").suffix(error));
        } catch {
            revert("MockCheapTask.provideFunds:undefined");
        }
    }

    function termsOk(
        uint256, // taskReceipId
        address,
        bytes calldata,
        DataFlow,
        uint256, // value
        uint256 // cycleId
    ) public view returns (string memory) {
        if (gasleft() > 700000) return "OK";
        else revert("MockCheapTask.termsOk: test revert");
    }

    function cancelTask(TaskReceipt memory _taskReceipt)
        external
        payable
        onlyOwner
    {
        try IGelatoCore(gelatoCore).cancelTask(_taskReceipt) {} catch Error(
            string memory error
        ) {
            revert(string("MockCheapTask.cancelTask:").suffix(error));
        } catch {
            revert("MockCheapTask.cancelTask:undefined");
        }
    }
}
