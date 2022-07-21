// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./AccessControl.sol";
import "./Ownable.sol";

contract Bridge is AccessControl, Ownable {
    bytes32 public CONTRACT_DOMAIN;
    address public signer;
    mapping(bytes32 => bytes32) public bridgeHash;

    event SingerChange(address indexed signer, uint256 indexed time);

    struct EIP712Domain {
        string name;
        string version;
        uint256 chainId;
        address verifyingContract;
    }

    constructor() {
        uint256 chainId;
        assembly {
            chainId := chainid()
        }
        CONTRACT_DOMAIN = _hashDomain(
            EIP712Domain({
                name: "PERSONAnimals",
                version: "1",
                chainId: chainId,
                verifyingContract: address(this)
            })
        );
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function setSigner(address account_) public onlyOwner {
        signer = account_;

        emit SingerChange(account_, block.timestamp);
    }

    function _hashDomain(EIP712Domain memory eip712Domain_)
        internal
        pure
        returns (bytes32)
    {
        return
            keccak256(
                abi.encode(
                    keccak256(
                        "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                    ),
                    keccak256(bytes(eip712Domain_.name)),
                    keccak256(bytes(eip712Domain_.version)),
                    eip712Domain_.chainId,
                    eip712Domain_.verifyingContract
                )
            );
    }

    function _hashMaps(
        uint256 tokenId,
        uint256 timestamp,
        uint256 chainId,
        address caller
    ) internal pure returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    keccak256(
                        "BridgeInfo(uint256 tokenId,uint256 timestamp,uint256 chainId,address caller)"
                    ),
                    tokenId,
                    timestamp,
                    chainId,
                    caller
                )
            );
    }

    function _verifyInput(
        uint256 tokenId,
        uint256 timestamp,
        uint256 chainId,
        uint8 v,
        bytes32 r,
        bytes32 s,
        bytes32 code
    ) internal view {
        bytes32 hashStruct = _hashMaps(
            tokenId,
            timestamp,
            chainId,
            _msgSender()
        );
        bytes32 hash = keccak256(
            abi.encodePacked("\x19\x01", CONTRACT_DOMAIN, hashStruct)
        );
        require(hash == code, "Hash code error");
        address signerInput = ecrecover(hash, v, r, s);
        require(signer == signerInput, "Verify address error");
    }
}
