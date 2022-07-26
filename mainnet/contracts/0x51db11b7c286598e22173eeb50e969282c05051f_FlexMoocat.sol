pragma solidity ^0.5.0;

interface IMooncatLike {
    function catOwners(bytes5) external view returns (address);
}

contract FlexMoocat {
    address public owner = 0xA1Ed76f128084e70C683eB86b1A61FeFdc49268F;

    struct ActiveFlex {
        address flexer;
        uint256 flexAmount;
        bytes5 id;
        uint256 flexEndTime;
    }

    bool public paused = false;

    ActiveFlex public flex;

    event NewFlex(
        address indexed _flexer,
        bytes5 _id,
        uint256 _value,
        uint256 _days
    );

     event RevokeFlex(
        address indexed _address,
        bytes5 _id,
        uint256 _days
    );


    modifier onlyDegenData {
        require(
            msg.sender == 0xA1Ed76f128084e70C683eB86b1A61FeFdc49268F,
            "Excuse me, This doesn't belong to you"
        );
        _;
    }

    modifier isPaused {
        require(
            paused == false,
            "sorry we have pause things for now. Too much Flexing is going on."
        );
        _;
    }

    function flexMooncat(bytes5 _id) public payable isPaused {
        require(msg.value > .1 ether, "Minimum Flex is > .1 ETH.");
        require(
            IMooncatLike(0x60cd862c9C687A9dE49aecdC3A99b74A4fc54aB6).catOwners(
                _id
            ) == msg.sender,
            "Sender has to be the owner of the MoonCat"
        );
        require(
            msg.value > flex.flexAmount,
            "You Gotta Flex more than the Current Flex."
        );
        require(
            block.timestamp > flex.flexEndTime,
            "You gotta Wait your turn to flex"
        );
        flex.flexAmount = msg.value;
        flex.flexer = msg.sender;
        flex.id = _id;
        flex.flexEndTime = block.timestamp + 1 days;
        emit NewFlex(msg.sender, _id, msg.value, flex.flexEndTime);
    }

    function contractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function withdraw() public onlyDegenData {
        msg.sender.transfer(address(this).balance);
    }

    function pause(bool _bool) public onlyDegenData {
        paused = _bool;
    }

    function revokeFlex(bytes5 _id) public isPaused {
        require(
            IMooncatLike(0x60cd862c9C687A9dE49aecdC3A99b74A4fc54aB6).catOwners(
                _id
            ) == msg.sender,
            "Sender has to be the owner of the MoonCat"
        );
        emit RevokeFlex(msg.sender, _id, block.timestamp);
    }
}