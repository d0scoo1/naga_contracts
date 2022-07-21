//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

//    ___ ___    _____      _____      _____    .___ _______   ____  __. _________            
//   /   |   \  /  _  \    /     \    /     \   |   |\      \ |    |/ _| \_   ___ \  ____     
//  /    ~    \/  /_\  \  /  \ /  \  /  \ /  \  |   |/   |   \|      <   /    \  \/ /  _ \    
//  \    Y    /    |    \/    Y    \/    Y    \ |   /    |    \    |  \  \     \___(  <_> )   
//   \___|_  /\____|__  /\____|__  /\____|__  / |___\____|__  /____|__ \  \______  /\____/ /\ 
//         \/         \/         \/         \/              \/        \/         \/        \/ 

import "../token/ERC721/IERC721.sol";
import "../token/ERC721/IERC721Receiver.sol";

contract hammsteaks is IERC721Receiver {
    address public immutable targetAddress;
    uint256 public immutable stakeRate;

    mapping(address => uint256[]) internal _stakedTokensOfOwner;
    mapping(uint256 => address) public stakedTokenOwners;

    constructor(address _targetAddress, uint256 _stakeRate) {
        targetAddress = _targetAddress;
        stakeRate = _stakeRate;
    }

    // ERC721 Receiever

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) public pure override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    // INTERNAL

    function _stake(address _owner, uint256[] calldata tokenIds) internal {
        IERC721 target = IERC721(targetAddress);

        for (uint256 i = 0; i < tokenIds.length; i++) {
            uint256 tokenId = tokenIds[i];
            stakedTokenOwners[tokenId] = _owner;
            _stakedTokensOfOwner[_owner].push(tokenId);
            target.safeTransferFrom(_owner, address(this), tokenId);
        }

        emit Staked(_owner, tokenIds);
    }

    function _withdraw(address _owner, uint256[] calldata tokenIds) internal {
        IERC721 target = IERC721(targetAddress);

        for (uint256 i = 0; i < tokenIds.length; i++) {
            uint256 tokenId = tokenIds[i];
            require(
                stakedTokenOwners[tokenId] == _owner,
                "You must own the token."
            );

            stakedTokenOwners[tokenId] = address(0);

            // Remove tokenId from the user staked tokenId list
            uint256[] memory newStakedTokensOfOwner = _stakedTokensOfOwner[
                _owner
            ];
            for (uint256 q = 0; q < newStakedTokensOfOwner.length; q++) {
                if (newStakedTokensOfOwner[q] == tokenId) {
                    newStakedTokensOfOwner[q] = newStakedTokensOfOwner[
                        newStakedTokensOfOwner.length - 1
                    ];
                }
            }

            _stakedTokensOfOwner[_owner] = newStakedTokensOfOwner;
            _stakedTokensOfOwner[_owner].pop();

            target.safeTransferFrom(address(this), _owner, tokenId);
        }

        emit Withdrawn(_owner, tokenIds);
    }

    function _stakingMultiplierForToken(uint256 _tokenId)
        internal
        view
        returns (uint256)
    {
        return stakedTokenOwners[_tokenId] != address(0) ? stakeRate : 1;
    }

    // EVENTS

    event Staked(address indexed user, uint256[] tokenIds);
    event Withdrawn(address indexed user, uint256[] tokenIds);
}