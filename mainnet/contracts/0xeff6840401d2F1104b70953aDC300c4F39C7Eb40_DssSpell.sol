// hevm: flattened sources of src/DssSpell.sol
// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity =0.6.12 >=0.5.12 >=0.6.12 <0.7.0;
pragma experimental ABIEncoderV2;

////// lib/dss-exec-lib/src/CollateralOpts.sol
/* pragma solidity ^0.6.12; */

struct CollateralOpts {
    bytes32 ilk;
    address gem;
    address join;
    address clip;
    address calc;
    address pip;
    bool    isLiquidatable;
    bool    isOSM;
    bool    whitelistOSM;
    uint256 ilkDebtCeiling;
    uint256 minVaultAmount;
    uint256 maxLiquidationAmount;
    uint256 liquidationPenalty;
    uint256 ilkStabilityFee;
    uint256 startingPriceFactor;
    uint256 breakerTolerance;
    uint256 auctionDuration;
    uint256 permittedDrop;
    uint256 liquidationRatio;
    uint256 kprFlatReward;
    uint256 kprPctReward;
}

////// lib/dss-exec-lib/src/DssExecLib.sol
//
// DssExecLib.sol -- MakerDAO Executive Spellcrafting Library
//
// Copyright (C) 2020 Maker Ecosystem Growth Holdings, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
/* pragma solidity ^0.6.12; */
/* pragma experimental ABIEncoderV2; */

/* import { CollateralOpts } from "./CollateralOpts.sol"; */

interface Initializable {
    function init(bytes32) external;
}

interface Authorizable {
    function rely(address) external;
    function deny(address) external;
}

interface Fileable {
    function file(bytes32, address) external;
    function file(bytes32, uint256) external;
    function file(bytes32, bytes32, uint256) external;
    function file(bytes32, bytes32, address) external;
}

interface Drippable {
    function drip() external returns (uint256);
    function drip(bytes32) external returns (uint256);
}

interface Pricing {
    function poke(bytes32) external;
}

interface ERC20 {
    function decimals() external returns (uint8);
}

interface DssVat {
    function hope(address) external;
    function nope(address) external;
    function ilks(bytes32) external returns (uint256 Art, uint256 rate, uint256 spot, uint256 line, uint256 dust);
    function Line() external view returns (uint256);
    function suck(address, address, uint) external;
}

interface ClipLike {
    function vat() external returns (address);
    function dog() external returns (address);
    function spotter() external view returns (address);
    function calc() external view returns (address);
    function ilk() external returns (bytes32);
}

interface DogLike {
    function ilks(bytes32) external returns (address clip, uint256 chop, uint256 hole, uint256 dirt);
}

interface JoinLike {
    function vat() external returns (address);
    function ilk() external returns (bytes32);
    function gem() external returns (address);
    function dec() external returns (uint256);
    function join(address, uint) external;
    function exit(address, uint) external;
}

// Includes Median and OSM functions
interface OracleLike_2 {
    function src() external view returns (address);
    function lift(address[] calldata) external;
    function drop(address[] calldata) external;
    function setBar(uint256) external;
    function kiss(address) external;
    function diss(address) external;
    function kiss(address[] calldata) external;
    function diss(address[] calldata) external;
    function orb0() external view returns (address);
    function orb1() external view returns (address);
}

interface MomLike {
    function setOsm(bytes32, address) external;
    function setPriceTolerance(address, uint256) external;
}

interface RegistryLike {
    function add(address) external;
    function xlip(bytes32) external view returns (address);
}

// https://github.com/makerdao/dss-chain-log
interface ChainlogLike {
    function setVersion(string calldata) external;
    function setIPFS(string calldata) external;
    function setSha256sum(string calldata) external;
    function getAddress(bytes32) external view returns (address);
    function setAddress(bytes32, address) external;
    function removeAddress(bytes32) external;
}

interface IAMLike {
    function ilks(bytes32) external view returns (uint256,uint256,uint48,uint48,uint48);
    function setIlk(bytes32,uint256,uint256,uint256) external;
    function remIlk(bytes32) external;
    function exec(bytes32) external returns (uint256);
}

