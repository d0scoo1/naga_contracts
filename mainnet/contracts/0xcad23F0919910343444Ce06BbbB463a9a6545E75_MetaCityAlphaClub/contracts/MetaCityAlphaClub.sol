// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract MetaCityAlphaClub is Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;

    struct Alpha {
        bool isAvailable;
        uint256 availableSlots;
        uint256 daysAvailable;
        uint256 creationDate;
        uint256 price;
    }

    modifier authorised() {
        require(authorisedAddresses[msg.sender], "The token contract is not authorised");
        _;
    }

    address public tokenAddress;
    address public humansAddress;

    uint256 constant private ETHER = 10 ** 18;
    uint256 constant private DAYS = 24 * 60 * 60;

    mapping(uint256 => Alpha) public alphaConfig;

    mapping(uint256 => EnumerableSet.AddressSet) private registeredAddresses;

    mapping(address => bool) public authorisedAddresses;

    uint256[] public alphaList;

    constructor(
        address tokenAddress_,
        address humansAddress_
    ) {
        tokenAddress = tokenAddress_;
        humansAddress = humansAddress_;
    }

    function setTokenAddress(address tokenAddress_) external onlyOwner {
        tokenAddress = tokenAddress_;
    }

    function setHumansAddress(address humansAddress_) external onlyOwner {
        humansAddress = humansAddress_;
    }

    function setAuthorisedStatuses(
        address[] calldata addresses_,
        bool[] calldata statuses_
    ) external onlyOwner {
        for (uint256 i = 0; i < addresses_.length; ++i) {
            authorisedAddresses[addresses_[i]] = statuses_[i];
        }
    }

    function addAlpha(
        uint256 availableSlots_,
        uint256 availableDays_,
        uint256 price_,
        uint256 id_
    ) external authorised {
        Alpha storage alpha_ = alphaConfig[id_];
        require(alpha_.creationDate == uint256(0), "Project already exists");
        alpha_.isAvailable = true;
        alpha_.availableSlots = availableSlots_;
        alpha_.daysAvailable = availableDays_;
        alpha_.creationDate = block.timestamp;
        alpha_.price = price_;
        alphaList.push(id_);
    }

    function setAlphaStatus(uint256 id_, bool status_) authorised external {
        Alpha storage alpha_ = alphaConfig[id_];
        require(alpha_.creationDate != uint256(0), "Project does not exists");

        alpha_.isAvailable = status_;
    }

    function setAlphaAvailableSlots(uint256 id_, uint256 availableSlots_) authorised external {
        Alpha storage alpha_ = alphaConfig[id_];
        require(alpha_.creationDate != uint256(0), "Project does not exists");

        alpha_.availableSlots = availableSlots_;
    }

    function setAlphaAvailableDays(uint256 id_, uint256 daysAvailable_) authorised external {
        Alpha storage alpha_ = alphaConfig[id_];
        require(alpha_.creationDate != uint256(0), "Project does not exists");

        alpha_.daysAvailable = daysAvailable_;
    }

    function setAlphaPrice(uint256 id_, uint256 price_) authorised external {
        Alpha storage alpha_ = alphaConfig[id_];
        require(alpha_.creationDate != uint256(0), "Project does not exists");

        alpha_.price = price_;
    }

    function getRegisteredAddresses(uint256 id_) external view returns(address[] memory) {
        address[] memory addresses = new address[](registeredAddresses[id_].length());

        for (uint256 i = 0; i < registeredAddresses[id_].length(); ++i) {
            addresses[i] = registeredAddresses[id_].at(i);
        }

        return addresses;
    }

    function enroll(uint256 id_) external {
        Alpha storage alpha_ = alphaConfig[id_];

        require(alpha_.isAvailable, "Project is not available");

        if (alpha_.daysAvailable != uint256(0)) {
            require(alpha_.creationDate + alpha_.daysAvailable * DAYS >= block.timestamp, "End date reached");
        }

        if (alpha_.availableSlots != uint256(0)) {
            require(registeredAddresses[id_].length() < alpha_.availableSlots, "Available slots filled");
        }

        require(IERC721(humansAddress).balanceOf(_msgSender()) > 0, "You do not own humans");

        registeredAddresses[id_].add(_msgSender());

        if (alpha_.price != uint256(0)) {
            require(IERC20(tokenAddress).transferFrom(_msgSender(), tokenAddress, alpha_.price * ETHER));
        }
    }

}
