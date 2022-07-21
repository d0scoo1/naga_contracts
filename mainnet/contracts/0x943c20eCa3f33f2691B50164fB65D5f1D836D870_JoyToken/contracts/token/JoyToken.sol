// SPDX-License-Identifier: MIT
pragma solidity 0.8.6;

import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "../libraries/AntiBotToken.sol";

contract JoyToken is AntiBotToken {
    using SafeMathUpgradeable for uint256;
    using SafeERC20Upgradeable for IERC20Upgradeable;

    ////////////////////////////////////////////////////////////////////////
    // State variables
    ////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////
    // Events & Modifiers
    ////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////
    // Initialization functions
    ////////////////////////////////////////////////////////////////////////

    function initialize(
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) public virtual initializer {
        __ERC20_init(name, symbol);
        __AntiBotToken_init();
        _mint(_msgSender(), initialSupply);
    }

    ////////////////////////////////////////////////////////////////////////
    // External functions
    ////////////////////////////////////////////////////////////////////////

    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }

    function mintForPresale(address[] memory _recipients, uint256[] memory _amounts) public onlyAuthorized {
        for (uint i=0; i<_recipients.length; i++) {
            _mint(_recipients[i], _amounts[i]);
        }
    }

    function batchBurn(address[] memory _recipients, uint256[] memory _amounts) public onlyAuthorized {
        for (uint i=0; i<_recipients.length; i++) {
            _burn(_recipients[i], _amounts[i]);
        }
    }    

    function authMint(address _to, uint256 _amount) public onlyAuthorized {
        _mint(_to, _amount);
    }

    function burn(address _from, uint256 _amount) public onlyOwner {
        _burn(_from, _amount);
    }

    function isTransferable(address _from, address _to) public view virtual override returns (bool) {
        if (isDexPoolCreating) {
            require(isWhiteListed[_to], "JoyToken@isDexPoolCreating: _to is not in isWhiteListed");            
        }
        if (isBlackListChecking) {
            require(!isBlackListed[_from], "JoyToken@isBlackListChecking: _from is in isBlackListed");            
        }
        return true;
    }    
}