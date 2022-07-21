// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IStaking.sol";


contract aKeeperRedeem is Ownable {
    using SafeMath for uint256;

    IERC20 public KEEPER;
    IERC20 public aKEEPER;
    address public staking;
    uint public multiplier; // multiplier is 4 decimals i.e. 1000 = 0.1

    event KeeperRedeemed(address tokenOwner, uint256 amount);
    

    constructor(address _aKEEPER, address _KEEPER, address _staking, uint _multiplier) {
        require( _aKEEPER != address(0) );
        require( _KEEPER != address(0) );
        require( _multiplier != 0 );
        aKEEPER = IERC20(_aKEEPER);
        KEEPER = IERC20(_KEEPER);
        staking = _staking;
        multiplier = _multiplier;
        // reduce gas fees of migrate-stake by pre-approving large amount
        KEEPER.approve( staking, 1e25);
    }

    function migrate(uint256 amount, bool _stake, bool _wrap) public {
        aKEEPER.transferFrom(msg.sender, address(this), amount);
        uint keeperAmount = amount.mul(multiplier).div(1e4);
        if ( _stake && staking != address( 0 ) ) {
            IStaking( staking ).stake( keeperAmount, msg.sender, _wrap );
        } else {
            KEEPER.transfer(msg.sender, keeperAmount);
        }
        emit KeeperRedeemed(msg.sender, keeperAmount);
    }

    function withdraw() external onlyOwner() {
        uint256 amount = KEEPER.balanceOf(address(this));
        KEEPER.transfer(msg.sender, amount);
    }
}