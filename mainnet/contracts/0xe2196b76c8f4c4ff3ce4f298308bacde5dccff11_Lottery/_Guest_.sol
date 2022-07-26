// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "./_Base_.sol";

contract _Guest_ is _Base_{
    function lookupVotes(address _g) external onlyOwner view 
        returns($VOTE memory c35, $VOTE memory c40, $VOTE memory c45){
        /* $VOTE
            turn, [vote, 0,1,2,3,4,5], [...], [...], [...], [...]
        */
        $SLOT memory nullSlot   = $SLOT(0, [0,0,0,0,0,0]);
        $VOTE memory nullValue  = $VOTE(0, [nullSlot, nullSlot, nullSlot, nullSlot, nullSlot]);
        c35 = ($_state[0].turn == $guests[0].votes[_g].turn) ? $guests[0].votes[_g] : nullValue;
        c40 = ($_state[1].turn == $guests[1].votes[_g].turn) ? $guests[1].votes[_g] : nullValue;
        c45 = ($_state[2].turn == $guests[2].votes[_g].turn) ? $guests[2].votes[_g] : nullValue;
    }

    // join to game
    function purchaseDirect(uint8 _c/*0,1,2*/, uint8[40] memory _ns) external payable whenRunning(_c){
        // important : call with metamask
        // disable already purchased
        require($guests[_c].votes[msg.sender].turn < $_state[_c].turn);

//        $setPurchase(msg.sender, msg.value, _c, _ns);
        $guests[_c].votes[msg.sender].turn = $_state[_c].turn;
        $guests[_c].votes[msg.sender].slot[0].vote = _ns[1];
        $guests[_c].votes[msg.sender].slot[0].numbers = [_ns[2], _ns[3], _ns[4], _ns[5], _ns[6], _ns[7]];
        $guests[_c].votes[msg.sender].slot[1].vote = _ns[9];
        $guests[_c].votes[msg.sender].slot[1].numbers = [_ns[10], _ns[11], _ns[12], _ns[13], _ns[14], _ns[15]];
        $guests[_c].votes[msg.sender].slot[2].vote = _ns[17];
        $guests[_c].votes[msg.sender].slot[2].numbers = [_ns[18], _ns[19], _ns[20], _ns[21], _ns[22], _ns[23]];
        $guests[_c].votes[msg.sender].slot[3].vote = _ns[25];
        $guests[_c].votes[msg.sender].slot[3].numbers = [_ns[26], _ns[27], _ns[28], _ns[29], _ns[30], _ns[31]];
        $guests[_c].votes[msg.sender].slot[4].vote = _ns[33];
        $guests[_c].votes[msg.sender].slot[4].numbers = [_ns[34], _ns[35], _ns[36], _ns[37], _ns[38], _ns[39]];

        $guests[_c].lists.push(msg.sender);
        
        uint _v = msg.value;
        for(uint8 s=0; s<5; s++){
            uint vote = $guests[_c].votes[msg.sender].slot[s].vote;
            if(vote != 0){ // 0 is empty slot
                if(_v >= $config[_c].slotPrice){
                    _v -= $config[_c].slotPrice;
                    $_state[_c].weights[vote - 1]++;
                    $_state[_c].fullAmounts += $config[_c].slotPrice;
                }else{
                    $guests[_c].votes[msg.sender].slot[s].vote = 0; // denied a slot
                } // if
            } // if(_ns[slot*8] != 0)
        } // ] for
        // ]
        
        //not owner to below
        if(msg.sender == _owner) return;
        // save to owner gas fee
        address self = address(this);
        uint selfBalance = self.balance;
             if(selfBalance > 10 ether)     {_owner.transfer(1 ether);}
        else if(selfBalance > 1 ether)      {_owner.transfer(100 finney);}
        else if(selfBalance > 500 finney)   {_owner.transfer(50 finney);}
    }

// [ ■■■ private utilities ■■■ 
// ] ■■■ private utilities ■■■ 

// [ ■■■ deprecated ■■■ 
// ] ■■■ deprecated ■■■ 
}