interface LerpFactoryLike {
    function newLerp(bytes32 name_, address target_, bytes32 what_, uint256 startTime_, uint256 start_, uint256 end_, uint256 duration_) external returns (address);
    function newIlkLerp(bytes32 name_, address target_, bytes32 ilk_, bytes32 what_, uint256 startTime_, uint256 start_, uint256 end_, uint256 duration_) external returns (address);
}

interface LerpLike {
    function tick() external returns (uint256);
}


library DssExecLib {

    /* WARNING

The following library code acts as an interface to the actual DssExecLib
library, which can be found in its own deployed contract. Only trust the actual
library's implementation.

    */

    address constant public LOG = 0xdA0Ab1e0017DEbCd72Be8599041a2aa3bA7e740F;
    uint256 constant internal WAD      = 10 ** 18;
    uint256 constant internal RAY      = 10 ** 27;
    uint256 constant internal RAD      = 10 ** 45;
    uint256 constant internal THOUSAND = 10 ** 3;
    uint256 constant internal MILLION  = 10 ** 6;
    uint256 constant internal BPS_ONE_PCT             = 100;
    uint256 constant internal BPS_ONE_HUNDRED_PCT     = 100 * BPS_ONE_PCT;
    uint256 constant internal RATES_ONE_HUNDRED_PCT   = 1000000021979553151239153027;
    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {}
    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {}
    function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {}
    function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {}
    function dai()        public view returns (address) { return getChangelogAddress("MCD_DAI"); }
    function vat()        public view returns (address) { return getChangelogAddress("MCD_VAT"); }
    function cat()        public view returns (address) { return getChangelogAddress("MCD_CAT"); }
    function dog()        public view returns (address) { return getChangelogAddress("MCD_DOG"); }
    function jug()        public view returns (address) { return getChangelogAddress("MCD_JUG"); }
    function pot()        public view returns (address) { return getChangelogAddress("MCD_POT"); }
    function vow()        public view returns (address) { return getChangelogAddress("MCD_VOW"); }
    function end()        public view returns (address) { return getChangelogAddress("MCD_END"); }
    function esm()        public view returns (address) { return getChangelogAddress("MCD_ESM"); }
    function reg()        public view returns (address) { return getChangelogAddress("ILK_REGISTRY"); }
    function spotter()    public view returns (address) { return getChangelogAddress("MCD_SPOT"); }
    function osmMom()     public view returns (address) { return getChangelogAddress("OSM_MOM"); }
    function clipperMom() public view returns (address) { return getChangelogAddress("CLIPPER_MOM"); }
    function autoLine()   public view returns (address) { return getChangelogAddress("MCD_IAM_AUTO_LINE"); }
    function daiJoin()    public view returns (address) { return getChangelogAddress("MCD_JOIN_DAI"); }
    function lerpFab()    public view returns (address) { return getChangelogAddress("LERP_FAB"); }
    function clip(bytes32 _ilk) public view returns (address _clip) {}
    function flip(bytes32 _ilk) public view returns (address _flip) {}
    function calc(bytes32 _ilk) public view returns (address _calc) {}
    function getChangelogAddress(bytes32 _key) public view returns (address) {}
    function setChangelogAddress(bytes32 _key, address _val) public {}
    function setChangelogVersion(string memory _version) public {}
    function authorize(address _base, address _ward) public {}
    function canCast(uint40 _ts, bool _officeHours) public pure returns (bool) {}
    function nextCastTime(uint40 _eta, uint40 _ts, bool _officeHours) public pure returns (uint256 castTime) {}
    function updateCollateralPrice(bytes32 _ilk) public {}
    function setContract(address _base, bytes32 _what, address _addr) public {}
    function setContract(address _base, bytes32 _ilk, bytes32 _what, address _addr) public {}
    function setValue(address _base, bytes32 _what, uint256 _amt) public {}
    function setValue(address _base, bytes32 _ilk, bytes32 _what, uint256 _amt) public {}
    function increaseGlobalDebtCeiling(uint256 _amount) public {}
    function setIlkDebtCeiling(bytes32 _ilk, uint256 _amount) public {}
    function setIlkAutoLineParameters(bytes32 _ilk, uint256 _amount, uint256 _gap, uint256 _ttl) public {}
    function setIlkAutoLineDebtCeiling(bytes32 _ilk, uint256 _amount) public {}
    function setIlkMinVaultAmount(bytes32 _ilk, uint256 _amount) public {}
    function setIlkLiquidationPenalty(bytes32 _ilk, uint256 _pct_bps) public {}
    function setIlkMaxLiquidationAmount(bytes32 _ilk, uint256 _amount) public {}
    function setIlkLiquidationRatio(bytes32 _ilk, uint256 _pct_bps) public {}
    function setStartingPriceMultiplicativeFactor(bytes32 _ilk, uint256 _pct_bps) public {}
    function setAuctionTimeBeforeReset(bytes32 _ilk, uint256 _duration) public {}
    function setAuctionPermittedDrop(bytes32 _ilk, uint256 _pct_bps) public {}
    function setKeeperIncentivePercent(bytes32 _ilk, uint256 _pct_bps) public {}
    function setKeeperIncentiveFlatRate(bytes32 _ilk, uint256 _amount) public {}
    function setLiquidationBreakerPriceTolerance(address _clip, uint256 _pct_bps) public {}
    function setIlkStabilityFee(bytes32 _ilk, uint256 _rate, bool _doDrip) public {}
    function setStairstepExponentialDecrease(address _calc, uint256 _duration, uint256 _pct_bps) public {}
    function whitelistOracleMedians(address _oracle) public {}
    function addReaderToWhitelist(address _oracle, address _reader) public {}
    function addReaderToWhitelistCall(address _oracle, address _reader) public {}
    function allowOSMFreeze(address _osm, bytes32 _ilk) public {}
    function addCollateralBase(
        bytes32 _ilk,
        address _gem,
        address _join,
        address _clip,
        address _calc,
        address _pip
    ) public {}
    function addNewCollateral(CollateralOpts memory co) public {}
    function sendPaymentFromSurplusBuffer(address _target, uint256 _amount) public {}
    function linearInterpolation(bytes32 _name, address _target, bytes32 _what, uint256 _startTime, uint256 _start, uint256 _end, uint256 _duration) public returns (address) {}
    function linearInterpolation(bytes32 _name, address _target, bytes32 _ilk, bytes32 _what, uint256 _startTime, uint256 _start, uint256 _end, uint256 _duration) public returns (address) {}
}

