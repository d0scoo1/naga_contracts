// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./interfaces/IONFT721.sol";
import "./lzApp/NonblockingLzApp.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ONFT721 is IONFT721, NonblockingLzApp, ERC721 {

    constructor(
      string memory _name, 
      string memory _symbol, 
      address _lzEndpoint
    ) ERC721(_name, _symbol) NonblockingLzApp(_lzEndpoint) {}

    function estimateSendFee(
      uint16 _dstChainId, 
      bytes calldata _toAddress, 
      uint _tokenId, 
      bool _useZro, 
      bytes calldata _adapterParams
    ) public view virtual override returns (uint nativeFee, uint zroFee) {
        // mock the payload for send()
        bytes memory payload = abi.encode(_toAddress, _tokenId);
        return lzEndpoint.estimateFees(_dstChainId, address(this), payload, _useZro, _adapterParams);
    }

    function sendFrom(
      address _from, 
      uint16 _dstChainId, 
      bytes calldata _toAddress, 
      uint _tokenId, 
      address payable _refundAddress, 
      address _zroPaymentAddress, 
      bytes calldata _adapterParams
    ) public payable virtual override {
        _send(_from, _dstChainId, _toAddress, _tokenId, _refundAddress, _zroPaymentAddress, _adapterParams);
    }

    function send(
      uint16 _dstChainId, 
      bytes calldata _toAddress, 
      uint _tokenId, 
      address payable _refundAddress, 
      address _zroPaymentAddress, 
      bytes calldata _adapterParams
    ) public payable virtual override {
        _send(_msgSender(), _dstChainId, _toAddress, _tokenId, _refundAddress, _zroPaymentAddress, _adapterParams);
    }

    function _send(
      address _from, 
      uint16 _dstChainId, 
      bytes memory _toAddress, 
      uint _tokenId, 
      address payable _refundAddress, 
      address _zroPaymentAddress, 
      bytes calldata _adapterParams
    ) internal virtual {
        require(_isApprovedOrOwner(_msgSender(), _tokenId), "ONFT721: send caller is not owner nor approved");
        require(ERC721.ownerOf(_tokenId) == _from, "ONFT721: send from incorrect owner");
        _beforeSend(_from, _dstChainId, _toAddress, _tokenId);

        bytes memory payload = abi.encode(_toAddress, _tokenId);
        _lzSend(_dstChainId, payload, _refundAddress, _zroPaymentAddress, _adapterParams);

        uint64 nonce = lzEndpoint.getOutboundNonce(_dstChainId, address(this));
        emit SendToChain(_from, _dstChainId, _toAddress, _tokenId, nonce);
        _afterSend(_from, _dstChainId, _toAddress, _tokenId);
    }

    function _nonblockingLzReceive(
      uint16 _srcChainId, 
      bytes memory _srcAddress, 
      uint64 _nonce, 
      bytes memory _payload
    ) internal virtual override {
        _beforeReceive(_srcChainId, _srcAddress, _payload);

        // decode and load the toAddress
        (bytes memory toAddressBytes, uint tokenId) = abi.decode(_payload, (bytes, uint));
        address toAddress;
        assembly {
            toAddress := mload(add(toAddressBytes, 20))
        }

        _afterReceive(_srcChainId, toAddress, tokenId);

        emit ReceiveFromChain(_srcChainId, toAddress, tokenId, _nonce);
    }

    function _beforeSend(
        address, /* _from */
        uint16, /* _dstChainId */
        bytes memory, /* _toAddress */
        uint _tokenId
    ) internal virtual {
        _burn(_tokenId);
    }

    function _afterSend(
        address, /* _from */
        uint16, /* _dstChainId */
        bytes memory, /* _toAddress */
        uint /* _tokenId */
    ) internal virtual {}

    function _beforeReceive(
        uint16, /* _srcChainId */
        bytes memory, /* _srcAddress */
        bytes memory /* _payload */
    ) internal virtual {}

    function _afterReceive(
        uint16, /* _srcChainId */
        address _toAddress,
        uint _tokenId
    ) internal virtual {
        _safeMint(_toAddress, _tokenId);
    }
}