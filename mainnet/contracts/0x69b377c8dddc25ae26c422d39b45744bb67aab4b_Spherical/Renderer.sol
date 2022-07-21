//SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import './SVG.sol';
import './Utils.sol';

/// @title Spherical GeNFTs Renderer
/// @author espina (modified from w1nt3r.eth's hot-chain-svg)
/// @notice contract to render onchain generative SVGs

interface SphereInterface {
    function balanceOf(address owner) external view returns (uint256 balance);
}
interface KarmicInterface {
    function allBalancesOf(address holder) external view returns (uint256[] memory balances);
}

contract Renderer {
    address sphereNFTAddress = address(0x2346358D22b8b59f25A1Cf05BbE86FE762db6134);
    address karmicAddress = address(0xe323C27212F34fCEABBBd98A5f43505dDeC266Dc); 
    SphereInterface sphereInterface = SphereInterface(sphereNFTAddress);
    KarmicInterface karmicInterface = KarmicInterface(karmicAddress);

    struct SphereProps {
        uint stop1;
        string color1;
        string color2;
        uint16 radius;
        uint posY;
        uint ind;
    }

    function _render(uint256 _tokenId, address _owner, uint256 _birthdate) internal view returns (string memory) {
        uint elapsed = (block.timestamp - _birthdate) /  1 weeks;
        uint age = _sqrtu(2 * elapsed) + 3;
        string[2][2] memory colors = _setColors(_tokenId, _owner);
        string memory bgColPick = _bgColor(_owner);
        string memory bordCol;
        if ((keccak256(abi.encodePacked(bgColPick))) == (keccak256(abi.encodePacked('#FFFFFF')))) { 
            bordCol = 'black'; 
            } else {
                bordCol = 'white'; 
        } 

        return
            string.concat(
                string.concat('<svg xmlns="http://www.w3.org/2000/svg" width="1600" height="2400" style="background:', _bgColor(_owner),'">'),
                _sphereGen(_tokenId, _owner, age, colors),
                _drawBorder(bordCol),                
                '</svg>'
            );
    }

    function _setColors(uint256 _tokenId, address _owner) internal pure returns(string[2][2] memory) {
        string[2][2] memory randClr;
        randClr[0][0] = string.concat('hsl(', utils.uint2str(_random(_tokenId, 1, _owner,  'clrs') % 360), ', 36%, 65%, 0%)');
        randClr[0][1] = string.concat('hsl(', utils.uint2str(_random(_tokenId, 1, _owner,  'clrs') % 360), ', 36%, 65%, 78%)');
        randClr[1][0] = string.concat('hsl(', utils.uint2str(_random(_tokenId, 2, _owner,  'clrs') % 360), ', 36%, 65%, 0%)');
        randClr[1][1] = string.concat('hsl(', utils.uint2str(_random(_tokenId, 2, _owner,  'clrs') % 360), ', 36%, 65%, 78%)');
        return randClr;
    }

    function _sphereGen(uint _tokenId, address _owner, uint _age, string[2][2] memory _colors) internal pure returns (string memory) {
        string memory spheresSVG;
        for (uint i = 0; i < _age; i++) {
            SphereProps memory sphereProp;
            uint colorPick = _random(_tokenId, i, _owner, 'r') % 2;
            sphereProp.ind = i;
            sphereProp.stop1 = _random(_tokenId, i, _owner, 'stop1') % 90;
            sphereProp.color1 = _colors[colorPick][0];
            sphereProp.color2 = _colors[colorPick][1];
            sphereProp.radius = uint16(_random(_tokenId, i, _owner, 'r') % ((800) -(186+45)) +45);
            uint16[3] memory yPositions = [
                uint16(sphereProp.radius + 186), 
                uint16(1200), 
                uint16(2400 - 186 -sphereProp.radius)]; //possible sphere positions for top,center, bottom
            sphereProp.posY = yPositions[_random(_tokenId, i, _owner, 'pY') % 3];
            spheresSVG = string.concat(spheresSVG, _spheres(sphereProp));

        }
        return spheresSVG;
    }

    function _spheres(SphereProps memory _sphereProp) internal pure returns(string memory) {
        return string.concat(
            
            svg.radialGradient(
                string.concat(
                    svg.prop('id', string.concat('sphereGradient', utils.uint2str(_sphereProp.ind)))
                ),
                string.concat(
                    svg.gradientStop(80, _sphereProp.color1, utils.NULL), //first stop amount should be random
                    svg.gradientStop(100,_sphereProp.color2,utils.NULL)

                )
            ),

            svg.circle(
                string.concat(
                    svg.prop('cx', utils.uint2str(800)),
                    svg.prop('cy', utils.uint2str(_sphereProp.posY)),
                    svg.prop('r', utils.uint2str(_sphereProp.radius)),
                    svg.prop('fill', string.concat("url('#sphereGradient", utils.uint2str(_sphereProp.ind), "')"))
                ),
                utils.NULL
            )
        );
    }

    function _random(uint _tokenId, uint _ind, address _owner, string memory _prop) internal pure returns (uint) {
        return uint(keccak256(abi.encodePacked(_ind, _owner, _tokenId, _prop)));
    }

    function _bgColor(address _owner) internal view returns (string memory) {
        bool sphereHolder = (sphereInterface.balanceOf(_owner) > 0);
        uint256[] memory karmics = karmicInterface.allBalancesOf(_owner);
        bool karmicHolder = false;
        
        for(uint i = 0; i < karmics.length; i++) {
            if (karmics[i] > 0) { karmicHolder = true; }
        }
        
        if (karmicHolder && sphereHolder) {
            return '#FFFFFF';
        } else if (karmicHolder) {
            return '#733700';
        } else if (sphereHolder) {
            return '#000957';
        } else {
            return '#000000';
        }
    }

    function _drawBorder(string memory _bordCol) internal pure returns(string memory) {
        return 
        string.concat(
            _rects(80,80,1440,2240,_bordCol),
            _rects(106,106,1388,2188,_bordCol),
            _rects(80,80,68,52,_bordCol),
            _rects(1452,80,68,52,_bordCol),
            _rects(80,2268,68,52,_bordCol),
            _rects(1452,2268,68,52,_bordCol)
        );

    }

    function _rects(uint _x, uint _y,uint  _width,uint _height, string memory _bordCol) internal pure returns(string memory) {
        return svg.rect(
            string.concat(
                svg.prop('x', utils.uint2str(_x)),
                svg.prop('y', utils.uint2str(_y)),
                svg.prop('width', utils.uint2str(_width)),
                svg.prop('height', utils.uint2str(_height)),
                svg.prop('stroke', _bordCol),
                svg.prop('fill-opacity', utils.uint2str(0)),
                svg.prop('stroke-width', utils.uint2str(3))
            ),
            utils.NULL
        );
    }

    //Square root function from ABDK Math
    function _sqrtu (uint256 x) internal pure returns (uint128) {
        unchecked {
        if (x == 0) return 0;
        else {
            uint256 xx = x;
            uint256 r = 1;
            if (xx >= 0x100000000000000000000000000000000) { xx >>= 128; r <<= 64; }
            if (xx >= 0x10000000000000000) { xx >>= 64; r <<= 32; }
            if (xx >= 0x100000000) { xx >>= 32; r <<= 16; }
            if (xx >= 0x10000) { xx >>= 16; r <<= 8; }
            if (xx >= 0x100) { xx >>= 8; r <<= 4; }
            if (xx >= 0x10) { xx >>= 4; r <<= 2; }
            if (xx >= 0x8) { r <<= 1; }
            r = (r + x / r) >> 1;
            r = (r + x / r) >> 1;
            r = (r + x / r) >> 1;
            r = (r + x / r) >> 1;
            r = (r + x / r) >> 1;
            r = (r + x / r) >> 1;
            r = (r + x / r) >> 1; // Seven iterations should be enough
            uint256 r1 = x / r;
            return uint128 (r < r1 ? r : r1);
        }
        }
    }

}
