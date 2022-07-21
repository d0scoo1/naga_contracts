// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./ITicketBooth.sol";

/**
 * @dev An ERC20 token for DAO.
 */
contract DAOToken is ERC20, ERC20Permit, Ownable {

    ITicketBooth public immutable ticketBooth;

    mapping(address=>bool) public claimed;

    bool close;

    event Claim(address indexed claimant, uint256 amount);

    uint256 constant peopleToolSupply = 100_000_000e18;
    uint256 constant AssangeDAOProjectId = 323;



    /**
     * @dev Constructor.
     */
    constructor(
        address booth
    )
        ERC20("ForDAO", "DAO")
        ERC20Permit("ForDAO")
    {
        _mint(msg.sender, peopleToolSupply);
        ticketBooth = ITicketBooth(booth);
    }

    function closeDAO() onlyOwner public {
        close = true;
    }


    /**
     * @dev Claims DAO tokens.
     */
    function claimTokens() public {
        require(!close, "DAOToken Close!");
        require(!claimed[msg.sender], "DAOToken: Tokens already claimed.");
        claimed[msg.sender] = true;
        uint256 amount = ticketBooth.balanceOf(msg.sender, AssangeDAOProjectId);
        require(amount > 0, "You do not donate AssangeDAO");
        _mint(msg.sender, amount);
        emit Claim(msg.sender, amount);
    }

}
