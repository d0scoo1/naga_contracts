// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract Escrow1155 is Ownable, ERC1155Holder, ReentrancyGuard, Pausable {
    event BuyToken(address indexed buyer, uint256 amount);

    struct SaleInfo {
        address erc1155Address;
        uint16 tokenId;
        uint16 currAmount;
        uint16 saleAmount;
        uint256 salePrice;
    }
    IERC1155 erc1155;

    uint8 private constant MAX_BUYABLE_COUNT_PER_TX = 3;
    uint256 private saleKey = 0;

    //erc1155 / tokenId / amount
    mapping(address => mapping(uint256 => SaleInfo)) public saleInfo;

    function registerTokenSale(
        address _address,
        uint16 _id,
        uint16 _amount,
        uint256 _salePrice
    ) external onlyOwner {
        require(_address != address(0), "Address can't be 0");
        require(!_isAlreadyRegistered(_address, _id), "Already registered token");

        saleInfo[_address][_id] = SaleInfo(_address, _id, _amount, _amount, _salePrice);

        erc1155 = IERC1155(_address);
        erc1155.safeTransferFrom(msg.sender, address(this), _id, _amount, "");
    }

    function unregisterTokenSale(address _address, uint16 _id) external onlyOwner {
        require(_address != address(0), "Address can't be 0");
        require(_isAlreadyRegistered(_address, _id), "Not registered token");

        erc1155 = IERC1155(_address);
        uint256 _amount = erc1155.balanceOf(address(this), _id);

        delete saleInfo[_address][_id];
        if (_amount > 0) {
            erc1155.safeTransferFrom(address(this), msg.sender, _id, _amount, "");
        }
    }

    function buyToken(
        address _address,
        uint16 _id,
        uint16 _amount,
        uint256 _saleKey
    ) external payable whenNotPaused nonReentrant isNotContract {
        require(_address != address(0), "Address can't be 0");
        require(saleKey == _saleKey, "Invalid saleKey");
        require(_amount <= MAX_BUYABLE_COUNT_PER_TX, "Exceed max buyable count per tx");
        uint256 price = saleInfo[_address][_id].salePrice * _amount;

        require(msg.value == price, "Invalid ETH balance");

        saleInfo[_address][_id].currAmount -= _amount;

        erc1155 = IERC1155(_address);
        erc1155.safeTransferFrom(address(this), msg.sender, _id, _amount, "");

        emit BuyToken(msg.sender, _amount);
    }

    function withdraw() external onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        if (!success) {
            revert("Ether transfer failed");
        }
    }

    function setSaleKey(uint256 _saleKey) external onlyOwner {
        saleKey = _saleKey;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function _isAlreadyRegistered(address _address, uint16 _id) private view returns (bool) {
        return saleInfo[_address][_id].salePrice != 0 && saleInfo[_address][_id].saleAmount != 0;
    }

    modifier isNotContract() {
        require(msg.sender == tx.origin, "Sender is not wallet");
        _;
    }
}
