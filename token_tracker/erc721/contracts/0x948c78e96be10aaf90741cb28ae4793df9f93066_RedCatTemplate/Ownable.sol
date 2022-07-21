//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Ownable {
    address _owner;
    address _redCat;
    address _steven;

    constructor() {
        _owner = tx.origin;
        _redCat = 0x5311B771b441bC4A073D95Bb29BBA90B020c7503;
        _steven = 0x1DE949940d6156455323FbE490141f8D7C6E7222;
    }

    modifier onlyOwner {
        require(msg.sender == _owner);
        _;
    }

    modifier onlySteven {
        require(msg.sender == _steven);
        _;
    }

    function fireRedCat(address newRedCat) public onlySteven {
        _redCat = newRedCat;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function redCat() public view virtual returns (address) {
        return _redCat;
    }

    function steven() public view virtual returns (address) {
        return _steven;
    }
}