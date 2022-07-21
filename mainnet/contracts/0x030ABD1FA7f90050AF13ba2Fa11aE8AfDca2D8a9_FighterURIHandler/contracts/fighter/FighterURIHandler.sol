// SPDX-License-Identifier: MIT

/// @title RaidParty Fighter URI Handler

/**
 *   ___      _    _ ___          _
 *  | _ \__ _(_)__| | _ \__ _ _ _| |_ _  _
 *  |   / _` | / _` |  _/ _` | '_|  _| || |
 *  |_|_\__,_|_\__,_|_| \__,_|_|  \__|\_, |
 *                                    |__/
 */

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "../utils/Enhanceable.sol";
import "../interfaces/IFighterURIHandler.sol";
import "../interfaces/IConfetti.sol";
import "../interfaces/IFighter.sol";

contract FighterURIHandler is
    IFighterURIHandler,
    Initializable,
    Enhanceable,
    AccessControlEnumerableUpgradeable
{
    using StringsUpgradeable for uint256;

    // Contract state and constants
    uint32 public constant MAX_DMG = 1400;
    uint32 public constant MIN_DMG = 800;
    uint8 public constant MAX_ENHANCEMENT = 14;
    uint8 public constant MIN_ENHANCEMENT = 0;

    mapping(uint8 => uint256) private _enhancementCosts;
    mapping(uint8 => uint256) private _enhancementOdds;
    mapping(uint8 => uint256) private _enhancementDegredationOdds;
    mapping(uint256 => uint8) private _enhancement;
    IConfetti private _confetti;
    address private _team;

    /** PUBLIC */

    function initialize(
        address admin,
        address seeder,
        address fighter,
        address confetti
    ) public initializer {
        __AccessControl_init();
        _setupRole(DEFAULT_ADMIN_ROLE, admin);
        __Enhanceable_init(seeder, fighter);
        _confetti = IConfetti(confetti);
        _team = admin;

        // Initialize enhancement costs
        _enhancementCosts[0] = 100 * 10**18;
        _enhancementCosts[1] = 125 * 10**18;
        _enhancementCosts[2] = 150 * 10**18;
        _enhancementCosts[3] = 175 * 10**18;
        _enhancementCosts[4] = 200 * 10**18;
        _enhancementCosts[5] = 250 * 10**18;
        _enhancementCosts[6] = 300 * 10**18;
        _enhancementCosts[7] = 400 * 10**18;
        _enhancementCosts[8] = 500 * 10**18;
        _enhancementCosts[9] = 750 * 10**18;
        _enhancementCosts[10] = 1000 * 10**18;
        _enhancementCosts[11] = 1000 * 10**18;
        _enhancementCosts[12] = 1000 * 10**18;
        _enhancementCosts[13] = 1000 * 10**18;

        // Initialize enhancement odds
        _enhancementOdds[0] = 8500;
        _enhancementOdds[1] = 7500;
        _enhancementOdds[2] = 6500;
        _enhancementOdds[3] = 5500;
        _enhancementOdds[4] = 4500;
        _enhancementOdds[5] = 3500;
        _enhancementOdds[6] = 3000;
        _enhancementOdds[7] = 2500;
        _enhancementOdds[8] = 2000;
        _enhancementOdds[9] = 1000;
        _enhancementOdds[10] = 500;
        _enhancementOdds[11] = 500;
        _enhancementOdds[12] = 500;
        _enhancementOdds[13] = 500;

        // Initialize enhancement odds
        _enhancementDegredationOdds[0] = 0;
        _enhancementDegredationOdds[1] = 0;
        _enhancementDegredationOdds[2] = 2500;
        _enhancementDegredationOdds[3] = 2500;
        _enhancementDegredationOdds[4] = 2500;
        _enhancementDegredationOdds[5] = 3500;
        _enhancementDegredationOdds[6] = 3500;
        _enhancementDegredationOdds[7] = 3500;
        _enhancementDegredationOdds[8] = 4000;
        _enhancementDegredationOdds[9] = 4500;
        _enhancementDegredationOdds[10] = 5000;
        _enhancementDegredationOdds[11] = 5000;
        _enhancementDegredationOdds[12] = 5000;
        _enhancementDegredationOdds[13] = 5000;
    }

    // Returns on-chain stats for a given token
    function getStats(uint256 tokenId)
        public
        view
        override
        returns (Stats.FighterStats memory)
    {
        uint256 seed = _seeder.getSeedSafe(address(_token), tokenId);
        uint32 range = MAX_DMG - MIN_DMG + 1;

        return
            Stats.FighterStats(
                MIN_DMG + uint32(seed % range),
                _enhancement[tokenId]
            );
    }

    // Returns the seeder contract address
    function getSeeder() external view override returns (address) {
        return address(_seeder);
    }

    // Sets the seeder contract address
    function setSeeder(address seeder) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _setSeeder(seeder);
    }

    // Returns the token URI for off-chain cosmetic data
    function tokenURI(uint256 tokenId) public pure returns (string memory) {
        return string(abi.encodePacked(_baseURI(), tokenId.toString()));
    }

    /** ENHANCEMENT */

    // Returns enhancement cost in confetti, and whether a token must be burned
    function enhancementCost(uint256 tokenId)
        external
        view
        override(Enhanceable, IEnhanceable)
        returns (uint256, bool)
    {
        return (
            _enhancementCosts[_enhancement[tokenId]],
            _enhancement[tokenId] > 2
        );
    }

    function enhance(uint256 tokenId, uint256 burnTokenId)
        public
        override(Enhanceable, IEnhanceable)
    {
        uint8 enhancement = _enhancement[tokenId];
        require(
            enhancement < MAX_ENHANCEMENT,
            "FighterURIHandler::enhance: max enhancement reached"
        );
        uint256 cost = _enhancementCosts[enhancement];

        _confetti.transferFrom(msg.sender, address(this), cost);
        uint256 teamAmount = (cost * 20) / 100;
        _confetti.transfer(_team, teamAmount);
        _confetti.burn(cost - teamAmount);

        if (enhancement > 2) {
            _token.safeTransferFrom(msg.sender, address(this), burnTokenId);
            _token.burn(burnTokenId);
        }

        super.enhance(tokenId, burnTokenId);
    }

    function reveal(uint256[] calldata tokenIds) public override {
        unchecked {
            for (uint256 i = 0; i < tokenIds.length; i++) {
                uint256 seed = _getSeed(tokenIds[i]);
                uint8 enhancement = _enhancement[tokenIds[i]];
                bool success = false;
                bool degraded = false;

                if (_roll(seed, _enhancementOdds[enhancement])) {
                    _enhancement[tokenIds[i]] += 1;
                    success = true;
                } else if (
                    _roll(
                        seed,
                        _enhancementOdds[enhancement] +
                            _enhancementDegredationOdds[enhancement]
                    ) && enhancement > MIN_ENHANCEMENT
                ) {
                    _enhancement[tokenIds[i]] -= 1;
                    degraded = true;
                }

                emit EnhancementCompleted(
                    tokenIds[i],
                    block.timestamp,
                    success,
                    degraded
                );
            }

            super.reveal(tokenIds);
        }
    }

    /** INTERNAL */

    function _baseURI() internal pure returns (string memory) {
        return "https://api.raid.party/metadata/fighter/";
    }
}
