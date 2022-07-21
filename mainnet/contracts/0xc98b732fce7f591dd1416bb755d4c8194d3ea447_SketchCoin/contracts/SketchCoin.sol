pragma solidity 0.5.2;

import "./CustomToken.sol";

contract SketchCoin is CustomToken {
    uint8 private DECIMALS = 18; //자리수
    uint256 private MAX_TOKEN_COUNT = 10000000000;   // 총 토큰 개수
    uint256 private MAX_SUPPLY = MAX_TOKEN_COUNT * (10 ** uint256(DECIMALS)); //총 발행량
    uint256 private INITIAL_SUPPLY = MAX_SUPPLY * 1 / 1; //초기 공급량

    bool private issued = false;

    constructor()
        CustomToken("SketchCoin", "SKT", DECIMALS, MAX_SUPPLY)
        public {
            require(issued == false);
            super.mint(msg.sender, INITIAL_SUPPLY);
            issued = true;
    }

}
