// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.4.11;

//----------------------------------------------------------------------------------------------------
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
//----------------------------------------------------------------------------------------------------
interface IERC777 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function granularity() external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function balanceOf(address owner) external view returns (uint256);
    function send(address recipient, uint256 amount, bytes data) external;
    function burn(uint256 amount, bytes data) external;
    function isOperatorFor(address operator, address tokenHolder) external view returns (bool);
    function authorizeOperator(address operator) external;
    function revokeOperator(address operator) external;
    function defaultOperators() external view returns (address[] memory);
    function operatorSend(address sender, address recipient, uint256 amount, bytes data, bytes operatorData) external;
    function operatorBurn(address account, uint256 amount, bytes data, bytes operatorData) external;
    event Sent( address indexed operator, address indexed from, address indexed to, uint256 amount, bytes data, bytes operatorData);
    event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);
    event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);
    event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
    event RevokedOperator(address indexed operator, address indexed tokenHolder);
}
//----------------------------------------------------------------------------------------------------
interface ILockable {
    function lock(address to, uint256 amount, bytes32 hash) external;
    function operatorLock(address from, address to, uint256 amount, bytes32 hash, bytes data, bytes operatorData) external;
    function unlock(string unlockerPhrase) external;
    function operatorUnlock(address to, string unlockerPhrase, bytes data, bytes operatorData) external;
    function reclaim(address to, string unlockerPhrase) external;
    function operatorReclaim(address from, address to, string unlockerPhrase, bytes data, bytes operatorData) external;
    function unlockByLockedCoinContract(address to, bytes32 hash) external;
    function reclaimByLockedCoinContract(address from, address to, bytes32 hash) external;
    function lockedSupply() external view returns (uint256 locked_supply);
    function lockedAmount(address from, bytes32 hash) external view returns (uint256 amount);
    function lockedBalanceOf(address account) external view returns (uint256);
}
//----------------------------------------------------------------------------------------------------
interface IPigeonFactory {
    function createCryptoPigeon(address to) external returns (ICryptoPigeon pigeonAddress);    
    function iAmFactory() external pure returns (bool);
    function amIEpigeon() external returns (bool);
    function factoryId() external view returns (uint256 id);
    function getMetaDataForPigeon(address pigeon) external view returns (string metadata);
    function mintingPrice() external view returns (uint256 price);
    function totalSupply() external view returns (uint256 supply);
    function maxSupply() external view returns (uint256 supply);
    function getFactoryTokenPrice(address ERC20Token) external view returns (uint256 price);
}
//----------------------------------------------------------------------------------------------------
interface ICryptoPigeon {
    function burnPigeon() external;    
    function iAmPigeon() external pure returns (bool); 
    function transferPigeon(address newOwner) external; 
    function hasFlown() external view returns (bool);
    function toAddress() external view returns (address addressee);   
    function owner() external view returns (address ownerAddress);
    function manager() external view returns (address managerAddress);
    function factoryId() external view returns (uint256 id);
}
//----------------------------------------------------------------------------------------------------
interface IEpigeon {
    function pigeonDestinations() external view returns (IPigeonDestinationDirectory destinations);
    function nameAndKeyDirectory() external view returns (INameAndPublicKeyDirectory directory);
    function getLastFactoryId() external view returns (uint256 id);
    function getFactoryAddresstoId(uint256 id) external view returns (address factoryAddress);
    function getPigeonPriceForFactory(uint256 factoryId) external view returns (uint256 price);
    function getPigeonTokenPriceForFactory(address ERC20Token, uint256 factoryId) external view returns (uint256 price);
    function createCryptoPigeonNFT(address to, uint256 factoryId) external returns (address pigeonaddress);
    function transferPigeon(address from, address to, address pigeon) external;
    function burnPigeon(address pigeon) external;
    function nftContractAddress() external view returns (address nftContract);
    function validPigeon(address pigeon, address pigeonOwner) external view returns (bool);
}
//----------------------------------------------------------------------------------------------------
interface IEpigeonNFT {
    function isTokenizedPigeon(address pigeon) external view returns (bool);
}
//----------------------------------------------------------------------------------------------------
interface INameAndPublicKeyDirectory {
    function getPublicKeyForAddress (address owner) external view returns (string key); 
    function getUserNameForAddress (address owner) external view returns (string name);
}
//----------------------------------------------------------------------------------------------------
interface IPigeonDestinationDirectory{
    function changeToAddress(address newToAddress, address oldToAddress) external;
    function setToAddress(address newToAddress) external;
    function deleteToAddress(address oldToAddress) external;
    function deleteToAddressByEpigeon(address pigeon) external;
    function pigeonsSentToAddressLenght(address toAddress) external view returns (uint256 length);
    function pigeonSentToAddressByIndex(address toAddress, uint index) external view returns (address pigeonAddress);   
}
//----------------------------------------------------------------------------------------------------
interface IPigeonManagerDirectory{
    function changeManager(address newManager, address oldManager) external;
    function deleteManager(address oldManager) external;
    function setManager(address newManager) external;
    function pigeonsOfManagerLenght(address toAddress) external view returns (uint256 length);
    function pigeonOfManagerByIndex(address toAddress, uint index) external view returns (address pigeonAddress);   
}
//----------------------------------------------------------------------------------------------------

