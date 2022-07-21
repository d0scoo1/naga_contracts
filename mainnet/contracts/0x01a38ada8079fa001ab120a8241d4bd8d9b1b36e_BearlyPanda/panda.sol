// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import './ERC721.sol';
import './ERC721Enumerable.sol';

contract BearlyPanda is ERC721, ERC721Enumerable {
	uint256 constant FREE_SUPPLY = 1000;
	uint256 constant MAX_SUPPLY = 8000;
    uint256 private TOTAL_MINT_NUMS = 0;
    uint256 private SELL_PRICE = 0;
	address immutable owner;

	uint256 id = 1;

	constructor() ERC721('BearlyPandaOfficial', 'BearlyPandaOfficial') {
		owner = msg.sender;
	}

    function setPrice(uint256 price) public onlyOwner {
        SELL_PRICE = price;
    }
    function getPrice() public onlyOwner view returns  (uint256 _nums){
        return SELL_PRICE;
    }
    function getTotalMintNums() public onlyOwner view returns  (uint256 _nums){
        return TOTAL_MINT_NUMS;
    }

	function _baseURI() internal pure override returns (string memory) {
		return 'https://api.bearlypanda.io/app/json/';
	}

	function mint(uint256 _amount) external payable {
		require(_amount > 0 && _amount < 11, 'Amount must be between 0 and 11 tokens.');
		require(TOTAL_MINT_NUMS < MAX_SUPPLY, 'All tokens have been minted.');
        require(TOTAL_MINT_NUMS + _amount <= MAX_SUPPLY, 'Insufficient quantity.');
		require(TOTAL_MINT_NUMS < FREE_SUPPLY || msg.value > 0, 'All free tokens have been minted.');
        if( SELL_PRICE > 0){
            require(msg.value >= SELL_PRICE, 'All free tokens have been minted.');
        }

		payable(owner).transfer(msg.value);

		for (uint256 i = 0; i < _amount; i++) {
			_safeMint(msg.sender, id);
			id++;
            TOTAL_MINT_NUMS++;
		}
	}

	// The following overrides required.

	function _beforeTokenTransfer(
		address from,
		address to,
		uint256 tokenId
	) internal override(ERC721, ERC721Enumerable) {
		super._beforeTokenTransfer(from, to, tokenId);
	}

	function supportsInterface(bytes4 interfaceId)
		public
		view
		override(ERC721, ERC721Enumerable)
		returns (bool)
	{
		return super.supportsInterface(interfaceId);
	}

    function totalSupply()public override view returns(uint256 _num){
        return MAX_SUPPLY;
    }

    function totalMint()public view returns(uint256 _num){
        return TOTAL_MINT_NUMS;
    }
    modifier onlyOwner(){
        require(msg.sender == owner, "Not owner");
        _;
    }

}
