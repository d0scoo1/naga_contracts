// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../Kohi/VertexData.sol";
import "../Kohi/Matrix.sol";

struct RenderUniverseArgs {
    int64 x;
    int64 y;
    int64 angle;
    int64 size;
    uint32 tint;    
    Matrix rectify;
    VertexData[] path;
}

