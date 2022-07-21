pragma solidity ^0.6.6;

// ROCKET SHIBA TOKEN
// JOIN THE FASTEST GROWING MEME COMMUNITY

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}