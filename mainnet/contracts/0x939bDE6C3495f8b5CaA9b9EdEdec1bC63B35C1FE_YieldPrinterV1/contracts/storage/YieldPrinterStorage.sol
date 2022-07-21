// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;
pragma experimental ABIEncoderV2;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {ILendingPool} from "../dependencies/aave/ILendingPool.sol";
import {Comptroller} from "../dependencies/compound/Comptroller.sol";
import {ILendingPoolAddressesProvider} from "../dependencies/aave/ILendingPoolAddressesProvider.sol";
import {StorageSlot} from "./StorageSlot.sol";

contract YieldPrinterStorage is Initializable {

    function initializeStorage(address _comptroller, address _lpAddressesProvider)  public initializer {
        ILendingPoolAddressesProvider addressesProvider = ILendingPoolAddressesProvider(_lpAddressesProvider);
        ILendingPool lendingPool = ILendingPool(addressesProvider.getLendingPool());
        StorageSlot.setAddressAt(keccak256("yieldprinter.comptroller"), _comptroller);
        StorageSlot.setAddressAt(keccak256("yieldprinter.lendingpool"), address(lendingPool));
    }

    function getLendingPool() public view returns (address) {
        return StorageSlot.getAddressAt(keccak256("yieldprinter.lendingpool"));
    }

    function getComptroller() public view returns (address) {
        return StorageSlot.getAddressAt(keccak256("yieldprinter.comptroller"));
    }
}