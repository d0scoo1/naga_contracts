// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../utils/Data.sol";

library Colors {
    using Data for Data.Reader;

    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length of 6.
     */
    function _toHexString(uint256 value) private pure returns (string memory) {
        bytes memory buffer = new bytes(7);
        buffer[0] = "#";
        for (uint256 i = 6; i > 0; i--) {
            buffer[i] = _HEX_SYMBOLS[value & 0xF];
            value >>= 4;
        }
        return string(buffer);
    }

    function get(uint256 i) internal pure returns (string memory) {
        bytes
            memory data = "\xec\x8f\x51\xfc\xd6\xbb\xf4\x52\x52\x1e\xdc\x70\x49\xa4\xe9\xc9\xa4\xff\xff\xff\x00\xe0\xf0\xff\x43\x49\x56\xff\x9a\x57\xff\x78\x1f\xff\x7a\x7a\xed\x34\x34\x7a\xff\x95\xa3\xf4\xff\x24\xa0\xff\x9a\x57\xff\xff\xff\x61\xbd\xcf\xe0\xc3\xd1\xbe\x9d\xa8\x99\xc2\xac\x99\xc2\x99\x99\x99\xc2\x9c\x99\x9e\xc2\xa9\xa1\xd1\xc2\xbe\x99\x8e\xa4\xb8\xff\xae\x52\xff\x70\x70\x61\xba\xff\xa4\x72\xee\x56\x5e\x71\xff\x96\x1f\x8f\x4e\x19\xff\x52\x52\x9c\x30\x30\x00\xff\x6e\x2a\xac\x62\x47\xc2\xff\x2a\x62\xac\xd6\x99\xff\x93\x3e\xcc\xab\xa2\x29\x00\x00\x00\xc4\xbc\xa5\xea\xb3\xb3\xd2\xe6\xad\xba\xc2\xfd\xd0\xc7\xff\xe6\xe1\xb3\xff\x9e\x9e\x8f\xce\xff\xfd\xf7\xba\xff\xff\xff\xff\xcd\x1e\x73\x29\x87\x29\x2a\x2e\xe4\xff\xb3\xff\xc2\xc2\x81\x86\x92\xeb\xa7\xe8\xff\x81\xff\xb0\x6d\x00\xff\x36\x7c\x9c\xcd\xe2\x00\x31\x45\x00\x30\x44\x45\xcf\xf2\x00\x4f\x63\x47\xa6\xff\x00\x2f\x5c\x2e\x6d\xff\x0d\x23\x54\x91\xf2\xaa\x00\x3d\x26\x17\xcf\x7f\x00\x4d\x36\xec\xdd\x7e\x63\x5a\x36\x61\x58\x35\xfb\xcd\x28\x5c\x42\x2d";
        Data.Reader memory reader = Data.Reader(i * 3);

        return _toHexString(reader.nextUint24(data));
    }
}