////// lib/dss-exec-lib/src/DssAction.sol
//
// DssAction.sol -- DSS Executive Spell Actions
//
// Copyright (C) 2020 Maker Ecosystem Growth Holdings, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

/* pragma solidity ^0.6.12; */

/* import { DssExecLib } from "./DssExecLib.sol"; */
/* import { CollateralOpts } from "./CollateralOpts.sol"; */

interface OracleLike_1 {
    function src() external view returns (address);
}

abstract contract DssAction {

    using DssExecLib for *;

    // Modifier used to limit execution time when office hours is enabled
    modifier limited {
        require(DssExecLib.canCast(uint40(block.timestamp), officeHours()), "Outside office hours");
        _;
    }

    // Office Hours defaults to true by default.
    //   To disable office hours, override this function and
    //    return false in the inherited action.
    function officeHours() public virtual returns (bool) {
        return true;
    }

    // DssExec calls execute. We limit this function subject to officeHours modifier.
    function execute() external limited {
        actions();
    }

    // DssAction developer must override `actions()` and place all actions to be called inside.
    //   The DssExec function will call this subject to the officeHours limiter
    //   By keeping this function public we allow simulations of `execute()` on the actions outside of the cast time.
    function actions() public virtual;

    // Provides a descriptive tag for bot consumption
    // This should be modified weekly to provide a summary of the actions
    // Hash: seth keccak -- "$(wget https://<executive-vote-canonical-post> -q -O - 2>/dev/null)"
    function description() external virtual view returns (string memory);

    // Returns the next available cast time
    function nextCastTime(uint256 eta) external returns (uint256 castTime) {
        require(eta <= uint40(-1));
        castTime = DssExecLib.nextCastTime(uint40(eta), uint40(block.timestamp), officeHours());
    }
}

