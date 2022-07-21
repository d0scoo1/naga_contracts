// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.9;

import "./libraries/LibAppStorage.sol";
import "../shared/libraries/LibDiamond.sol";
import "../token/PilgrimToken.sol";
import "../token/XPilgrim.sol";

struct Args {
    address pilgrim;
    address xPilgrim;
    uint32 lockupPeriod;
    uint32 subsidizationNumerator;
    uint32 subsidizationDenominator;
}

contract InitDiamond {
    AppStorage internal s;

    function init(Args memory _args) external {
        s.lockupPeriod = _args.lockupPeriod;
        s.pilgrim = PilgrimToken(_args.pilgrim);
        s.xPilgrim = XPilgrim(_args.xPilgrim);
        s.subsidizationNumerator = _args.subsidizationNumerator;
        s.subsidizationDenominator = _args.subsidizationDenominator;

        LibDiamond.diamondStorage();
    }
}
