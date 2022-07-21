// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "./RaidPartyInsuranceDeclaration.sol";
import "./RaidPartyInsuranceEvents.sol";

abstract contract RaidPartyInsuranceHelper is
    RaidPartyInsuranceDeclaration,
    RaidPartyInsuranceEvents
{
    function _buyInsuranceFighter(
        uint256 _tokenID,
        uint256 _fighterPos
    )
        internal
    {
        uint256[] memory tokenIDarray = new uint256[](1);
        tokenIDarray[0] = _tokenID;

        (
            uint256 batch,
            uint256 nextBatch
        ) = _getBatches();

        require(
            _checkPendingRevealFighter(_tokenID) == true,
            "RaidPartyInsuranceHelper: NO_PENDING_REVEAL"
        );

        _sameBatchCheck(
            REVEAL_FIGHTER_CONTRACT_ADDRESS,
            tokenIDarray
        );

        _checkIfInMainGameFighter(
            _tokenID,
            _fighterPos,
            msg.sender
        );

        require(
            batchNumberRegisterFighter[_tokenID] < batch,
            "RaidPartyInsuranceHelper: ALREADY_REGISTERED"
        );

        batchNumberRegisterFighter[_tokenID] = batch;

        uint256 enhanceCost = _determineEnhanceCost(
            REVEAL_FIGHTER_CONTRACT_ADDRESS,
            _tokenID
        );

        require(
            enhanceCost <= MAX_FIGHTER_ENHANCECOST,
            "RaidPartyInsuranceHelper: LEVEL_TOO_HIGH"
        );

        lastEnhanceCostFighterByID[_tokenID] = enhanceCost;

        fighterReservesPerBatch[nextBatch] += 1;
        confettiReservesPerBatch[nextBatch] += enhanceCost;

        uint256 insuranceCost = insuranceCostFighterByEnhanceCost[enhanceCost];

        confettiReserves += insuranceCost;

        _determineConfettiCoverageTotal();
        _determineReserveCoverageTotalFighter();

        confettiToken.transferFrom(
            msg.sender,
            address(this),
            insuranceCost
        );

        emit insurancePurchased(
            _tokenID,
            msg.sender,
            true,
            enhanceCost,
            batch,
            insuranceCost
        );
    }

    function _buyInsuranceHero(
        uint256 _tokenID
    )
        internal
    {
        (
            uint256 batch,
            uint256 nextBatch
        ) = _getBatches();

        uint256[] memory tokenIDarray = new uint256[](1);
        tokenIDarray[0] = _tokenID;

        require(
            _checkPendingRevealHero(_tokenID) == true,
            "RaidPartyInsuranceHelper: NO_PENDING_REVEAL"
        );

        _sameBatchCheck(
            REVEAL_HERO_CONTRACT_ADDRESS,
            tokenIDarray
        );

        _checkIfInMainGameHero(
            _tokenID,
            msg.sender
        );

        _checkDblRegisterHero(
            batch,
            _tokenID
        );

        batchNumberRegisterHero[_tokenID] = batch;

        uint256 enhanceCost = _determineEnhanceCost(
            REVEAL_HERO_CONTRACT_ADDRESS,
            _tokenID
        );

        require(
            enhanceCost <= MAX_HERO_ENHANCECOST,
            "RaidPartyInsuranceHelper: LEVEL_TOO_HIGH"
        );

        lastEnhanceCostHeroByID[_tokenID] = enhanceCost;

        confettiReservesPerBatch[nextBatch] =
        confettiReservesPerBatch[nextBatch] + enhanceCost;

        uint256 insuranceCost = insuranceCostHeroByEnhanceCost[enhanceCost];

        confettiReserves =
        confettiReserves + insuranceCost;

        _determineConfettiCoverageTotal();

        if (enhanceCost >= HERO_ENHANCE_RESERVE_NEEDED_CUTOFF) {
            heroReservesPerBatch[nextBatch] += 1;
            _determineReserveCoverageTotalHero();
        }

        confettiToken.transferFrom(
            msg.sender,
            address(this),
            insuranceCost
        );

        emit insurancePurchased(
            _tokenID,
            msg.sender,
            false,
            enhanceCost,
            batch,
            insuranceCost
        );
    }

    function _addFighterReserve(
        uint256 _tokenID
    )
        internal
    {
        fighterReserves.push(
            _tokenID
        );

        fighter.safeTransferFrom(
            msg.sender,
            address(this),
            _tokenID
        );
    }

    function _addHeroReserve(
        uint256 _tokenID
    )
        internal
    {
        heroReserves.push(
            _tokenID
        );

        hero.safeTransferFrom(
            msg.sender,
            address(this),
            _tokenID
        );
    }

    function _insuranceClaimHero(
        uint256 _tokenID
    )
        internal
    {
        uint256 batch = _getBatch();

        uint256[] memory tokenIDarray = new uint256[](1);
        tokenIDarray[0] = _tokenID;

        require(
            batchNumberRegisterHero[_tokenID] + 1 == batch,
            "RaidPartyInsuranceHelper: WRONG_BATCH"
        );

        _checkIfInMainGameHero(
            _tokenID,
            msg.sender
        );

        require(
            tokenIDClaimedInBatchHero[_tokenID][batch] == false,
            "RaidPartyInsuranceHelper: ALREADY_CLAIMED"
        );

        if (_checkPendingRevealHero(_tokenID) == true) {

            revealHeroContract.reveal(
                tokenIDarray
            );
        }

        uint256 enhanceCost = _determineEnhanceCost(
            REVEAL_HERO_CONTRACT_ADDRESS,
            _tokenID
        );

        uint256 previousEnhanceCost = lastEnhanceCostHeroByID[_tokenID];

        if (enhanceCost > previousEnhanceCost) {

            emit insuranceClaimed(
                _tokenID,
                batch,
                msg.sender,
                false,
                false,
                0
            );

            return;
        }

        tokenIDClaimedInBatchHero[_tokenID][batch] = true;
        confettiReservesPerBatch[batch] -= previousEnhanceCost;
        confettiReserves -= previousEnhanceCost;

        bool nftCompensation = previousEnhanceCost >= HERO_ENHANCE_RESERVE_NEEDED_CUTOFF;

        if (nftCompensation == true) {
            heroReservesPerBatch[batch] -= 1;
            hero.safeTransferFrom(
                address(this),
                msg.sender,
                _adjustHeroReserveArray()
            );
        }

        confettiToken.transfer(
            msg.sender,
            previousEnhanceCost
        );

        emit insuranceClaimed(
            _tokenID,
            batch,
            msg.sender,
            false,
            nftCompensation,
            previousEnhanceCost
        );
    }

    function _insuranceClaimFighter(
        uint256 _tokenID,
        uint256 _fighterPos
    )
        internal
    {
        uint256 batch = _getBatch();

        uint256[] memory tokenIDarray = new uint256[](1);
        tokenIDarray[0] = _tokenID;

        require(
            batchNumberRegisterFighter[_tokenID] + 1 == batch,
            "RaidPartyInsuranceHelper: WRONG_BATCH"
        );

        _checkIfInMainGameFighter(
            _tokenID,
            _fighterPos,
            msg.sender
        );

        require(
            tokenIDClaimedInBatchFighter[_tokenID][batch] == false,
            "RaidPartyInsuranceHelper: ALREADY_CLAIMED"
        );

        if (_checkPendingRevealFighter(_tokenID) == true) {
            revealFighterContract.reveal(tokenIDarray);
        }

        uint256 enhanceCost = _determineEnhanceCost(
            REVEAL_FIGHTER_CONTRACT_ADDRESS,
            _tokenID
        );

        uint256 previousEnhanceCost = lastEnhanceCostFighterByID[_tokenID];

        if (enhanceCost > previousEnhanceCost) {

            emit insuranceClaimed(
                _tokenID,
                batch,
                msg.sender,
                true,
                false,
                0
            );

            return;
        }

        tokenIDClaimedInBatchFighter[_tokenID][batch] = true;
        confettiReservesPerBatch[batch] -= previousEnhanceCost;
        fighterReservesPerBatch[batch] -= 1;
        confettiReserves -= previousEnhanceCost;

        confettiToken.transfer(
            msg.sender,
            previousEnhanceCost
        );

        fighter.safeTransferFrom(
            address(this),
            msg.sender,
            _adjustFighterReserveArray()
        );

        emit insuranceClaimed(
            _tokenID,
            batch,
            msg.sender,
            true,
            true,
            previousEnhanceCost
        );
    }

    function _withdrawHeroAdmin()
        internal
    {
        uint256 lastTokenID = _adjustHeroReserveArray();
        _determineReserveCoverageTotalHero();

        hero.safeTransferFrom(
            address(this),
            msg.sender,
            lastTokenID
        );
    }

    function _withdrawFighterAdmin()
        internal
    {
        uint256 lastTokenID = _adjustFighterReserveArray();
        _determineReserveCoverageTotalFighter();

        fighter.safeTransferFrom(
            address(this),
            msg.sender,
            lastTokenID
        );
    }

    function _sameBatchCheck(
        address _toCall,
        uint256[] memory _tokenIDs
    )
        internal
    {
        try IRevealContract(_toCall).reveal(
            _tokenIDs
        )
        {
            revert(
                "RaidPartyInsuranceHelper: NOT_SAME_BATCH"
            );
        }
        catch
        {
            emit PassedBatchCheck(
                _tokenIDs
            );
        }
    }

    function _checkDblRegisterHero(
        uint256 _batch,
        uint256 _tokenID
    )
        internal
        view
    {
        require(
            batchNumberRegisterHero[_tokenID] < _batch,
            "RaidPartyInsuranceHelper: ALREADY_REGISTERED"
        );
    }

    function _getBatch()
        internal
        view
        returns (uint256)
    {
        return seeder.getBatch();
    }

    function _getBatches()
        internal
        view
        returns (
            uint256 batch,
            uint256 nextBatch
        )
    {
        batch = _getBatch();
        nextBatch = batch + 1;
    }

    function _checkIfInMainGameFighter(
        uint256 _tokenID,
        uint256 _fighterPos,
        address _user
    )
        internal
        view
    {
        require(
            mainGame.getUserFighters(_user)[_fighterPos] == _tokenID,
            "RaidPartyInsuranceHelper: WRONG_TOKEN_ID"
        );
    }

    function _checkIfInMainGameHero(
        uint256 _tokenID,
        address _user
    )
        internal
        view
    {
        require(
            mainGame.getUserHero(_user) == _tokenID,
            "RaidPartyInsuranceHelper: WRONG_TOKEN_ID"
        );
    }

    function _determineEnhanceCost(
        address _toCall,
        uint256 _tokenID
    )
        internal
        view
        returns (uint256)
    {
        (
            uint256 enhanceCost,
        ) = IRevealContract(_toCall).enhancementCost(
            _tokenID
        );

        return enhanceCost;
    }

    function _determineReserveCoverageFighter(
        uint256 _fighterCount
    )
        internal
        view
        returns (bool)
    {
        return fighterReserves.length >= _fighterCount;
    }

    function _determineReserveCoverageHero(
        uint256 _heroCount
    )
        internal
        view
        returns (bool)
    {
        return heroReserves.length >= _heroCount;
    }

    function _determineReserveCoverageTotalFighter()
        internal
        view
        returns (bool)
    {
        uint256 batch = _getBatch();
        uint256 nextBatch = batch + 1;

        uint256 requiredTotal =
            fighterReservesPerBatch[batch] +
            fighterReservesPerBatch[nextBatch];

        require(
            _determineReserveCoverageFighter(requiredTotal) == true,
            "RaidPartyInsuranceHelper: VIOLATES_COVERAGE_FIGHTER"
        );

        return true;
    }

    function _determineReserveCoverageTotalHero()
        internal
        view
        returns (bool)
    {
        (
            uint256 batch,
            uint256 nextBatch
        ) = _getBatches();

        uint256 requiredTotal =
            heroReservesPerBatch[batch] +
            heroReservesPerBatch[nextBatch];

        require(
            _determineReserveCoverageHero(requiredTotal) == true,
            "RaidPartyInsuranceHelper: VIOLATES_COVERAGE_HERO"
        );

        return true;
    }

    function _determineConfettiCoverage(
        uint256 _confettiAmount
    )
        internal
        view
        returns (bool)
    {
        return confettiReserves >= _confettiAmount;
    }

    function _determineConfettiCoverageTotal()
        internal
        view
        returns (bool)
    {
        (
            uint256 batch,
            uint256 nextBatch
        ) = _getBatches();

        uint256 requiredTotal =
            confettiReservesPerBatch[batch] +
            confettiReservesPerBatch[nextBatch];

        require(
            _determineConfettiCoverage(requiredTotal) == true,
            "RaidPartyInsuranceHelper: VIOLATES_COVERAGE_CONFETII"
        );

        return true;
    }

    function _adjustHeroReserveArray()
        internal
        returns (uint256)
    {
        uint256 lastIndex = heroReserves.length - 1;
        uint256 lastTokenID = heroReserves[lastIndex];

        heroReserves.pop();
        return lastTokenID;
    }

    function _adjustFighterReserveArray()
        internal
        returns (uint256)
    {
        uint256 lastIndex = fighterReserves.length - 1;
        uint256 lastTokenID = fighterReserves[lastIndex];

        fighterReserves.pop();
        return lastTokenID;
    }

    function _checkPendingRevealFighter(
        uint256 _tokenID
    )
        internal
        view
        returns (bool)
    {
        (
            ,
            address enhancer
        ) = revealFighterContract.getEnhancementRequest(
            _tokenID
        );

        return enhancer > ZERO_ADDRESS;
    }

    function _checkPendingRevealHero(
        uint256 _tokenID
    )
        internal
        view
        returns (bool)
    {
        (
            ,
            address enhancer
        ) = revealHeroContract.getEnhancementRequest(
            _tokenID
        );

        return enhancer > ZERO_ADDRESS;
    }

    function _conditionCheckFighter(
        uint256 _batch,
        uint256 _currentFighterID,
        uint256 _currentEnhanceCost
    )
        internal
        view
        returns (bool)
    {
        return _currentEnhanceCost < MAX_FIGHTER_ENHANCECOST
            && _checkPendingRevealFighter(_currentFighterID)
            && batchNumberRegisterFighter[_currentFighterID] < _batch;
    }

    function _conditionCheckHero(
        uint256 _batch,
        uint256 _currentEnhanceCost,
        uint256 _currentHeroID
    )
        internal
        view
        returns (bool)
    {
        return _currentEnhanceCost < MAX_HERO_ENHANCECOST
            && _checkPendingRevealHero(_currentHeroID)
            && batchNumberRegisterHero[_currentHeroID] < _batch;
    }
}
