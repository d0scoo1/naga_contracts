pragma solidity 0.8.11;

interface IMerkle {
    function leaf(address user) external pure returns (bytes32);
    function verify(bytes32 leaf, bytes32[] memory proof) external view returns (bool);
    function isPermitted(address account, bytes32[] memory proof) external view returns (bool);
    function setRoot(bytes32 _root) external;
}