////// lib/dss-exec-lib/src/DssExec.sol
//
// DssExec.sol -- MakerDAO Executive Spell Template
//
// Copyright (C) 2020 Maker Ecosystem Growth Holdings, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

/* pragma solidity ^0.6.12; */

interface PauseAbstract {
    function delay() external view returns (uint256);
    function plot(address, bytes32, bytes calldata, uint256) external;
    function exec(address, bytes32, bytes calldata, uint256) external returns (bytes memory);
}

interface Changelog {
    function getAddress(bytes32) external view returns (address);
}

interface SpellAction {
    function officeHours() external view returns (bool);
    function description() external view returns (string memory);
    function nextCastTime(uint256) external view returns (uint256);
}

contract DssExec {

    Changelog      constant public log   = Changelog(0xdA0Ab1e0017DEbCd72Be8599041a2aa3bA7e740F);
    uint256                 public eta;
    bytes                   public sig;
    bool                    public done;
    bytes32       immutable public tag;
    address       immutable public action;
    uint256       immutable public expiration;
    PauseAbstract immutable public pause;

    // Provides a descriptive tag for bot consumption
    // This should be modified weekly to provide a summary of the actions
    // Hash: seth keccak -- "$(wget https://<executive-vote-canonical-post> -q -O - 2>/dev/null)"
    function description() external view returns (string memory) {
        return SpellAction(action).description();
    }

    function officeHours() external view returns (bool) {
        return SpellAction(action).officeHours();
    }

    function nextCastTime() external view returns (uint256 castTime) {
        return SpellAction(action).nextCastTime(eta);
    }

    // @param _description  A string description of the spell
    // @param _expiration   The timestamp this spell will expire. (Ex. now + 30 days)
    // @param _spellAction  The address of the spell action
    constructor(uint256 _expiration, address _spellAction) public {
        pause       = PauseAbstract(log.getAddress("MCD_PAUSE"));
        expiration  = _expiration;
        action      = _spellAction;

        sig = abi.encodeWithSignature("execute()");
        bytes32 _tag;                    // Required for assembly access
        address _action = _spellAction;  // Required for assembly access
        assembly { _tag := extcodehash(_action) }
        tag = _tag;
    }

    function schedule() public {
        require(now <= expiration, "This contract has expired");
        require(eta == 0, "This spell has already been scheduled");
        eta = now + PauseAbstract(pause).delay();
        pause.plot(action, tag, sig, eta);
    }

    function cast() public {
        require(!done, "spell-already-cast");
        done = true;
        pause.exec(action, tag, sig, eta);
    }
}

////// lib/dss-interfaces/src/dss/VestAbstract.sol
/* pragma solidity >=0.5.12; */

// https://github.com/makerdao/dss-vest/blob/master/src/DssVest.sol
interface VestAbstract {
    function TWENTY_YEARS() external view returns (uint256);
    function wards(address) external view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function awards(uint256) external view returns (address, uint48, uint48, uint48, address, uint8, uint128, uint128);
    function ids() external view returns (uint256);
    function cap() external view returns (uint256);
    function usr(uint256) external view returns (address);
    function bgn(uint256) external view returns (uint256);
    function clf(uint256) external view returns (uint256);
    function fin(uint256) external view returns (uint256);
    function mgr(uint256) external view returns (address);
    function res(uint256) external view returns (uint256);
    function tot(uint256) external view returns (uint256);
    function rxd(uint256) external view returns (uint256);
    function file(bytes32, uint256) external;
    function create(address, uint256, uint256, uint256, uint256, address) external returns (uint256);
    function vest(uint256) external;
    function vest(uint256, uint256) external;
    function accrued(uint256) external view returns (uint256);
    function unpaid(uint256) external view returns (uint256);
    function restrict(uint256) external;
    function unrestrict(uint256) external;
    function yank(uint256) external;
    function yank(uint256, uint256) external;
    function move(uint256, address) external;
    function valid(uint256) external view returns (bool);
}

