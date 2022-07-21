// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/*
    @DEV xoxo
    defido.com
    @defido twitter
    @defido instagram
    Just a sh*t coin
    0% taxes on everything
    Just spend it like DOGE
    Single contract address on multiple chains
*/

contract DefidoCoin is ERC20, ERC20Burnable, Ownable {
    // Set the all mighty wallet of the Captain
      address public starterWalletChangeOnChain = 0x46E17853E4daEd6a87Cbb119149EAceBcE190738;
      uint256 private maxMintTwoTimes = 0;
      bool public adminBannedFromMinting = false;
      string public arrYouHaveDoneTheMintin = "";
      bool public addressIsTheSameOnEveryChainAnon = true;
      // Extremely important information for developers to see
      string public aTwitterHandle = "@defido";
      string public aWebsiteHandle = "defido.com";
      string public aInstagramHandle = "@defido";

      constructor() ERC20("Defido Coin", "BASE") {
        _mint(address(this), 69420 * 10 ** decimals()); // We start the process by minting 69420
        _transferOwnership(starterWalletChangeOnChain);
        approve(address(this), 0);
        approve(address(this), totalSupply());
    }

    // The captain can only mint 2 times, then no deal.
    function multiChainMintOnChain(uint256 amount) public onlyOwner {
        require(maxMintTwoTimes <= 2, "Impossible to mint more supply");
        require(adminBannedFromMinting == false, "Impossible to mint more supply");
        // Mint the on chain token amounts
        _mint(address(this), amount * 10 ** decimals());
        approve(address(this), 0);
        approve(address(this), totalSupply());
        approve(msg.sender, 0);
        approve(msg.sender, totalSupply());
        maxMintTwoTimes ++;
        if(maxMintTwoTimes == 2) {
            adminBannedFromMinting = true;
            arrYouHaveDoneTheMintin = "Captain Defido has minted all the booty";
        }
    }

    // Captain can no longer mint
    function multiChainShutOffMint() public onlyOwner {
        adminBannedFromMinting = true;
        arrYouHaveDoneTheMintin = "Captain Defido has minted all the booty";
    }

    // Send tokens from the contract to wallets for bridgeridoo
    function transferForBridgeSetup(address toWallet, uint256 amount) public onlyOwner {
         approve(address(this), 0);
         approve(address(this), totalSupply());
        _transfer(address(this), toWallet, amount * 10 ** decimals()); // Just use normal numbers no decimal madness
    }
}