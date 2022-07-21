// SPDX-License-Identifier: AGPL-3.0
pragma solidity >=0.8.10;

import {EnumerableMap} from "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";

import "./types/OlympusAccessControlled.sol";
import "./interfaces/IOlympusAuthority.sol";
import "./interfaces/IOlympusPro.sol";
import "./interfaces/ITreasury.sol";
import "./interfaces/IERC20.sol";
import "./interfaces/IOHM.sol";

contract OlympusProMarketCreator is OlympusAccessControlled {
    using EnumerableMap for EnumerableMap.UintToAddressMap;

    IOlympusPro public depository;
    ITreasury public treasury;
    IOHM public ohm;

    EnumerableMap.UintToAddressMap private markets;

    constructor(IOHM _ohm, ITreasury _treasury, IOlympusPro _depository, IOlympusAuthority _authority)
        OlympusAccessControlled(_authority)
    {
        ohm = _ohm;
        treasury = _treasury;
        depository = _depository;
    }

    // creates a market selling lusd for ohm
    // bonds have no vesting (executes an instant swap)
    // see IProMarketCreator for _market and _intervals arguments
    // _conclusion is concluding timestamp
    function create(
        IERC20 _token,
        uint256[4] memory _market, 
        uint32[2] memory _intervals,
        uint256 _conclusion
    ) external onlyGovernor {
        IERC20[2] memory tokens = [_token, ohm];
        bool[2] memory booleans = [false, true];
        uint256[2] memory terms = [0, _conclusion];

        treasury.manage(address(_token), _market[0]);

        // approve tokens on depository and treasury (for return if needed)
        // add to the current allowances since there can be multiple markets
        _token.approve(address(depository), _market[0] + _token.allowance(address(this), address(depository)));
        _token.approve(address(treasury), _market[0] + _token.allowance(address(this), address(treasury)));

        uint256 id = depository.create(
            tokens, 
            _market, 
            booleans, 
            terms, 
            _intervals
        );

        markets.set(id, address(_token));
    }

    // Sets the treasury address to call manage on
    function setTreasury(address _treasury) external onlyGovernor {
        treasury = ITreasury(_treasury);
    }

    // halt all markets by revoking approval
    function halt(uint256 _id) external onlyGovernor {
        IERC20 token = IERC20(markets.get(_id));
        token.approve(address(depository), 0);
    }

    // close a market 
    function close(uint256 _id) external onlyGovernor {
        markets.remove(_id);
        depository.close(_id);
    }

    // burn repurchased ohm
    function burn() external onlyGovernor {
        ohm.burn(ohm.balanceOf(address(this)));
    }

    // return the rest of the tokens in this contract
    function returnReserve(address _token, uint256 amount) external onlyGovernor {
        treasury.deposit(amount, _token, treasury.tokenValue(_token, amount));
    }

    // function to get all active markets created by this contract
    function getMarkets() external view returns (uint256[] memory, address[] memory) {
        uint256 length = markets.length();
        uint256[] memory activeMarketIds = new uint256[](length);
        address[] memory activeMarketTokens = new address[](length);

        for (uint256 i = 0; i < length; i++) {
            (activeMarketIds[i], activeMarketTokens[i]) = markets.at(i);
        }

        return (activeMarketIds, activeMarketTokens);
    }
}