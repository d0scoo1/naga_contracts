//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Ownable.sol";
import "./IERC20Upgradeable.sol";
import "./utils/Initializable.sol";

interface IERC20Decimals {
    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() external view returns (uint8);
}


contract Exchanger is Initializable, Ownable {
    address[] public purchasedTokens;
    address public selledToken;
    address public beneficiary;

    uint ratePur;
    uint rateSel;
    
    mapping (address => bool) public isPurchased;

    function initialize(address[] memory _purchasedTokens, address _selledToken, address _beneficiary, uint256 _ratePur, uint256 _rateSel) external initializer {
        setOwner(msg.sender);

        require(_selledToken != address(0), "zero vesting proxy token address");
        require(_beneficiary != address(0), "zero beneficiary address");
        for (uint i = 0 ; i < _purchasedTokens.length; i++) {
            addPurchasedToken(_purchasedTokens[i]);
        }
        selledToken = _selledToken;
        beneficiary = _beneficiary;

        ratePur = _ratePur;
        rateSel = _rateSel;
    }

    function buy(address _token, uint amount) public {        
        require(isPurchased[_token], "(buy) the token is not purchased");
        require(amount > 0, "(buy) zero amount");
        (uint purAmount, uint selAmount) = prices(_token, amount);
        require(selAmount > 0, "(buy) zero contribution");
        require(IERC20Upgradeable(_token).allowance(msg.sender, address(this)) >= purAmount, "(buy) not approved token amount");

        IERC20Upgradeable(_token).transferFrom(msg.sender, beneficiary, purAmount);
        IERC20Upgradeable(selledToken).transfer(msg.sender, selAmount);
    }

    function balance(address _token) public view returns(uint256) {
        return IERC20Upgradeable(_token).balanceOf(address(this));
    }

    function prices(address token, uint selAmount) public view returns(uint _purchasedToken, uint _selAmount) {
        uint256 _selDecimalCorrection = 10**IERC20Decimals(selledToken).decimals();
        uint256 _purDecimalCorrection = 10**IERC20Decimals(token).decimals();

        _purchasedToken = selAmount * ratePur / (rateSel * _selDecimalCorrection / _purDecimalCorrection);
        _selAmount = _purchasedToken * (rateSel * _selDecimalCorrection / _purDecimalCorrection) / ratePur;
    }
    
    function getRateFromUSDT(address token, uint usdtAmount) public view returns(uint) {
        uint256 _selDecimalCorrection = 10**IERC20Decimals(selledToken).decimals();
        uint256 _purDecimalCorrection = 10**IERC20Decimals(token).decimals();

        uint _sellingAmount = usdtAmount * (rateSel * _selDecimalCorrection / _purDecimalCorrection) /ratePur;
        return _sellingAmount;
    }

    function getPurchasedTokens() public view returns(address[] memory) {
        return purchasedTokens;
    }

    function updateRate(uint _ratePur, uint _rateSel) public onlyOwner {
        ratePur = _ratePur;
        rateSel = _rateSel;
    }

    function updateToken(address token) public onlyOwner {
        require(token != address(0), "zero address of the token");
        selledToken = token;
    }

    function updateBeneficiary(address _beneficiary) public onlyOwner {
        beneficiary = _beneficiary;
    }

    function withdrawERC20(address token, uint amount) public onlyOwner {
        require(IERC20Upgradeable(token).balanceOf(address(this)) >= amount, "insufficient balance");
        IERC20Upgradeable(token).transfer(msg.sender, amount);
    }

    function addPurchasedToken(address _token) public onlyOwner {
        require(_token != address(0), "(addPurchasedToken) zero purchased token address");
        require(!isPurchased[_token], "(addPurchasedToken) the already purchased token");
        purchasedTokens.push(_token);
        isPurchased[_token] = true;
    }

    function removePurchasedToken(address _token) public onlyOwner {
        require(isPurchased[_token], "(removePurchasedToken) not purchased token");
        address[] storage tokens = purchasedTokens;
        deleteAddressFromArray(tokens, _token);
        isPurchased[_token] = false;
    }

    function deleteAddressFromArray(address[] storage _array, address _address) private {
        for (uint i = 0; i < _array.length; i++) {
            if (_array[i] == _address) {
                address temp = _array[_array.length-1];
                _array[_array.length-1] = _address;
                _array[i] = temp;
            }
        }

        _array.pop();
    }
}