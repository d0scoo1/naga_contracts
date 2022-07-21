// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";

import {IHeyEduToken, IL2StandardERC20} from "./interfaces/IHeyEduToken.sol";

error HeyEdu_Edu_OnlyOwner();
error HeyEdu_Edu_OnlyOwnerCandidate();

error HeyEdu_Edu_OnlyMinter();
error HeyEdu_Edu_MinterTimelocked();
error HeyEdu_Edu_WrongNewMinter();

contract Edu is IHeyEduToken, ERC20, ERC20Burnable, ERC20Permit {
    string public constant VERSION = "1";
    address public owner;
    address public ownerCandidate;

    address public minter = address(0);
    uint256 public minterUpdatedAt;
    uint256 public constant MINT_TIMELOCK_AFTER_MINTER_CHANGE = 7 days;

    address public immutable l1Token;
    address public l2Bridge;

    constructor(address _owner, address _l2Bridge) ERC20("Edu", "EDU") ERC20Permit("HeyEdu Edu") {
        owner = _owner;
        l1Token = address(this);

        if (block.chainid != 1) {
            l2Bridge = _l2Bridge;
        }
    }

    /*//////////////////////////////////////////////////////////////
                            MINT and BURN
    //////////////////////////////////////////////////////////////*/

    function mint(address _to, uint256 _amount) external {
        if (msg.sender != minter && msg.sender != l2Bridge) {
            revert HeyEdu_Edu_OnlyMinter();
        }
        if (msg.sender == minter && block.timestamp < minterUpdatedAt + MINT_TIMELOCK_AFTER_MINTER_CHANGE) {
            revert HeyEdu_Edu_MinterTimelocked();
        }

        _mint(_to, _amount);
        emit Mint(_to, _amount);
    }

    function burn(address _from, uint256 _amount) external {
        if (msg.sender != minter && msg.sender != l2Bridge) {
            revert HeyEdu_Edu_OnlyMinter();
        }

        _burn(_from, _amount);

        emit Burn(_from, _amount);
    }

    /*//////////////////////////////////////////////////////////////
                            OWNERSHIP
    //////////////////////////////////////////////////////////////*/

    event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
    event OwnerCandidateChosen(address indexed _ownerCandidate);
    event NewMinterSet(address indexed _newMinter);

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert HeyEdu_Edu_OnlyOwner();
        }
        _;
    }

    function setMinter(address newMinter) external onlyOwner {
        if (newMinter == address(0) || newMinter == minter) {
            revert HeyEdu_Edu_WrongNewMinter();
        }

        if (minter != address(0)) {
            minterUpdatedAt = block.timestamp;
        }

        minter = newMinter;

        emit NewMinterSet(newMinter);
    }

    function setOwnerCandidate(address _ownerCandidate) external onlyOwner {
        ownerCandidate = _ownerCandidate;
        emit OwnerCandidateChosen(ownerCandidate);
    }

    function claimOwnership() external {
        if (msg.sender != ownerCandidate) {
            revert HeyEdu_Edu_OnlyOwner();
        }

        emit OwnershipTransferred(owner, ownerCandidate);
        owner = ownerCandidate;
        ownerCandidate = address(0);
    }

    function rescueTokens(address _recipient) external onlyOwner {
        uint256 amount = balanceOf(address(this));
        transfer(_recipient, amount);
    }

    /*//////////////////////////////////////////////////////////////
                            ERC165
    //////////////////////////////////////////////////////////////*/

    // slither-disable-next-line external-function
    function supportsInterface(bytes4 _interfaceId) public pure returns (bool) {
        bytes4 firstSupportedInterface = bytes4(keccak256("supportsInterface(bytes4)")); // ERC165
        bytes4 secondSupportedInterface = IL2StandardERC20.l1Token.selector ^
            IL2StandardERC20.mint.selector ^
            IL2StandardERC20.burn.selector;
        return _interfaceId == firstSupportedInterface || _interfaceId == secondSupportedInterface;
    }
}
