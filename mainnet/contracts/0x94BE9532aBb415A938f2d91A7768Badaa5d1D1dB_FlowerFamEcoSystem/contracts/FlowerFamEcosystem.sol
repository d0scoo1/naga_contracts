// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./libraries/SimpleAccessUpgradable.sol";

import "./interfaces/IFlowerFam.sol";
import "./interfaces/IBee.sol";
import "./interfaces/IFlowerFamNewGen.sol";
import "./interfaces/IHoney.sol";
import "./interfaces/IFlowerFamRandomizer.sol";

contract FlowerFamEcoSystem is SimpleAccessUpgradable {
    IFlowerFam public flowerFamNFT;
    IBee public beeNFT;
    IFlowerFamNewGen public flowerFamNewGenNFT;
    IHoney public HoneyToken;
    IFlowerFamRandomizer private randomizer;

    /** Honey production */
    struct UserHoneyProduction {
        uint32 lastAction;
        uint112 totalProductionPerDay;
        uint112 totalAccumulated;
    }
    mapping(address => UserHoneyProduction) public userToProductionInfo;
    mapping(uint256 => uint256) public speciesToHoneyProduction;
    uint256 public newGenHoneyProduction;
    uint256 public upgradeProductionBonus;

    /** Bee system */
    struct FlowerBeeAttachement {
        uint128 reductionsStart; /// @dev records at which reduction period we start after stake or restore
        uint128 beeId;
    }
    uint256 public beeProductionBonus;
    mapping(uint256 => FlowerBeeAttachement) public flowerToBee;
    mapping(uint256 => FlowerBeeAttachement) public newGenFlowerToBee;

    mapping(address => uint256) public flowersToBeeCount;

    event UpdateTotalProductionPerDay(address indexed user, uint256 indexed amount);

    constructor(
        address _flowerFamNFT,
        address _beeNFT,
        address _flowerFamNewGen,
        address _honeyToken,
        address _randomizer
    ) {}

    function initialize(        
        address _flowerFamNFT,
        address _beeNFT,
        address _flowerFamNewGen,
        address _honeyToken,
        address _randomizer
    ) public initializer {
        __Ownable_init();

        flowerFamNFT = IFlowerFam(_flowerFamNFT);
        beeNFT = IBee(_beeNFT);
        flowerFamNewGenNFT = IFlowerFamNewGen(_flowerFamNewGen);
        HoneyToken = IHoney(_honeyToken);
        randomizer = IFlowerFamRandomizer(_randomizer);

        speciesToHoneyProduction[0] = 4 ether;
        speciesToHoneyProduction[1] = 6 ether;
        speciesToHoneyProduction[2] = 10 ether;
        speciesToHoneyProduction[3] = 18 ether;
        speciesToHoneyProduction[4] = 30 ether;
        newGenHoneyProduction = 2 ether;

        beeProductionBonus = 5; /// @dev 5% boost of flowers earnings for each reduction period
        upgradeProductionBonus = 5; /// @dev 5% boost of flowers earnings for each upgrade
    }

    receive() external payable {}

    /** Helpers */

    function _getNotAccumulatedProduction(
        uint256 lastAction,
        uint256 totalProductionPerDay
    ) internal view returns (uint256) {
        return ((block.timestamp - lastAction) * totalProductionPerDay) / 1 days;
    }

    function _getTotalNotAccumulatedProductionOfUser(address user, uint256[] memory flowersWithBees) internal view returns (uint256) {
        require(flowersWithBees.length == flowersToBeeCount[user], "Flower to bees count is not matched");
        UserHoneyProduction memory userHoneyProduction = userToProductionInfo[user];
        
        uint256 unAccumulated = _getNotAccumulatedProduction(
            userHoneyProduction.lastAction,
            userHoneyProduction.totalProductionPerDay
        );

        uint256 lastId;
        for (uint i = 0; i < flowersWithBees.length; i++) {
            uint256 flowerId = flowersWithBees[i];
            require(flowerId > lastId, "FlowersWithBees array needs to be ordered ascendingly");
            lastId = flowerId;

            if (flowerToBee[flowerId].beeId != 0 && flowerFamNFT.realOwnerOf(flowerId) == user)
                unAccumulated += _getProductionFromBee(flowerId, true, flowerToBee[flowerId].beeId);
            if (newGenFlowerToBee[flowerId].beeId != 0 && flowerFamNewGenNFT.realOwnerOf(flowerId) == user)
                unAccumulated += _getProductionFromBee(flowerId, false, newGenFlowerToBee[flowerId].beeId);     
        }

        return unAccumulated;
    }

    function _getProductionFromUpgrade(uint256 initialProduction, uint256 flowerFamId) internal view returns(uint256) {
        return initialProduction * upgradeProductionBonus * flowerFamNFT.getUpgradeCountOfFlower(flowerFamId) / 100;
    }

    function _getProductionFromBee(uint256 flowerId, bool isFam, uint256 beeId) internal view returns(uint256) {
        uint256 species = randomizer.getSpeciesOfId(flowerId);
        uint256 flowerBaseProduction = isFam ? 
            speciesToHoneyProduction[species] :
            newGenHoneyProduction;
        uint256 powerCycleBasePeriod = beeNFT.powerCycleBasePeriod();

        uint256 beeLastInteraction = beeNFT.getLastAction(beeId);
        uint256 powerCycleStart = beeNFT.getPowerCycleStart(beeId);
        uint256 reductions = beeNFT.getPowerReductionPeriods(beeId);
        uint256 reductionsStart = isFam ? flowerToBee[flowerId].reductionsStart : newGenFlowerToBee[flowerId].reductionsStart;

        uint256 totalEarned;
        for (uint i = 0; i <= reductions - reductionsStart; i++) {

            /// @dev nothing should be added at or beyond 20 reductions
            if (reductionsStart + i >= 20)
                continue;

            /// @dev at first reduction we add either period from last interaction until now
            /// or period from last interaction until next reduction. We calculate the bonus as
            /// this time multiplied by the initial reduction.
            if (i == 0) {
                uint256 nextReductionAfterStart = powerCycleStart + (powerCycleBasePeriod * (reductionsStart + 1));
                uint256 timeSpentBeforeFirstReduction = block.timestamp < nextReductionAfterStart ? 
                    block.timestamp - beeLastInteraction : 
                    nextReductionAfterStart - beeLastInteraction;
                
                uint256 additionalProduction = flowerBaseProduction * (100 - reductionsStart * beeProductionBonus) / 100;
                totalEarned += additionalProduction * timeSpentBeforeFirstReduction / 1 days;
            
            /// @dev Here we just calculate one week worth of rewards at that level
            } else if (i < reductions - reductionsStart) {
                uint256 additionalProduction = flowerBaseProduction * (100 - (reductionsStart + i) * beeProductionBonus) / 100;
                totalEarned += additionalProduction * powerCycleBasePeriod / 1 days;

            /// @dev At last reduction we add period from last reduction until now with that reduction rate as reward.
            } else {
                uint256 startTimeOfLastReduction = powerCycleStart + (powerCycleBasePeriod * reductions);
                uint256 timeSpentAtLastReduction = block.timestamp  - startTimeOfLastReduction;
                uint256 additionalProduction = flowerBaseProduction * (100 - reductions * beeProductionBonus) / 100;
                totalEarned +=  additionalProduction * timeSpentAtLastReduction / 1 days;
            }
        }

        return totalEarned;
    }

    /** User interactable (everything that does not require spending $honey) */

    function stakeFlowerFamFlower(uint256 flowerFamId) external {
        uint256 species = randomizer.getSpeciesOfId(flowerFamId);

        uint256 additionalHoneyProduction = speciesToHoneyProduction[species];
        additionalHoneyProduction += _getProductionFromUpgrade(additionalHoneyProduction, flowerFamId);

        UserHoneyProduction storage userHoneyProduction = userToProductionInfo[msg.sender];

        uint256 unAccumulated = _getNotAccumulatedProduction(
            userHoneyProduction.lastAction,
            userHoneyProduction.totalProductionPerDay
        );
        userHoneyProduction.lastAction = uint32(block.timestamp);
        userHoneyProduction.totalProductionPerDay += uint112(additionalHoneyProduction);
        userHoneyProduction.totalAccumulated += uint112(unAccumulated);

        flowerFamNFT.stake(msg.sender, flowerFamId);

        emit UpdateTotalProductionPerDay(msg.sender, userHoneyProduction.totalProductionPerDay);
    }

    function unstakeFlowerFamFlower(uint256 flowerFamId) external {
        uint256 species = randomizer.getSpeciesOfId(flowerFamId);

        if (flowerToBee[flowerFamId].beeId != 0) {
            releaseBeeFromFlower(flowerFamId, flowerToBee[flowerFamId].beeId);
        }

        uint256 reducedHoneyProduction = speciesToHoneyProduction[species];
        reducedHoneyProduction += _getProductionFromUpgrade(reducedHoneyProduction, flowerFamId);

        UserHoneyProduction storage userHoneyProduction = userToProductionInfo[msg.sender];

        uint256 unAccumulated = _getNotAccumulatedProduction(
            userHoneyProduction.lastAction,
            userHoneyProduction.totalProductionPerDay
        );
        userHoneyProduction.lastAction = uint32(block.timestamp);
        userHoneyProduction.totalProductionPerDay -= uint112(reducedHoneyProduction);
        userHoneyProduction.totalAccumulated += uint112(unAccumulated);

        flowerFamNFT.unstake(msg.sender, flowerFamId);

        emit UpdateTotalProductionPerDay(msg.sender, userHoneyProduction.totalProductionPerDay);
    }

    function stakeNewGenerationFlower(uint256 newGenId) external {
        uint256 additionalHoneyProduction = newGenHoneyProduction;

        UserHoneyProduction storage userHoneyProduction = userToProductionInfo[msg.sender];

        uint256 unAccumulated = _getNotAccumulatedProduction(
            userHoneyProduction.lastAction,
            userHoneyProduction.totalProductionPerDay
        );
        userHoneyProduction.lastAction = uint32(block.timestamp);
        userHoneyProduction.totalProductionPerDay += uint112(additionalHoneyProduction);
        userHoneyProduction.totalAccumulated += uint112(unAccumulated);

        flowerFamNewGenNFT.stake(msg.sender, newGenId);

        emit UpdateTotalProductionPerDay(msg.sender, userHoneyProduction.totalProductionPerDay);
    }

    function unstakeNewGenerationFlower(uint256 newGenId) external {
        if (newGenFlowerToBee[newGenId].beeId != 0) {
            releaseBeeFromNewGenFlower(newGenId, newGenFlowerToBee[newGenId].beeId);
        }
        
        uint256 reducedHoneyProduction = newGenHoneyProduction;

        UserHoneyProduction storage userHoneyProduction = userToProductionInfo[msg.sender];

        uint256 unAccumulated = _getNotAccumulatedProduction(
            userHoneyProduction.lastAction,
            userHoneyProduction.totalProductionPerDay
        );
        userHoneyProduction.lastAction = uint32(block.timestamp);
        userHoneyProduction.totalProductionPerDay -= uint112(reducedHoneyProduction);
        userHoneyProduction.totalAccumulated += uint112(unAccumulated);

        flowerFamNewGenNFT.unstake(msg.sender, newGenId);

        emit UpdateTotalProductionPerDay(msg.sender, userHoneyProduction.totalProductionPerDay);
    }

    /** Batch stake */

    function batchStakeFlowerFamFlowers(uint256[] calldata flowerFamIds) external {
        require(flowerFamIds.length > 0, "No fams provided");

        uint256 additionalHoneyProduction;
        for (uint i = 0; i < flowerFamIds.length; i++) {
            uint256 flowerFamId = flowerFamIds[i];
            uint256 species = randomizer.getSpeciesOfId(flowerFamId);

            uint256 flowerProduction = speciesToHoneyProduction[species];
            flowerProduction += _getProductionFromUpgrade(additionalHoneyProduction, flowerFamId);

            additionalHoneyProduction += flowerProduction;
        }
        
        UserHoneyProduction storage userHoneyProduction = userToProductionInfo[msg.sender];

        uint256 unAccumulated = _getNotAccumulatedProduction(
            userHoneyProduction.lastAction,
            userHoneyProduction.totalProductionPerDay
        );
        userHoneyProduction.lastAction = uint32(block.timestamp);
        userHoneyProduction.totalProductionPerDay += uint112(additionalHoneyProduction);
        userHoneyProduction.totalAccumulated += uint112(unAccumulated);

        for (uint i = 0; i < flowerFamIds.length; i++) {
            uint256 flowerFamId = flowerFamIds[i];
            flowerFamNFT.stake(msg.sender, flowerFamId);
        }            

        emit UpdateTotalProductionPerDay(msg.sender, userHoneyProduction.totalProductionPerDay);
    }

    function batchUnstakeFlowerFamFlower(uint256[] calldata flowerFamIds) external {
        require(flowerFamIds.length > 0, "No fams provided");

        uint256 reducedHoneyProduction;
        for (uint i = 0; i < flowerFamIds.length; i++) {
            uint256 flowerFamId = flowerFamIds[i];
            if (flowerToBee[flowerFamId].beeId != 0) {
                releaseBeeFromFlower(flowerFamId, flowerToBee[flowerFamId].beeId);
            }

            uint256 species = randomizer.getSpeciesOfId(flowerFamId);
            uint256 flowerProduction = speciesToHoneyProduction[species];
            flowerProduction += _getProductionFromUpgrade(reducedHoneyProduction, flowerFamId);
            reducedHoneyProduction += flowerProduction;
        }
            
        UserHoneyProduction storage userHoneyProduction = userToProductionInfo[msg.sender];

        uint256 unAccumulated = _getNotAccumulatedProduction(
            userHoneyProduction.lastAction,
            userHoneyProduction.totalProductionPerDay
        );
        userHoneyProduction.lastAction = uint32(block.timestamp);
        userHoneyProduction.totalProductionPerDay -= uint112(reducedHoneyProduction);
        userHoneyProduction.totalAccumulated += uint112(unAccumulated);

        for (uint i = 0; i < flowerFamIds.length; i++) {
            uint256 flowerFamId = flowerFamIds[i];
            flowerFamNFT.unstake(msg.sender, flowerFamId);
        }            

        emit UpdateTotalProductionPerDay(msg.sender, userHoneyProduction.totalProductionPerDay);
    }

    function batchStakeNewGenerationFlower(uint256[] calldata newGenIds) external {
        require(newGenIds.length > 0, "No new generation flowers provided");

        uint256 additionalHoneyProduction = newGenHoneyProduction * newGenIds.length;

        UserHoneyProduction storage userHoneyProduction = userToProductionInfo[msg.sender];

        uint256 unAccumulated = _getNotAccumulatedProduction(
            userHoneyProduction.lastAction,
            userHoneyProduction.totalProductionPerDay
        );
        userHoneyProduction.lastAction = uint32(block.timestamp);
        userHoneyProduction.totalProductionPerDay += uint112(additionalHoneyProduction);
        userHoneyProduction.totalAccumulated += uint112(unAccumulated);

        for (uint i = 0; i < newGenIds.length; i++)
            flowerFamNewGenNFT.stake(msg.sender, newGenIds[i]);

        emit UpdateTotalProductionPerDay(msg.sender, userHoneyProduction.totalProductionPerDay);
    }

    function batchUnstakeNewGenerationFlower(uint256[] calldata newGenIds) external {
        require(newGenIds.length > 0, "No new generation flowers provided");

        uint256 reducedHoneyProduction = newGenHoneyProduction * newGenIds.length;

        UserHoneyProduction storage userHoneyProduction = userToProductionInfo[msg.sender];

        uint256 unAccumulated = _getNotAccumulatedProduction(
            userHoneyProduction.lastAction,
            userHoneyProduction.totalProductionPerDay
        );
        userHoneyProduction.lastAction = uint32(block.timestamp);
        userHoneyProduction.totalProductionPerDay -= uint112(reducedHoneyProduction);
        userHoneyProduction.totalAccumulated += uint112(unAccumulated);

        for (uint i = 0; i < newGenIds.length; i++)
            flowerFamNewGenNFT.unstake(msg.sender, newGenIds[i]);

        emit UpdateTotalProductionPerDay(msg.sender, userHoneyProduction.totalProductionPerDay);
    }

    /** Minter stake */
    function mintAndStakeFlowerFamFlower(address staker, uint256 flowerFamId) external onlyAuthorized {
        uint256 species = randomizer.getSpeciesOfId(flowerFamId);

        uint256 additionalHoneyProduction = speciesToHoneyProduction[species];
        additionalHoneyProduction += _getProductionFromUpgrade(additionalHoneyProduction, flowerFamId);

        UserHoneyProduction storage userHoneyProduction = userToProductionInfo[staker];

        uint256 unAccumulated = _getNotAccumulatedProduction(
            userHoneyProduction.lastAction,
            userHoneyProduction.totalProductionPerDay
        );
        userHoneyProduction.lastAction = uint32(block.timestamp);
        userHoneyProduction.totalProductionPerDay += uint112(additionalHoneyProduction);
        userHoneyProduction.totalAccumulated += uint112(unAccumulated);

        flowerFamNFT.stake(staker, flowerFamId);

        emit UpdateTotalProductionPerDay(staker, userHoneyProduction.totalProductionPerDay);
    }

    function mintAndBatchStakeFlowerFamFlowers(address staker, uint256[] calldata flowerFamIds) external onlyAuthorized {
        require(flowerFamIds.length > 0, "No fams provided");

        uint256 additionalHoneyProduction;
        for (uint i = 0; i < flowerFamIds.length; i++) {
            uint256 flowerFamId = flowerFamIds[i];
            uint256 species = randomizer.getSpeciesOfId(flowerFamId);

            uint256 flowerProduction = speciesToHoneyProduction[species];
            flowerProduction += _getProductionFromUpgrade(additionalHoneyProduction, flowerFamId);

            additionalHoneyProduction += flowerProduction;
        }
        
        UserHoneyProduction storage userHoneyProduction = userToProductionInfo[staker];

        uint256 unAccumulated = _getNotAccumulatedProduction(
            userHoneyProduction.lastAction,
            userHoneyProduction.totalProductionPerDay
        );
        userHoneyProduction.lastAction = uint32(block.timestamp);
        userHoneyProduction.totalProductionPerDay += uint112(additionalHoneyProduction);
        userHoneyProduction.totalAccumulated += uint112(unAccumulated);

        for (uint i = 0; i < flowerFamIds.length; i++) {
            uint256 flowerFamId = flowerFamIds[i];
            flowerFamNFT.stake(staker, flowerFamId);
        }            

        emit UpdateTotalProductionPerDay(staker, userHoneyProduction.totalProductionPerDay);
    }

    /** Bees */

    function attachBeeToFlower(uint256 flowerFamId, uint256 beeId) external {
        require(flowerFamNFT.realOwnerOf(flowerFamId) == msg.sender, "Sender not owner of flower");
        require(flowerFamNFT.isAlreadyStaked(flowerFamId), "Cannot attach bee to unstaked flower");
        require(flowerToBee[flowerFamId].beeId == 0, "Flower already boosted by bee");

        beeNFT.stake(msg.sender, beeId); /// @dev contains checks for ownership and stake status
    
        flowerToBee[flowerFamId].reductionsStart = uint128(beeNFT.getPowerReductionPeriods(beeId));
        flowerToBee[flowerFamId].beeId = uint128(beeId);
                
        flowersToBeeCount[msg.sender] += 1;
    }

    function releaseBeeFromFlower(uint256 flowerFamId, uint256 beeId) public {
        require(flowerFamNFT.realOwnerOf(flowerFamId) == msg.sender, "Sender not owner of flower");
        require(flowerFamNFT.isAlreadyStaked(flowerFamId), "Cannot release from unstaked flower");        
        require(flowerToBee[flowerFamId].beeId == beeId, "Flower already boosted by bee");

        /// @dev add production from bee to total accumulated when unstaking the bee
        uint256 earnedSinceLastInteraction = _getProductionFromBee(flowerFamId, true, beeId);
        UserHoneyProduction storage userHoneyProduction = userToProductionInfo[msg.sender];
        userHoneyProduction.totalAccumulated += uint112(earnedSinceLastInteraction);

        delete flowerToBee[flowerFamId];
        beeNFT.unstake(msg.sender, beeId); /// @dev contains checks for ownership and stake status
        flowersToBeeCount[msg.sender] -= 1;
    }

    function attachBeeToNewGenFlower(uint256 flowerId, uint256 beeId) external {
        require(flowerFamNewGenNFT.realOwnerOf(flowerId) == msg.sender, "Sender not owner of flower");
        require(flowerFamNewGenNFT.isAlreadyStaked(flowerId), "Cannot attach bee to unstaked flower");
        require(newGenFlowerToBee[flowerId].beeId == 0, "Flower already boosted by bee");

        beeNFT.stake(msg.sender, beeId); /// @dev contains checks for ownership and stake status

        newGenFlowerToBee[flowerId].reductionsStart = uint128(beeNFT.getPowerReductionPeriods(beeId));
        newGenFlowerToBee[flowerId].beeId = uint128(beeId);
                
        flowersToBeeCount[msg.sender] += 1;
    }

    function releaseBeeFromNewGenFlower(uint256 flowerId, uint256 beeId) public {
        require(flowerFamNewGenNFT.realOwnerOf(flowerId) == msg.sender, "Sender not owner of flower");
        require(flowerFamNewGenNFT.isAlreadyStaked(flowerId), "Cannot release from unstaked flower");        
        require(newGenFlowerToBee[flowerId].beeId == beeId, "Flower already boosted by bee");

        /// @dev add production from bee to total accumulated when unstaking the bee
        uint256 earnedSinceLastInteraction = _getProductionFromBee(flowerId, false, beeId);
        UserHoneyProduction storage userHoneyProduction = userToProductionInfo[msg.sender];
        userHoneyProduction.totalAccumulated += uint112(earnedSinceLastInteraction);

        delete newGenFlowerToBee[flowerId];
        beeNFT.unstake(msg.sender, beeId); /// @dev contains checks for ownership and stake status
        flowersToBeeCount[msg.sender] -= 1;
    }

    /** Marketplace only (everything that requires spending $honey) */

    function upgradeFlower(address user, uint256 flowerFamId) external onlyAuthorized {
        require(flowerFamNFT.realOwnerOf(flowerFamId) == user, "Sender not owner of flower");
        require(flowerFamNFT.isAlreadyStaked(flowerFamId), "Cannot upgrade unstaked flower");

        uint256 species = randomizer.getSpeciesOfId(flowerFamId);
        uint256 additionalHoneyProduction = speciesToHoneyProduction[species];
        uint256 addedFromUpgrade = additionalHoneyProduction * upgradeProductionBonus / 100; /// @dev each upgrade adds upgradeProductionBonus

        UserHoneyProduction storage userHoneyProduction = userToProductionInfo[user];

        uint256 unAccumulated = _getNotAccumulatedProduction(
            userHoneyProduction.lastAction,
            userHoneyProduction.totalProductionPerDay
        );
        userHoneyProduction.lastAction = uint32(block.timestamp);
        userHoneyProduction.totalProductionPerDay += uint112(addedFromUpgrade);
        userHoneyProduction.totalAccumulated += uint112(unAccumulated);

        flowerFamNFT.upgrade(user, flowerFamId);

        emit UpdateTotalProductionPerDay(msg.sender, userHoneyProduction.totalProductionPerDay);
    }

    function restorePowerOfBee(address user, uint256 flowerId, bool isFam, uint256 beeId, uint256 restorePeriods) external onlyAuthorized {    
        if (isFam) {
            require(flowerFamNFT.realOwnerOf(flowerId) == user, "Sender not owner of flower");
            require(flowerFamNFT.isAlreadyStaked(flowerId), "Cannot restore bee from unstaked flower");
            require(flowerToBee[flowerId].beeId == beeId, "Flower already boosted by bee");
        }            
        else {
            require(flowerFamNewGenNFT.realOwnerOf(flowerId) == user, "Sender not owner of flower");
            require(flowerFamNewGenNFT.isAlreadyStaked(flowerId), "Cannot restore bee from unstaked flower");
            require(newGenFlowerToBee[flowerId].beeId == beeId, "Flower already boosted by bee");
        }            

        /// @dev add production from bee to total accumulated when unstaking the bee
        uint256 earnedSinceLastInteraction = _getProductionFromBee(flowerId, isFam, beeId);
        UserHoneyProduction storage userHoneyProduction = userToProductionInfo[user];
        userHoneyProduction.totalAccumulated += uint112(earnedSinceLastInteraction);

        if (isFam)
            flowerToBee[flowerId].reductionsStart = uint128(beeNFT.getPowerReductionPeriods(beeId));
        else
            newGenFlowerToBee[flowerId].reductionsStart = uint128(beeNFT.getPowerReductionPeriods(beeId));

        beeNFT.restorePowerOfBee(user, beeId, restorePeriods); /// @dev contains checks for ownership and stake status
    }

    /** View */

    function getAttachedFlowerOfBee(uint256 beeId) external view returns (uint256) {
        uint256 flowerId = 0;
        uint256 startToken = flowerFamNFT.startTokenId();
        for (uint i = startToken; i < startToken + flowerFamNFT.totalSupply(); i++) {
            if (flowerToBee[i].beeId == beeId)
                flowerId = i;
        }
        
        return flowerId;
    }

    function getAttachedNewGenFlowerOfBee(uint256 beeId) external view returns (uint256) {
        uint256 flowerId = 0;
        uint256 startToken = flowerFamNewGenNFT.startTokenId();
        for (uint i = startToken; i < startToken + flowerFamNewGenNFT.totalSupply(); i++) {
        if (newGenFlowerToBee[i].beeId == beeId)
            flowerId = i;
        }
        
        return flowerId;
    }

    function getFlowerFamFlowersOfUserWithBees(address user) public view returns (uint256[] memory) {
        uint256 counter;
        uint256 balance = flowerFamNFT.balanceOf(user);
        uint256[] memory userNFTs = new uint256[](balance);

        uint256 startToken = flowerFamNFT.startTokenId();

        for (uint i = startToken; i < startToken + flowerFamNFT.totalSupply(); i++) {
            if (flowerToBee[i].beeId != 0 && flowerFamNFT.realOwnerOf(i) == user) {
                userNFTs[counter] = i;
                counter++;
            }               
        }
        
        return userNFTs;
    }

    function getNewGenFlowersOfUserWithBees(address user) public view returns (uint256[] memory) {
        uint256 counter;
        uint256 balance = flowerFamNewGenNFT.balanceOf(user);
        uint256[] memory userNFTs = new uint256[](balance);

        uint256 startToken = flowerFamNewGenNFT.startTokenId();

        for (uint i = startToken; i < startToken + flowerFamNewGenNFT.totalSupply(); i++) {
            if (newGenFlowerToBee[i].beeId != 0 && flowerFamNewGenNFT.realOwnerOf(i) == user) {
                userNFTs[counter] = i;
                counter++;
            }               
        }
        
        return userNFTs;
    }

    function getTotalNotAccumulatedProductionOfUser(address user, uint256[] memory flowersWithBees) external view returns (uint256) {
        return _getTotalNotAccumulatedProductionOfUser(user, flowersWithBees);
    }

    function getTotalProductionOfUser(address user, uint256[] memory flowersWithBees) external view returns (uint256) {
        UserHoneyProduction storage userHoneyProduction = userToProductionInfo[user];

        return _getTotalNotAccumulatedProductionOfUser(user, flowersWithBees) + userHoneyProduction.totalAccumulated;
    }
}