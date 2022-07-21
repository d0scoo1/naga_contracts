// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ONFT standard
 */
interface IONFT1155 {
    event SendToChain(address indexed _sender, uint16 indexed _dstChainId, bytes indexed _toAddress, uint _tokenId, uint _amount, uint64 _nonce);
    event SendBatchToChain(address indexed _sender, uint16 indexed _dstChainId, bytes indexed _toAddress, uint[] _tokenIds, uint[] _amounts, uint64 _nonce);
    event ReceiveFromChain(uint16 _srcChainId, address _toAddress, uint _tokenId, uint _amount, uint64 _nonce);
    event ReceiveBatchFromChain(uint16 _srcChainId, address _toAddress, uint[] _tokenIds, uint[] _amounts, uint64 _nonce);

    // _dstChainId - L0 defined chain id to send tokens too
    // _toAddress - dynamic bytes array which contains the address to whom you are sending tokens to on the dstChain
    // _tokenId - token Id to transfer
    // _amount - amount of the tokens to transfer
    // _refundAddress - address on src that will receive refund for any overpayment of L0 fees
    // _zroPaymentAddress - if paying in zro, pass the address to use. using 0x0 indicates not paying fees in zro
    // _adapterParam - flexible bytes array to indicate messaging adapter services in L0
    function send(uint16 _dstChainId, bytes calldata _toAddress, uint _tokenId, uint amount, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParam) external payable;

    // _dstChainId - L0 defined chain id to send tokens too
    // _toAddress - dynamic bytes array which contains the address to whom you are sending tokens to on the dstChain
    // _tokenIds - token Ids to transfer
    // _amounts - amounts of the tokens to transfer
    // _refundAddress - address on src that will receive refund for any overpayment of L0 fees
    // _zroPaymentAddress - if paying in zro, pass the address to use. using 0x0 indicates not paying fees in zro
    // _adapterParam - flexible bytes array to indicate messaging adapter services in L0
    function sendBatch(uint16 _dstChainId, bytes calldata _toAddress, uint[] memory _tokenIds, uint[] memory amounts, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParam) external payable;

    // _dstChainId - L0 defined chain id to send tokens too
    // _toAddress - dynamic bytes array which contains the address to whom you are sending tokens to on the dstChain
    // _tokenId - token Id to transfer
    // _amount - amount of the tokens to transfer
    // _useZro - indicates to use zro to pay L0 fees
    // _adapterParam - flexible bytes array to indicate messaging adapter services in L0
    function estimateSendFee(uint16 _dstChainId, bytes calldata _toAddress, uint _tokenId, uint _amount, bool _useZro, bytes calldata _adapterParams) external view returns (uint nativeFee, uint zroFee);

    // _dstChainId - L0 defined chain id to send tokens too
    // _tokenIds - tokens Id to transfer
    function estimateSendBatchFee(uint16 _dstChainId, uint[] memory _tokenIds, bytes calldata _adapterParams) external view returns (uint nativeFee, uint zroFee);
}