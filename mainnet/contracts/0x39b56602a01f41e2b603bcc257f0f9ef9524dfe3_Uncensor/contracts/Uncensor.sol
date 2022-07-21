// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @creator: Pak
/// @author: manifold.xyz

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                        //
//                                                                                                                        //
//       ,ad8888ba,   88888888888  888b      88   ad88888ba     ,ad8888ba,    88888888ba   88888888888  88888888ba,       //
//      d8"'    `"8b  88           8888b     88  d8"     "8b   d8"'    `"8b   88      "8b  88           88      `"8b      //
//     d8'            88           88 `8b    88  Y8,          d8'        `8b  88      ,8P  88           88        `8b     //
//     88             88aaaaa      88  `8b   88  `Y8aaaaa,    88          88  88aaaaaa8P'  88aaaaa      88         88     //
//     88             88"""""      88   `8b  88    `"""""8b,  88          88  88""""88'    88"""""      88         88     //
//     Y8,            88           88    `8b 88          `8b  Y8,        ,8P  88    `8b    88           88         8P     //
//      Y8a.    .a8P  88           88     `8888  Y8a     a8P   Y8a.    .a8P   88     `8b   88           88      .a8P      //
//       `"Y8888Y"'   88888888888  88      `888   "Y88888P"     `"Y8888Y"'    88      `8b  88888888888  88888888Y"'       //
//                                                                                                                        //
//                                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Uncensor {

    using Strings for uint256;
    
    string constant private _MESSAGE_TAG = '<MESSAGE>';
    string[] private _imageParts;

    constructor() {
        _imageParts.push("<svg xmlns='http://www.w3.org/2000/svg' width='1000' height='1000' viewBox='0 0 1000 1000'>");
            _imageParts.push("<style>@font-face {font-family: 'C';src: ");
            _imageParts.push("url('data:font/woff2;charset=utf-8;base64,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') format('woff2');");
            _imageParts.push("font-weight: 500; font-style: normal; font-display: swap;}");
            _imageParts.push(".f { width: 100%; height: 100%; }");
            _imageParts.push(".b { fill: whitesmoke; }");
            _imageParts.push(".a { animation: o 2s ease-out forwards; }");
            _imageParts.push("@keyframes o { 10% { opacity: 1; } 100% { opacity: 0; } }");
            _imageParts.push("tspan { fill: black; font-family: 'C'; font-size: 70px; text-transform: uppercase; text-anchor: middle; }");
            _imageParts.push("</style>");
            _imageParts.push("<rect class='b f' />");
            _imageParts.push(_MESSAGE_TAG);
            _imageParts.push("<rect class='b f a' />");
        _imageParts.push("</svg>");
    }

    function metadata(uint256 tokenId, string memory message, uint256 value) external view returns(string memory) {
        return string(abi.encodePacked('data:application/json;utf8,{"name":"Uncensored #',tokenId.toString(),' - ',_toUpperCase(message),'", "description":"',_toUpperCase(message),'", "created_by":"Pak", "image":"data:image/svg+xml;utf8,',
            svg(tokenId, message, value),
            '","attributes":[{"trait_type":"Censored","value":"False"},{"trait_type":"Initial Price","value":',_valueString(value),'}]}'));
    }

    function _toUpperCase(string memory message) private pure returns (string memory) {
        bytes memory messageBytes = bytes(message);
        bytes memory upperMessageBytes = new bytes(messageBytes.length);
        for (uint i = 0; i < messageBytes.length; i++) {
            bytes1 char = messageBytes[i];
            if (char >= 0x61 && char <= 0x7A) {
                // So we add 32 to make it lowercase
                upperMessageBytes[i] = bytes1(uint8(char) - 32);
            } else {
                upperMessageBytes[i] = char;
            }
        }
        return string(upperMessageBytes);
    }

    function _renderLines(string memory message) private pure returns (string memory) {
        // Allocate memory for max number of lines (7) at 18 characters each (126)
        bytes memory lineBytes = new bytes(126);
        uint8[] memory lineLengths = new uint8[](7);
        
        // Compute line count
        bytes memory messageBytes = bytes(message);
        uint8 wordLength;
        uint8 lineLength;
        uint8 lineIndex;
        uint256 messageLastIndex = messageBytes.length-1;
        for (uint i = 0; i <= messageLastIndex; i++) {
            bytes1 char = messageBytes[i];
            if (i == 0 || char != 0x20 || i == messageLastIndex) {
                wordLength += 1;
            }
            if (char == 0x20 || i == messageLastIndex) {
                // Check line length is < 18 after adding new word
                if ((lineLength == 0 && lineLength + wordLength <= 18) || (lineLength + wordLength <= 17)) {
                    // Add into the current lineBytes
                    uint256 lineBytesOffset = lineIndex*18;
                    if (lineLength > 0) {
                       // Additional word, add a space
                       lineBytes[lineBytesOffset+lineLength] = 0x20;
                       lineLength += 1;
                    }
                    for (uint j = 0; j < wordLength; j++) {
                        lineBytes[lineBytesOffset+lineLength+j] = messageBytes[(i == messageLastIndex ? 1 : 0)+i-wordLength+j];
                    }
                    lineLength += wordLength;
                    lineLengths[lineIndex] = lineLength;
                } else {
                    // Word plus existing line length over max
                    if (wordLength > 18) {
                        if (lineLength > 0) {
                            // Move to new line if there have already been words added to this line
                            lineIndex += 1;
                            lineLength = 0;
                        }
                        uint256 lineBytesOffset = lineIndex*18;
                        for (uint j = 0; j < wordLength; j++) {
                            lineLength += 1;
                            lineBytes[lineBytesOffset+(j % 18)] = messageBytes[(i == messageLastIndex ? 1 : 0)+i-wordLength+j];
                            if (j > 0 && j % 18 == 17) {
                                // New line every 18 characters
                                lineLengths[lineIndex] = lineLength;
                                lineIndex += 1;
                                lineLength = 0;
                                lineBytesOffset = lineIndex*18;
                            }
                        }
                        lineLengths[lineIndex] = lineLength;
                    } else {
                        // New line
                        lineIndex += 1;
                        uint256 lineBytesOffset = lineIndex*18;
                        for (uint j = 0; j < wordLength; j++) {
                            lineBytes[lineBytesOffset+j] = messageBytes[(i == messageLastIndex ? 1 : 0)+i-wordLength+j];
                        }
                        lineLength = wordLength;
                        lineLengths[lineIndex] = lineLength;
                    }
                }
                wordLength = 0;
            }
        }

        string memory lines;
        uint8 lineCount;
        for (uint i = 0; i <= lineIndex; i++) {
            uint256 lineBytesOffset = i*18;
            if (lineLengths[i] > 0) {
               lineCount += 1;
               bytes memory line = new bytes(lineLengths[i]);
               for (uint j = 0; j < lineLengths[i]; j++) {
                   line[j] = lineBytes[lineBytesOffset+j];
               }
               if (i == 0) {
                   lines = string(abi.encodePacked(lines,"<tspan x='500'>",line,"</tspan>"));
               } else {
                   lines = string(abi.encodePacked(lines,"<tspan x='500' dy='1em'>",line,"</tspan>"));
               }
            }
        }
        return string(abi.encodePacked("<svg y='",(560-uint256(lineCount)*35).toString(),"' overflow='visible'><text>",lines,"</text></svg>"));
    }

    function _valueString(uint256 value) private pure returns (string memory) {
        uint256 eth = value/10**18;
        uint256 decimal4 = value/10**14 - eth*10**4;
        return string(abi.encodePacked(eth.toString(), '.', _decimal4ToString(decimal4)));
    }

    function _decimal4ToString(uint256 decimal4) private pure returns (string memory) {
        bytes memory decimal4Characters = new bytes(4);
        for (uint i = 0; i < 4; i++) {
            decimal4Characters[3 - i] = bytes1(uint8(0x30 + decimal4 % 10));
            decimal4 /= 10;
        }
        return string(abi.encodePacked(decimal4Characters));
    }

    function svg(uint256, string memory message, uint256) public view returns(string memory) {
        bytes memory byteString;
        for (uint i = 0; i < _imageParts.length; i++) {
            if (_checkTag(_imageParts[i], _MESSAGE_TAG)) {
                byteString = abi.encodePacked(byteString, _renderLines(message));
            } else {
                byteString = abi.encodePacked(byteString, _imageParts[i]);
            }
        }
        return string(byteString);
    }

    function _checkTag(string storage a, string memory b) private pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }
}