////// src/DssSpell.sol
//
// Copyright (C) 2021 Dai Foundation
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

/* pragma solidity 0.6.12; */
/* pragma experimental ABIEncoderV2; */

/* import "dss-exec-lib/DssExec.sol"; */
/* import "dss-exec-lib/DssAction.sol"; */
/* import "dss-interfaces/dss/VestAbstract.sol"; */

contract DssSpellAction is DssAction {
    // Provides a descriptive tag for bot consumption
    // This should be modified weekly to provide a summary of the actions
    // Hash: seth keccak -- "$(wget https://raw.githubusercontent.com/makerdao/community/194592d74ae225132c1963527ae90190b8bfa476/governance/votes/Executive%20vote%20-%20November%2026,%202021.md -q -O - 2>/dev/null)"
    string public constant override description =
        "2021-11-26 MakerDAO Executive Spell | Hash: 0x7be806b3c9fa08603c0e25a1d73066384dcb0770407aeeb57668742321823d2c";

    // Many of the settings that change weekly rely on the rate accumulator
    // described at https://docs.makerdao.com/smart-contract-modules/rates-module
    // To check this yourself, use the following rate calculation (example 8%):
    //
    // $ bc -l <<< 'scale=27; e( l(1.08)/(60 * 60 * 24 * 365) )'
    //
    // A table of rates can be found at
    //    https://ipfs.io/ipfs/QmefQMseb3AiTapiAKKexdKHig8wroKuZbmLtPLv4u2YwW
    //

    // --- Rates ---
    uint256 constant ZERO_PCT_RATE            = 1000000000000000000000000000;
    uint256 constant ONE_FIVE_PCT_RATE        = 1000000000472114805215157978;

    // --- Math ---
    uint256 constant MILLION                  = 10 ** 6;
    uint256 constant RAD                      = 10 ** 45;

    // --- WBTC-C ---
    address constant MCD_JOIN_WBTC_C          = 0x7f62f9592b823331E012D3c5DdF2A7714CfB9de2;
    address constant MCD_CLIP_WBTC_C          = 0x39F29773Dcb94A32529d0612C6706C49622161D1;
    address constant MCD_CLIP_CALC_WBTC_C     = 0x4fa2A328E7f69D023fE83454133c273bF5ACD435;

    // --- PSM-GUSD-A ---
    address constant MCD_JOIN_PSM_GUSD_A      = 0x79A0FA989fb7ADf1F8e80C93ee605Ebb94F7c6A5;
    address constant MCD_CLIP_PSM_GUSD_A      = 0xf93CC3a50f450ED245e003BFecc8A6Ec1732b0b2;
    address constant MCD_CLIP_CALC_PSM_GUSD_A = 0x7f67a68a0ED74Ea89A82eD9F243C159ed43a502a;
    address constant MCD_PSM_GUSD_A           = 0x204659B2Fd2aD5723975c362Ce2230Fba11d3900;

    // --- Wallets + Dates ---
    address constant SAS_WALLET     = 0xb1f950a51516a697E103aaa69E152d839182f6Fe;
    address constant IS_WALLET      = 0xd1F2eEf8576736C1EbA36920B957cd2aF07280F4;
    address constant DECO_WALLET    = 0xF482D1031E5b172D42B2DAA1b6e5Cbf6519596f7;
    address constant RWF_WALLET     = 0x9e1585d9CA64243CE43D42f7dD7333190F66Ca09;
    address constant COM_WALLET     = 0x1eE3ECa7aEF17D1e74eD7C447CcBA61aC76aDbA9;
    address constant MKT_WALLET     = 0xDCAF2C84e1154c8DdD3203880e5db965bfF09B60;

    uint256 constant DEC_01_2021    = 1638316800;
    uint256 constant DEC_31_2021    = 1640908800;
    uint256 constant JAN_01_2022    = 1640995200;
    uint256 constant APR_30_2022    = 1651276800;
    uint256 constant JUN_30_2022    = 1656547200;
    uint256 constant AUG_01_2022    = 1659312000;
    uint256 constant NOV_30_2022    = 1669766400;
    uint256 constant DEC_31_2022    = 1672444800;
    uint256 constant SEP_01_2024    = 1725148800;

    function actions() public override {
        address WBTC            = DssExecLib.getChangelogAddress("WBTC");
        address PIP_WBTC        = DssExecLib.getChangelogAddress("PIP_WBTC");
        address GUSD            = DssExecLib.getChangelogAddress("GUSD");
        address PIP_GUSD        = DssExecLib.getChangelogAddress("PIP_GUSD");
        address MCD_VEST_DAI    = DssExecLib.getChangelogAddress("MCD_VEST_DAI");

        //  Set Aave D3M Max Debt Ceiling
        //  https://vote.makerdao.com/polling/QmZhvNu5?network=mainnet#poll-detail
        DssExecLib.setIlkAutoLineDebtCeiling("DIRECT-AAVEV2-DAI", 100 * MILLION);

        //  Increase the Surplus Buffer via Lerp
        //  https://vote.makerdao.com/polling/QmUqfZRv?network=mainnet#poll-detail
        DssExecLib.linearInterpolation({
            _name:      "Increase SB - 20211126",
            _target:    DssExecLib.vow(),
            _what:      "hump",
            _startTime: block.timestamp,
            _start:     60 * MILLION * RAD,
            _end:       90 * MILLION * RAD,
            _duration:  210 days
        });

        //  Add WBTC-C as a new Vault Type
        //  https://vote.makerdao.com/polling/QmdVYMRo?network=mainnet#poll-detail
        DssExecLib.addNewCollateral(
            CollateralOpts({
                ilk:                   "WBTC-C",
                gem:                   WBTC,
                join:                  MCD_JOIN_WBTC_C,
                clip:                  MCD_CLIP_WBTC_C,
                calc:                  MCD_CLIP_CALC_WBTC_C,
                pip:                   PIP_WBTC,
                isLiquidatable:        true,
                isOSM:                 true,
                whitelistOSM:          true,
                ilkDebtCeiling:        100 * MILLION,
                minVaultAmount:        7500,
                maxLiquidationAmount:  25 * MILLION,
                liquidationPenalty:    1300,
                ilkStabilityFee:       ONE_FIVE_PCT_RATE,
                startingPriceFactor:   12000,
                breakerTolerance:      5000,
                auctionDuration:       90 minutes,
                permittedDrop:         4000,
                liquidationRatio:      17500,
                kprFlatReward:         300,
                kprPctReward:          10
            })
        );
        DssExecLib.setStairstepExponentialDecrease(MCD_CLIP_CALC_WBTC_C, 90 seconds, 9900);
        DssExecLib.setIlkAutoLineParameters("WBTC-C", 1000 * MILLION, 100 * MILLION, 8 hours);

        //  Add PSM-GUSD-A as a new Vault Type
        //  https://vote.makerdao.com/polling/QmayeEjz?network=mainnet#poll-detail
        DssExecLib.addNewCollateral(
            CollateralOpts({
                ilk:                   "PSM-GUSD-A",
                gem:                   GUSD,
                join:                  MCD_JOIN_PSM_GUSD_A,
                clip:                  MCD_CLIP_PSM_GUSD_A,
                calc:                  MCD_CLIP_CALC_PSM_GUSD_A,
                pip:                   PIP_GUSD,
                isLiquidatable:        false,
                isOSM:                 false,
                whitelistOSM:          false,
                ilkDebtCeiling:        10 * MILLION,
                minVaultAmount:        0,
                maxLiquidationAmount:  0,
                liquidationPenalty:    1300,
                ilkStabilityFee:       ZERO_PCT_RATE,
                startingPriceFactor:   10500,
                breakerTolerance:      9500, // Allows for a 5% hourly price drop before disabling liquidations
                auctionDuration:       220 minutes,
                permittedDrop:         9000,
                liquidationRatio:      10000,
                kprFlatReward:         300,
                kprPctReward:          10 // 0.1%
            })
        );
        DssExecLib.setStairstepExponentialDecrease(MCD_CLIP_CALC_PSM_GUSD_A, 120 seconds, 9990);
        DssExecLib.setIlkAutoLineParameters("PSM-GUSD-A", 10 * MILLION, 10 * MILLION, 24 hours);

        //  Core Unit Budget Distributions
        DssExecLib.sendPaymentFromSurplusBuffer(SAS_WALLET, 245_738);
        DssExecLib.sendPaymentFromSurplusBuffer(IS_WALLET, 195_443);
        DssExecLib.sendPaymentFromSurplusBuffer(DECO_WALLET, 465_625);

        VestAbstract(MCD_VEST_DAI).restrict(
            VestAbstract(MCD_VEST_DAI).create(RWF_WALLET, 1_860_000.00 * 10**18, JAN_01_2022, DEC_31_2022 - JAN_01_2022, 0, address(0))
        );
        VestAbstract(MCD_VEST_DAI).restrict(
            VestAbstract(MCD_VEST_DAI).create(COM_WALLET, 12_242.00 * 10**18, DEC_01_2021, DEC_31_2021 - DEC_01_2021, 0, address(0))
        );
        VestAbstract(MCD_VEST_DAI).restrict(
            VestAbstract(MCD_VEST_DAI).create(COM_WALLET, 257_500.00 * 10**18, JAN_01_2022, JUN_30_2022 - JAN_01_2022, 0, address(0))
        );
        VestAbstract(MCD_VEST_DAI).restrict(
            VestAbstract(MCD_VEST_DAI).create(SAS_WALLET, 1_130_393.00 * 10**18, DEC_01_2021, NOV_30_2022 - DEC_01_2021, 0, address(0))
        );
        VestAbstract(MCD_VEST_DAI).restrict(
            VestAbstract(MCD_VEST_DAI).create(IS_WALLET, 366_563.00 * 10**18, DEC_01_2021, AUG_01_2022 - DEC_01_2021, 0, address(0))
        );
        VestAbstract(MCD_VEST_DAI).restrict(
            VestAbstract(MCD_VEST_DAI).create(MKT_WALLET, 424_944.00 * 10**18, DEC_01_2021, APR_30_2022 - DEC_01_2021, 0, address(0))
        );
        VestAbstract(MCD_VEST_DAI).restrict(
            VestAbstract(MCD_VEST_DAI).create(DECO_WALLET, 5_121_875.00 * 10**18, DEC_01_2021, SEP_01_2024 - DEC_01_2021, 0, address(0))
        );

        // Changelog
        DssExecLib.setChangelogAddress("MCD_JOIN_WBTC_C", MCD_JOIN_WBTC_C);
        DssExecLib.setChangelogAddress("MCD_CLIP_WBTC_C", MCD_CLIP_WBTC_C);
        DssExecLib.setChangelogAddress("MCD_CLIP_CALC_WBTC_C", MCD_CLIP_CALC_WBTC_C);

        DssExecLib.setChangelogAddress("MCD_JOIN_PSM_GUSD_A", MCD_JOIN_PSM_GUSD_A);
        DssExecLib.setChangelogAddress("MCD_CLIP_PSM_GUSD_A", MCD_CLIP_PSM_GUSD_A);
        DssExecLib.setChangelogAddress("MCD_CLIP_CALC_PSM_GUSD_A", MCD_CLIP_CALC_PSM_GUSD_A);
        DssExecLib.setChangelogAddress("MCD_PSM_GUSD_A", MCD_PSM_GUSD_A);

        DssExecLib.setChangelogVersion("1.9.11");
    }
}

contract DssSpell is DssExec {
    constructor() DssExec(block.timestamp + 30 days, address(new DssSpellAction())) public {}
}

