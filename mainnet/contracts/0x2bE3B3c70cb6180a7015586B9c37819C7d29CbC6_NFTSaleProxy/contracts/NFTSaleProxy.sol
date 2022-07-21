// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// REMIX
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/proxy/ERC1967/ERC1967Proxy.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/access/Ownable.sol";

// TRUFFLE
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// NFTSaleProxy SMART CONTRACT
contract NFTSaleProxy is ERC1967Proxy, Ownable {
    /**
     * NFTSaleProxy Constructor
     *
     * @param _logic - Implementation/Logic Contract Address
     */
    constructor(address _logic, address _nftAddress)
        public
        ERC1967Proxy(_logic, abi.encodeWithSignature("initialize(address)", _nftAddress))
    {}

    /**
     * Get the current implementation contract address
     *
     */
    function implementation() external view returns (address) {
        return _implementation();
    }

    /**
     * Change the implementation contract address
     *
     * @param _logic - Implementation/Logic Contract Address
     */
    function upgradeTo(address _logic) public onlyOwner {
        _upgradeTo(_logic);
    }
}
