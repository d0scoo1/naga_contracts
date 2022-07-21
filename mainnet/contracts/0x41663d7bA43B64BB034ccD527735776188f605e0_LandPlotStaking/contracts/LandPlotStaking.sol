// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

struct UserInfo {
    uint256 amount;
    uint256 depositTime;
    uint256 previousUnClaimedRewardAmount;
}

contract LandPlotStaking is Ownable, ERC1155Receiver {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    event ChangeExpiration(
        uint256 oldExpirationTime,
        uint256 newExpirationTime
    );
    event ChangeRewardAddress(
        IERC20 oldRewardAddress,
        IERC20 newOldAddress,
        uint256 indexed collectionId
    );
    event ChangePlotAddress(IERC1155 oldPlotAddress, IERC1155 newPlotAddress);
    event ChangeRoyaltyClaimer(
        address oldRoyaltyClaimer,
        address newRoyaltyClaimer
    );
    event Deposited(
        address depositer,
        uint256 collectionId,
        uint256 amount,
        uint256 depositedTime
    );
    event WithDraw(
        uint256[] collectionIds,
        uint256[] claimedRewardAmounts,
        uint256[] royaltyRewardAmounts
    );

    event RewardClaimed(
        uint256[] collectionIds,
        uint256[] claimedRewardAmounts,
        uint256[] royaltyRewardAmounts
    );

    event ChangedRoyaltyPercentage(
        uint256 indexed oldRoyaltyPercentage,
        uint256 indexed newRoyaltyPercentage
    );

    IERC1155 plotAddress;

    // expiration time of reward providing
    uint256 public expiration;

    address royaltyClaimer = 0x89cC8F045033CF767BbB93A01e55F83288E061BA;

    mapping(uint256 => uint256) public rates;

    mapping(address => mapping(uint256 => UserInfo)) public _userInfo;
    mapping(uint256 => IERC20) public rewardTokens;

    uint256 public royaltyPercentage = 20;

    constructor(IERC1155 _plotAddress) {
        plotAddress = _plotAddress;
    }

    function setExpiration(uint256 _expiration) public onlyOwner {
        uint256 oldExpirationTime = expiration;
        expiration = _expiration;
        emit ChangeExpiration(oldExpirationTime, expiration);
    }

    function changeRewardToken(IERC20 _rewardTokenAddress, uint256 collectionId)
        public
        onlyOwner
    {
        IERC20 oldRewardAddress = rewardTokens[collectionId];
        rewardTokens[collectionId] = _rewardTokenAddress;
        emit ChangeRewardAddress(
            oldRewardAddress,
            _rewardTokenAddress,
            collectionId
        );
    }

    function changePlotAddress(IERC1155 _plotAddress) public onlyOwner {
        IERC1155 oldPlotAddress = plotAddress;
        plotAddress = _plotAddress;
        emit ChangePlotAddress(oldPlotAddress, plotAddress);
    }

    function changeRate(uint256 collectionId, uint256 newRate)
        public
        onlyOwner
    {
        rates[collectionId] = newRate;
    }

    function changeRoyaltyPercentage(uint256 _royaltyPercentage)
        public
        onlyOwner
    {
        uint256 oldRoyaltyPercentage = royaltyPercentage;
        royaltyPercentage = _royaltyPercentage;
        emit ChangedRoyaltyPercentage(oldRoyaltyPercentage, royaltyPercentage);
    }

    function changeRoyaltyClaimer(address newRoyaltyClaimer) public {
        address oldRoyaltyClaimer = royaltyClaimer;
        royaltyClaimer = newRoyaltyClaimer;
        emit ChangeRoyaltyClaimer(oldRoyaltyClaimer, royaltyClaimer);
    }

    function deposit(uint256 _amount, uint256 collectionId) external {
        require(expiration > block.timestamp, "Invalid time stamp");

        plotAddress.safeTransferFrom(
            msg.sender,
            address(this),
            collectionId,
            _amount,
            ""
        );
        uint256 previousDeposit = _userInfo[msg.sender][collectionId].amount;

        
        if (previousDeposit > 0) {
            uint256 rewardAmount = calculateReward(collectionId, msg.sender);
            _userInfo[msg.sender][collectionId]
                .previousUnClaimedRewardAmount = rewardAmount;
            _userInfo[msg.sender][collectionId].depositTime = block.timestamp;
            _userInfo[msg.sender][collectionId].amount =
                previousDeposit +
                _amount;
        } else {
            _userInfo[msg.sender][collectionId] = UserInfo(
                _amount,
                block.timestamp,
                0
            );
        }
        emit Deposited(msg.sender, collectionId, _amount, block.timestamp);
    }

    function calculateReward(uint256 collectionId, address account)
        public
        view
        returns (uint256)
    {
        return
            _userInfo[account][collectionId].previousUnClaimedRewardAmount +
            rates[collectionId] *
            (Math.min(block.timestamp, expiration) -
                _userInfo[account][collectionId].depositTime) *
            _userInfo[account][collectionId].amount;
    }

    function claimRewards(uint256[] memory collectionIds) public {
        claimRewards(collectionIds, msg.sender);
    }

    function distributeRewards(uint256[] memory collectionIds, address account)
        public
        onlyOwner
    {
        claimRewards(collectionIds, account);
    }

    function claimRewards(uint256[] memory collectionIds, address account)
        internal
    {
        (
            uint256[] memory amounts,
            uint256[] memory rewardAmounts,
            uint256[] memory royaltyAmounts
        ) = calculateClaimableRewards(collectionIds, account);

        for (uint256 i = 0; i < collectionIds.length; i++) {
            if (amounts[i] != 0) {
                rewardTokens[collectionIds[i]].transfer(
                    account,
                    rewardAmounts[i]
                );
                rewardTokens[collectionIds[i]].transfer(
                    royaltyClaimer,
                    royaltyAmounts[i]
                );
                _userInfo[account][collectionIds[i]]
                    .previousUnClaimedRewardAmount = 0;
                _userInfo[account][collectionIds[i]].depositTime = block
                    .timestamp;
            }
        }

        emit RewardClaimed(collectionIds, rewardAmounts, royaltyAmounts);
    }

    function calculateClaimableRewards(
        uint256[] memory collectionIds,
        address account
    )
        public
        view
        returns (
            uint256[] memory,
            uint256[] memory,
            uint256[] memory
        )
    {
        uint256[] memory amounts = new uint256[](collectionIds.length);
        uint256[] memory rewardAmounts = new uint256[](collectionIds.length);
        uint256[] memory royaltyAmounts = new uint256[](collectionIds.length);
        for (uint256 i = 0; i < collectionIds.length; i++) {
            amounts[i] = _userInfo[account][collectionIds[i]].amount;
            require(amounts[i] > 0, "Amount must be more than or equal to 1");
            uint256 reward = calculateReward(collectionIds[i], account);
            rewardAmounts[i] = reward.mul(100 - royaltyPercentage).div(100);
            royaltyAmounts[i] = reward.mul(royaltyPercentage).div(100);
        }
        return (amounts, rewardAmounts, royaltyAmounts);
    }

    function withdraw(uint256[] memory collectionIds) public {
        (
            uint256[] memory amounts,
            uint256[] memory rewardAmounts,
            uint256[] memory royaltyAmounts
        ) = calculateClaimableRewards(collectionIds, msg.sender);

        for (uint256 i = 0; i < collectionIds.length; i++) {
            if (amounts[i] != 0) {
                rewardTokens[collectionIds[i]].transfer(
                    msg.sender,
                    rewardAmounts[i]
                );
                rewardTokens[collectionIds[i]].transfer(
                    royaltyClaimer,
                    royaltyAmounts[i]
                );
                delete _userInfo[msg.sender][collectionIds[i]];
            }
        }
        plotAddress.safeBatchTransferFrom(
            address(this),
            msg.sender,
            collectionIds,
            amounts,
            ""
        );
        emit WithDraw(collectionIds, rewardAmounts, royaltyAmounts);
    }

    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external override returns (bytes4) {
        return IERC1155Receiver.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external override returns (bytes4) {
        return IERC1155Receiver.onERC1155BatchReceived.selector;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC1155Receiver)
        returns (bool)
    {
        return
            interfaceId == type(IERC1155).interfaceId ||
            interfaceId == type(IERC1155Receiver).interfaceId;
    }

    function emergencyExit(IERC20 rewardToken) public onlyOwner {
        rewardToken.transfer(msg.sender, rewardToken.balanceOf(address(this)));
    }
}
