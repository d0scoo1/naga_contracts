//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "../ImageAndDescription.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract DesignCommunity1 is ImageAndDescription {

    constructor(address _parent) ImageAndDescription(_parent) {}

    function image(uint256) external override view onlyParent returns (string memory) {
        return string(
            abi.encodePacked(
                '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 400 400" xml:space="preserve">',
                    '<style>',
                        'svg{font-family: monospace;}',
                        '.ringtext{letter-spacing: 1.5px;font-size: 15px;fill: #ffffff;}',
                        '.cointext{letter-spacing: 9px;font-size: 28px;text-anchor: middle;fill: #ffffff;}',
                        '.obverse{letter-spacing: 2px;font-size: 18px;text-anchor: middle;fill: #ffffff;}',
                        '.star{font-size: 30px;}',
                    '</style>',
                    '<defs>',
                        '<path id="ring" d="M80,200a120,120 0 1,0 240,0a120,120 0 1,0 -240,0" fill="none"/>',
                        '<clipPath id="clip1"><rect x="300" y="0" width="100" height="400">',
                            '<animate attributeName="x" values="300;300;0;0" keyTimes="0;.5;.8;1" dur="8s" repeatCount="indefinite"/>',
                            '<animate attributeName="width" values="100;100;300;100" keyTimes="0;.5;.8;1" dur="8s" repeatCount="indefinite"/>',
                        '</rect></clipPath>',
                        '<clipPath id="clip2"><rect x="300" y="0" width="100" height="400">',
                            '<animate attributeName="x" values="300;0;0;0" keyTimes="0;.3;.5;1" dur="8s" repeatCount="indefinite"/>',
                            '<animate attributeName="width" values="100;300;100;100" keyTimes="0;.3;.5;1" dur="8s" repeatCount="indefinite"/>',
                        '</rect></clipPath>',
                        '<radialGradient id="background">',
                        '<stop offset="0%" style="stop-color:#5743A7;" />',
                        '<stop offset="100%" style="stop-color:#1D0E47;" />',
                        '</radialGradient>',
                    '</defs>',
                    '<rect width="400" height="400" fill="url(#background)"/>',
                    '<text>',
                        '<textPath xlink:href="#ring"><tspan class="ringtext">TOKEN OF APPRECIATION \u2726 TOKEN OF APPRECIATION \u2726 TOKEN OF APPRECIATION \u2726</tspan></textPath>',
                        '<animateTransform attributeName="transform" type="rotate" from="360 200 200" to="0 200 200" dur="74s" repeatCount="indefinite"/>',
                    '</text>',
                    '<g>'
                        '<ellipse cx="185" cy="200" rx="0" ry="88" fill="#6026FE">',
                            '<animate attributeName="cx" values="185;200;215" keyTimes="0;.5;1" dur="4s" repeatCount="indefinite" calcMode="spline" keySplines="0.5 0.5 0.5 1; 0.5 0 0.5 0.5"/>',
                            '<animate attributeName="rx" values="0;88;0" keyTimes="0;.5;1" dur="4s" repeatCount="indefinite" calcMode="spline" keySplines="0.5 0.5 0.5 1; 0.5 0 0.5 0.5"/>',
                            '<animate attributeName="fill" values="#6026FE;#2A0295;#6026FE" keyTimes="0;.5;1" dur="4s" repeatCount="indefinite" calcMode="spline" keySplines="0.5 0.5 0.5 1; 0.5 0 0.5 0.5"/>',
                        '</ellipse>',
                        '<rect x="185" y="112" width="30" height="176" fill="#6026FE">',
                            '<animate attributeName="x" values="185;200;185;200;185" keyTimes="0;.25;.5;.75;1" dur="8s" repeatCount="indefinite" calcMode="spline" keySplines="0.5 0.5 0.5 1; 0.5 0 0.5 0.5;0.5 0.5 0.5 1; 0.5 0 0.5 0.5"/>',
                            '<animate attributeName="width" values="30;0;30;0;30" keyTimes="0;.25;.5;.75;1" dur="8s" repeatCount="indefinite" calcMode="spline" keySplines="0.5 0.5 0.5 1; 0.5 0 0.5 0.5;0.5 0.5 0.5 1; 0.5 0 0.5 0.5"/>',
                            '<animate attributeName="fill" values="#6026FE;#2A0295;#6026FE;#2A0295;#6026FE" keyTimes="0;.25;.5;.75;1" dur="8s" repeatCount="indefinite" calcMode="spline" keySplines="0.5 0.5 0.5 1; 0.5 0 0.5 0.5;0.5 0.5 0.5 1; 0.5 0 0.5 0.5"/>',
                        '</rect>',
                        '<ellipse cx="215" cy="200" rx="0" ry="88" fill="#160051">',
                            '<animate attributeName="cx" values="215;200;185" keyTimes="0;.5;1" dur="4s" repeatCount="indefinite" calcMode="spline" keySplines="0.5 0.5 0.5 1; 0.5 0 0.5 0.5"/>',
                            '<animate attributeName="rx" values="0;88;0" keyTimes="0;.5;1" dur="4s" repeatCount="indefinite" calcMode="spline" keySplines="0.5 0.5 0.5 1; 0.5 0 0.5 0.5"/>',
                            '<animate attributeName="fill" values="#160051;#5D59FF;#160051" keyTimes="0;.5;1" dur="4s" repeatCount="indefinite" calcMode="spline" keySplines="0.5 0.5 0.5 1; 0.5 0 0.5 0.5"/>',
                        '</ellipse>',
                    '</g>',
                    '<g clip-path="url(#clip1)">',
                        '<text transform="translate(200,149)" class="obverse"><tspan class="star" x="0" y="0"></tspan><tspan class="star" x="0" y="20">\u2726</tspan><tspan x="0" y="45">DESIGN</tspan><tspan x="0" y="70">COMMUNITY</tspan><tspan class="star" x="0" y="95"></tspan><tspan class="star" x="0" y="115"></tspan></text>',
                    '</g>',
                    '<g clip-path="url(#clip2)">',
                        '<text transform="translate(200,172)" class="cointext"><tspan>NFT</tspan><tspan x="0" y="34">PAWN</tspan><tspan x="0" y="68">SHOP</tspan></text>',
                    '</g>',
                '</svg>'
                )
            );
    }

    function description(uint256) external override view onlyParent returns (string memory) {
        return string(
            abi.encodePacked(
                "Level 1 Design Community token, given to community members who participated in design discussions and contributed design assets."
                )
            );
    }
}