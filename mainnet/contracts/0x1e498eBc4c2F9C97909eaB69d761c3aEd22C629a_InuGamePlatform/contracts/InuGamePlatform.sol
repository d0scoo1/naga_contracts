// SPDX-License-Identifier: MIT
pragma solidity 0.8.6;

import "./WithdrawExtension.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title The main project contract.
 */
contract InuGamePlatform is ERC20, WithdrawExtension {
    using SafeMath for uint256;

    uint256 public total;
    uint256 public priceInWei;
    bool public presaleActive;
    /**
     * @dev Constructor that gives msg.sender all of existing tokens.
     */

    event BuyTokens(address _buyer, uint256 _amount, uint256 _cost);

    constructor(
        uint256 _initialSupply,
        uint256 _priceInWei
    ) ERC20("Inu Game Platform", "IGP") {
        priceInWei = _priceInWei;
        presaleActive = true;
        _mint(address(this), 10010001 * 10 ** decimals());
        _mint(address(msg.sender), _initialSupply - 10010001 * 10 ** decimals());
    }

    function decimals() public view virtual override returns (uint8) {
        return 12;
    }

    function setPrice(uint256 _priceInWei) public onlyOwner {
        priceInWei = _priceInWei;
    }

    function stopPresale() public onlyOwner {
        presaleActive = false;
    }

    function startPresale() public onlyOwner {
        presaleActive = true;
    }

    function calculateAffordableTokens(uint256 _amount) public view returns (uint256) {
        return _amount.mul(10 ** decimals()).div(priceInWei);
    }

    fallback() external payable {
        require(presaleActive, "InuGamePlatform: Presale is not active");
        uint256 _msgValue = msg.value;
        address _msgSender = msg.sender;

        uint256 _tokensToBuy = _msgValue.mul(10 ** decimals()).div(priceInWei);
        require(
            _tokensToBuy <= balanceOf(address(this)),
            "InuGamePlatform: Looks like you are trying to buy too many tokens"
        );
        require(
            _msgValue >= (1 * 10 ** 18) / 10,
            "InuGamePlatform: Send at least 0.1 ETH"
        );
        require(_msgValue <= (1 * 10 ** 18), "InuGamePlatform: Send max 1 ETH");
        _transfer(address(this), _msgSender, _tokensToBuy);

        emit BuyTokens(_msgSender, _tokensToBuy, _msgValue);
    }
}
