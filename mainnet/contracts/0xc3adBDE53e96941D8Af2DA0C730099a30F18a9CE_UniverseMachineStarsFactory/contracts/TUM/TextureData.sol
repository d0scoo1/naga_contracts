// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../Kohi/VertexData.sol";

struct TextureData {
    VertexData[][] vertices;
    uint32[] colors;
}