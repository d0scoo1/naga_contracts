// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "./IERC20.sol";
import "./ISeeder.sol";
import "./IRevealContract.sol";
import "./IMainGame.sol";
import "./IERC721.sol";

contract RaidPartyInsuranceDeclaration {

    IERC20 public immutable confettiToken;
    IERC721 public immutable hero;
    IERC721 public immutable fighter;

    IRevealContract public immutable revealFighterContract;
    IRevealContract public immutable revealHeroContract;
    IMainGame public immutable mainGame;
    ISeeder public immutable seeder;

    address public immutable CONFETTI_TOKEN_ADDRESS;
    address public immutable REVEAL_FIGHTER_CONTRACT_ADDRESS;
    address public immutable REVEAL_HERO_CONTRACT_ADDRESS;
    address public immutable MAIN_GAME_CONTRACT_ADDRESS;
    address public immutable SEEDER_CONTRACT_ADDRESS;
    address public immutable HERO_CONTRACT_ADDRESS;
    address public immutable FIGHTER_CONTRACT_ADDRESS;

    address public masterAddress;
    uint256 public confettiReserves;

    uint256 constant PRECISION = 10 ** 18;
    address constant ZERO_ADDRESS = address(0x0);

    uint256 public immutable MAX_FIGHTER_ENHANCECOST;
    uint256 public immutable MAX_HERO_ENHANCECOST;
    uint256 public immutable HERO_ENHANCE_RESERVE_NEEDED_CUTOFF;

    uint256[] public heroReserves;
    uint256[] public fighterReserves;

    bool public registerAllowed = true;

    mapping(uint256 => uint256) public batchNumberRegisterHero;
    mapping(uint256 => uint256) public batchNumberRegisterFighter;

    mapping(uint256 => uint256) public heroReservesPerBatch;
    mapping(uint256 => uint256) public fighterReservesPerBatch;

    mapping(uint256 => uint256) public lastEnhanceCostHeroByID;
    mapping(uint256 => uint256) public lastEnhanceCostFighterByID;

    mapping(uint256 => uint256) public insuranceCostHeroByEnhanceCost;
    mapping(uint256 => uint256) public insuranceCostFighterByEnhanceCost;

    mapping(uint256 => mapping(uint256 => bool)) public tokenIDClaimedInBatchHero;
    mapping(uint256 => mapping(uint256 => bool)) public tokenIDClaimedInBatchFighter;

    mapping(uint256 => uint256) public confettiReservesPerBatch;

    modifier onlyMaster() {
        require(
            masterAddress == msg.sender,
            "RaidPartyInsurance: ACCESS_DENIED"
        );
        _;
     }

    modifier registerAllowedCheck() {
        require(
            registerAllowed == true,
            "RaidPartyInsurance: REGISTER_NOT_ALLOWED"
        );
        _;
    }

    constructor(
        address _CONFETTI_TOKEN_ADDRESS,
        address _REVEAL_FIGHTER_CONTRACT_ADDRESS,
        address _MAIN_GAME_CONTRACT_ADDRESS,
        address _SEEDER_CONTRACT_ADDRESS,
        address _HERO_CONTRACT_ADDRESS,
        address _FIGHTER_CONTRACT_ADDRESS,
        address _REVEAL_HERO_CONTRACT_ADDRESS
    ) {
        CONFETTI_TOKEN_ADDRESS = _CONFETTI_TOKEN_ADDRESS;
        REVEAL_FIGHTER_CONTRACT_ADDRESS = _REVEAL_FIGHTER_CONTRACT_ADDRESS;
        MAIN_GAME_CONTRACT_ADDRESS = _MAIN_GAME_CONTRACT_ADDRESS;
        SEEDER_CONTRACT_ADDRESS = _SEEDER_CONTRACT_ADDRESS;
        HERO_CONTRACT_ADDRESS = _HERO_CONTRACT_ADDRESS;
        FIGHTER_CONTRACT_ADDRESS = _FIGHTER_CONTRACT_ADDRESS;
        REVEAL_HERO_CONTRACT_ADDRESS = _REVEAL_HERO_CONTRACT_ADDRESS;

        confettiToken = IERC20(
            CONFETTI_TOKEN_ADDRESS
        );

        revealFighterContract = IRevealContract(
            REVEAL_FIGHTER_CONTRACT_ADDRESS
        );

        revealHeroContract = IRevealContract(
            REVEAL_HERO_CONTRACT_ADDRESS
        );

        mainGame = IMainGame(
            MAIN_GAME_CONTRACT_ADDRESS
        );

        seeder = ISeeder(
            SEEDER_CONTRACT_ADDRESS
        );

        hero = IERC721(
            HERO_CONTRACT_ADDRESS
        );

        fighter = IERC721(
            FIGHTER_CONTRACT_ADDRESS
        );

        MAX_FIGHTER_ENHANCECOST = 350 * PRECISION;
        HERO_ENHANCE_RESERVE_NEEDED_CUTOFF = 1250 * PRECISION;
        MAX_HERO_ENHANCECOST = 2250 * PRECISION;

        insuranceCostFighterByEnhanceCost[25 * PRECISION] = 25 * PRECISION;
        insuranceCostFighterByEnhanceCost[35 * PRECISION] = 34 * PRECISION;
        insuranceCostFighterByEnhanceCost[50 * PRECISION] = 45 * PRECISION;
        insuranceCostFighterByEnhanceCost[75 * PRECISION] = 61 * PRECISION;
        insuranceCostFighterByEnhanceCost[100 * PRECISION] = 80 * PRECISION;
        insuranceCostFighterByEnhanceCost[125 * PRECISION] = 101 * PRECISION;
        insuranceCostFighterByEnhanceCost[150 * PRECISION] = 125 * PRECISION;
        insuranceCostFighterByEnhanceCost[300 * PRECISION] = 220 * PRECISION;
        insuranceCostFighterByEnhanceCost[350 * PRECISION] = 270 * PRECISION;

        insuranceCostHeroByEnhanceCost[250 * PRECISION] = 50 * PRECISION;
        insuranceCostHeroByEnhanceCost[500 * PRECISION] = 125 * PRECISION;
        insuranceCostHeroByEnhanceCost[750 * PRECISION] = 225 * PRECISION;
        insuranceCostHeroByEnhanceCost[1000 * PRECISION] = 350 * PRECISION;
        insuranceCostHeroByEnhanceCost[1250 * PRECISION] = 1100 * PRECISION;
        insuranceCostHeroByEnhanceCost[1500 * PRECISION] = 1350 * PRECISION;
        insuranceCostHeroByEnhanceCost[1750 * PRECISION] = 1625 * PRECISION;
        insuranceCostHeroByEnhanceCost[2000 * PRECISION] = 1925 * PRECISION;
        insuranceCostHeroByEnhanceCost[2250 * PRECISION] = 2250 * PRECISION;
    }
}
