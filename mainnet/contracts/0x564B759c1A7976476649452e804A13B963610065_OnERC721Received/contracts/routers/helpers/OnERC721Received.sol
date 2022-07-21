pragma solidity 0.7.5;

import "../../AugustusStorage.sol";
import "../IRouter.sol";

contract OnERC721Received is AugustusStorage, IRouter {
    constructor() public {}

    function initialize(bytes calldata data) external override {
        revert("METHOD NOT IMPLEMENTED");
    }

    function getKey() external pure override returns (bytes32) {
        return keccak256(abi.encodePacked("onERC721Received", "1.0.0"));
    }

    bytes4 constant ERC721_RECEIVED = bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) public returns (bytes4) {
        return ERC721_RECEIVED;
    }
}
