// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title TinyKingdoms
 * @dev Metadata contract for 0x788defd1AE1e2299D54CF9aC3658285Ab1dA0900 by @emrecolako
 */
import "@openzeppelin/contracts/access/Ownable.sol";

contract TinyKingdomsMetadata is Ownable{

    using strings for string;
    using strings for strings.slice;

    address public immutable TinyKingdoms = 0x788defd1AE1e2299D54CF9aC3658285Ab1dA0900;
    string public description = "Tiny Kingdoms Metadata";

    // Tiny Kingdoms Flags
    string private constant Flags="Rising Sun_Vertical Triband_Chevron_Nordic Cross_Spanish Fess_Five Stripes_Hinomaru_Vertical Bicolor_Saltire_Horizontal Bicolor_Vertical Misplaced Bicolor_Bordure_Inverted Pall_Twenty-four squared_Diagonal Bicolor_Horizontal Triband_Diagonal Bicolor Inverse_Quadrisection_Diagonal Tricolor Inverse_Rising Split Sun_Lonely Star_Diagonal Bicolor Right_Horizontal Bicolor with a star_Bonnie Star_Jolly Roger";
    string private constant Nouns="Eagle_Meditation_Folklore_Star_Light_Play_Palace_Wildflower_Rescue_Fish_Painting_Shadow_Revolution_Planet_Storm_Land_Surrounding_Spirit_Ocean_Night_Snow_River_Sheep_Poison_State_Flame_River_Cloud_Pattern_Water_Forest_Tactic_Fire_Strategy_Space_Time_Art_Stream_Spectrum_Fleet_Ship_Spring_Shore_Plant_Meadow_System_Past_Parrot_Throne_Ken_Buffalo_Perspective_Tear_Moon_Moon_Wing_Summer_Broad_Owls_Serpent_Desert_Fools_Spirit_Crystal_Persona_Dove_Rice_Crow_Ruin_Voice_Destiny_Seashell_Structure_Toad_Shadow_Sparrow_Sun_Sky_Mist_Wind_Smoke_Division_Oasis_Tundra_Blossom_Dune_Tree_Petal_Peach_Birch_Space_Flower_Valley_Cattail_Bulrush_Wilderness_Ginger_Sunset_Riverbed_Fog_Leaf_Fruit_Country_Pillar_Bird_Reptile_Melody_Universe_Majesty_Mirage_Lakes_Harvest_Warmth_Fever_Stirred_Orchid_Rock_Pine_Hill_Stone_Scent_Ocean_Tide_Dream_Bog_Moss_Canyon_Grave_Dance_Hill_Valley_Cave_Meadow_Blackthorn_Mushroom_Bluebell_Water_Dew_Mud_Family_Garden_Stork_Butterfly_Seed_Birdsong_Lullaby_Cupcake_Wish_Laughter_Ghost_Gardenia_Lavender_Sage_Strawberry_Peaches_Pear_Rose_Thistle_Tulip_Wheat_Thorn_Violet_Chrysanthemum_Amaranth_Corn_Sunflower_Sparrow_Sky_Daisy_Apple_Oak_Bear_Pine_Poppy_Nightingale_Mockingbird_Ice_Daybreak_Coral_Daffodil_Butterfly_Plum_Fern_Sidewalk_Lilac_Egg_Hummingbird_Heart_Creek_Bridge_Falling Leaf_Lupine_Creek_Iris Amethyst_Ruby_Diamond_Saphire_Quartz_Clay_Coal_Briar_Dusk_Sand_Scale_Wave_Rapid_Pearl_Opal_Dust_Sanctuary_Phoenix_Moonstone_Agate_Opal_Malachite_Jade_Peridot_Topaz_Turquoise_Aquamarine_Amethyst_Garnet_Diamond_Emerald_Ruby_Sapphire_Typha_Sedge_Wood";
    string private constant Adjectives="Central_Free_United_Socialist_Ancient Republic of_Third Republic of_Eastern_Cyber_Northern_Northwestern_Galactic Empire of_Southern_Solar_Islands of_Kingdom of_State of_Federation of_Confederation of_Alliance of_Assembly of_Region of_Ruins of_Caliphate of_Republic of_Province of_Grand_Duchy of_Capital Federation of_Autonomous Province of_Free Democracy of_Federal Republic of_Unitary Republic of_Autonomous Regime of_New_Old Empire of";
    string private constant Suffixes="Beach_Center_City_Coast_Creek_Estates_Falls_Grove_Heights_Hill_Hills_Island_Lake_Lakes_Park_Point_Ridge_River_Springs_Valley_Village_Woods_Waters_Rivers_Points_ Mountains_Volcanic Ridges_Dunes_Cliffs_Summit";
    
    uint256[21] colorPalettes = [ 
        0x006d7783c5beffddd2faf2e5, //["#006d77", "#83c5be", "#ffddd2", "#faf2e5"], 
        0x351f39726a95719fb0f6f417, //["#351f39", "#726a95", "#719fb0", "#f6f4ed"]
        0x472e2ae78a46fac459fcefdf, //["#472e2a", "#e78a46", "#fac459", "#fcefdf"]
        0x0d1b2a2f48657b88a7fff8e7, //["#0d1b2a", "#2f4865", "#7b88a7", "#fff8e7"]
        0xe95145f8b917ffb2a2f0f0e8, //["#e95145", "#f8b917", "#ffb2a2", "#f0f0e8"]
        0xc54e84f0bf363a67c2f6f1ec, //["#c54e84", "#f0bf36", "#3a67c2", "#f6f1ec"]
        0xe66357497fe38ea5fff1f0f0, //["#e66357", "#497fe3", "#8ea5ff", "#f1f0f0"]
        0xed7e62f4b6744d598bf3eded, //["#ed7e62", "#f4b674", "#4d598b", "#f3eded"]
        0xd3ee9e00683896cf24fbfbf8, //["#d3ee9e", "#006838", "#96cf24", "#fbfbf8"]
        0xffe8f58756d1d8709cfaf2e5, //["#ffe8f5", "#8756d1", "#d8709c", "#faf2e5"]
        0x533549f6b042f9ed4ef6f4ed, //["#533549", "#f6b042", "#f9ed4e", "#f6f4ed"]
        0x8175a3a3759e443c5bfcefdf, //["#8175a3", "#a3759e", "#443c5b", "#fcefdf"]
        0x788ea53d4c5c7b5179fff8e7, //["#788ea5", "#3d4c5c", "#7b5179", "#fff8e7"]
        0x553c60ffb0a0ff6749f0f0e8, //["#553c60", "#ffb0a0", "#ff6749", "#f0f0e8"]
        0x99c1b249c293467462f6f1ec, //["#99c1b2", "#49c293", "#467462", "#f6f1ec"]
        0xecbfaf0177240e2733f1f0f0, //["#ecbfaf", "#017724", "#0e2733", "#f1f0f0"]
        0xd2deb1567bae60bf3cf3eded, //["#d2deb1", "#567bae", "#60bf3c", "#f3eded"]
        0xfde50058bdbceff0ddfbfbf8, //["#fde500", "#58bdbc", "#eff0dd", "#fbfbf8"]
        0x2f2043f76975e7e8cbfaf2e5, //["#2f2043", "#f76975", "#e7e8cb", "#faf2e5"]
        0x5ec227302f3563bdb3f6f4ed, //["#5ec227", "#302f35", "#63bdb3", "#f6f4ed"]
        0x75974ac83e3cf39140fcefdf  //["#75974a", "#c83e3c", "#f39140", "#fcefdf"]
        ];

    /**
     * @notice Get Flag names for each Kingdom
     */
    
     function getFlag(uint256 index) internal pure returns (string memory) {
        strings.slice memory strSlice = Flags.toSlice();
        string memory separatorStr = "_";
        strings.slice memory separator = separatorStr.toSlice();
        strings.slice memory item;

        for (uint256 i = 0; i <= index; i++) {
            item = strSlice.split(separator);
        }
        return item.toString();
    }

    /**
     * @notice Getter functions for constructing Kingdom names
     */

    function getNoun(uint256 index) internal pure returns (string memory) {
        strings.slice memory strSlice = Nouns.toSlice();
        string memory separatorStr = "_";
        strings.slice memory separator = separatorStr.toSlice();
        strings.slice memory item;
        for (uint256 i = 0; i <= index; i++) {
            item = strSlice.split(separator);
        }
        return item.toString();
    }

    function getAdjective(uint256 index) internal pure returns (string memory) {
        strings.slice memory strSlice = Adjectives.toSlice();
        string memory separatorStr = "_";
        strings.slice memory separator = separatorStr.toSlice();
        strings.slice memory item;
        for (uint256 i = 0; i <= index; i++) {
            item = strSlice.split(separator);
        }
        return item.toString();
    }

    function getSuffix(uint256 index) internal pure returns (string memory) {
        strings.slice memory strSlice = Suffixes.toSlice();
        string memory separatorStr = "_";
        strings.slice memory separator = separatorStr.toSlice();
        strings.slice memory item;
        for (uint256 i = 0; i <= index; i++) {
            item = strSlice.split(separator);
        }
        return item.toString();
    }

    /**
     * @notice Get flag index 
     */

    function getFlagIndex(uint256 tokenId) public pure returns (string memory) {
        uint256 rand = random(tokenId,"FLAG") % 1000;
        uint256 flagIndex =0;

        if (rand>980){flagIndex=24;}
        else {flagIndex = rand/40;}
        
        return getFlag(flagIndex);
    }

    /**
     * @notice Check if flag is Jolly Roger
     */
    
    function isPirate(uint256 tokenId) public pure returns (bool flag){
        require(tokenId> 0 && tokenId<4097,"tokenId is invalid");
        if (keccak256(bytes(getFlagIndex(tokenId))) == keccak256(bytes("Jolly Roger"))){
            flag=true;
        } else {
            flag=false;
        }
        return flag;
    }

    /**
     * @notice Returns Kingdom name
     */

    function getKingdom(uint256 tokenId) public pure returns (string memory){
        require(tokenId> 0 && tokenId<4097,"tokenId is invalid");
        
        uint256 rand = random(tokenId,"PLACE");
        string memory a1= (getAdjective((rand / 7) % 35));
        string memory n1= (getNoun((rand / 200) % 229));
        string memory s1;

        if (keccak256(bytes(getFlagIndex(tokenId))) == keccak256(bytes("Jolly Roger"))) {
            s1 = "Pirate Ship";
        } else {
            s1= (getSuffix((rand/11)%30));
        }

        string memory output = string(abi.encodePacked(a1,' ',n1,' ',s1));
        
        return output;
    }

    function getPalette(uint256 tokenId) public view returns (string memory){
        uint256 rand = random(tokenId,"THEME") % 1050;
        uint256 themeIndex;
        uint256 palette;

        if (rand<1000){themeIndex=rand/50;}
        else {themeIndex = 20;}
        
        palette=colorPalettes[themeIndex];        
        
        return uint2hexstr(palette);

    }

      function random(uint256 tokenId, string memory seed) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed, toString(tokenId))));
    }

    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT license
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
    // https://stackoverflow.com/questions/69301408/solidity-convert-hex-number-to-hex-string
    function uint2hexstr(uint i) internal pure returns (string memory) {
        if (i == 0) return "0";
        uint j = i;
        uint length;
        while (j != 0) {
            length++;
            j = j >> 4;
        }
        uint mask = 15;
        bytes memory bstr = new bytes(length);
        uint k = length;
        while (i != 0) {
            uint curr = (i & mask);
            bstr[--k] = curr > 9 ?
                bytes1(uint8(55 + curr)) :
                bytes1(uint8(48 + curr)); // 55 = 65 - 10
            i = i >> 4;
        }
        return string(bstr);
    }
}

/*
 * @title String & slice utility library for Solidity contracts.
 * @author Nick Johnson <arachnid@notdot.net>
 *
 * @dev Functionality in this library is largely implemented using an
 *      abstraction called a 'slice'. A slice represents a part of a string -
 *      anything from the entire string to a single character, or even no
 *      characters at all (a 0-length slice). Since a slice only has to specify
 *      an offset and a length, copying and manipulating slices is a lot less
 *      expensive than copying and manipulating the strings they reference.
 *
 *      To further reduce gas costs, most functions on slice that need to return
 *      a slice modify the original one instead of allocating a new one; for
 *      instance, `s.split(".")` will return the text up to the first '.',
 *      modifying s to only contain the remainder of the string after the '.'.
 *      In situations where you do not want to modify the original slice, you
 *      can make a copy first with `.copy()`, for example:
 *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
 *      Solidity has no memory management, it will result in allocating many
 *      short-lived slices that are later discarded.
 *
 *      Functions that return two slices come in two versions: a non-allocating
 *      version that takes the second slice as an argument, modifying it in
 *      place, and an allocating version that allocates and returns the second
 *      slice; see `nextRune` for example.
 *
 *      Functions that have to copy string data will return strings rather than
 *      slices; these can be cast back to slices for further processing if
 *      required.
 *
 *      For convenience, some functions are provided with non-modifying
 *      variants that create a new slice and return both; for instance,
 *      `s.splitNew('.')` leaves s unmodified, and returns two values
 *      corresponding to the left and right parts of the string.
 */

library strings {
    struct slice {
        uint256 _len;
        uint256 _ptr;
    }

    function memcpy(
        uint256 dest,
        uint256 src,
        uint256 len
    ) private pure {
        // Copy word-length chunks while possible
        for (; len >= 32; len -= 32) {
            assembly {
                mstore(dest, mload(src))
            }
            dest += 32;
            src += 32;
        }

        // Copy remaining bytes
        uint256 mask = 256**(32 - len) - 1;
        assembly {
            let srcpart := and(mload(src), not(mask))
            let destpart := and(mload(dest), mask)
            mstore(dest, or(destpart, srcpart))
        }
    }

    /*
     * @dev Returns a slice containing the entire string.
     * @param self The string to make a slice from.
     * @return A newly allocated slice containing the entire string.
     */
    function toSlice(string memory self) internal pure returns (slice memory) {
        uint256 ptr;
        assembly {
            ptr := add(self, 0x20)
        }
        return slice(bytes(self).length, ptr);
    }

    /*
     * @dev Copies a slice to a new string.
     * @param self The slice to copy.
     * @return A newly allocated string containing the slice's text.
     */
    function toString(slice memory self) internal pure returns (string memory) {
        string memory ret = new string(self._len);
        uint256 retptr;
        assembly {
            retptr := add(ret, 32)
        }

        memcpy(retptr, self._ptr, self._len);
        return ret;
    }
    

    // Returns the memory address of the first byte of the first occurrence of
    // `needle` in `self`, or the first byte after `self` if not found.
    function findPtr(
        uint256 selflen,
        uint256 selfptr,
        uint256 needlelen,
        uint256 needleptr
    ) private pure returns (uint256) {
        uint256 ptr = selfptr;
        uint256 idx;

        if (needlelen <= selflen) {
            if (needlelen <= 32) {
                bytes32 mask = bytes32(~(2**(8 * (32 - needlelen)) - 1));

                bytes32 needledata;
                assembly {
                    needledata := and(mload(needleptr), mask)
                }

                uint256 end = selfptr + selflen - needlelen;
                bytes32 ptrdata;
                assembly {
                    ptrdata := and(mload(ptr), mask)
                }

                while (ptrdata != needledata) {
                    if (ptr >= end) return selfptr + selflen;
                    ptr++;
                    assembly {
                        ptrdata := and(mload(ptr), mask)
                    }
                }
                return ptr;
            } else {
                // For long needles, use hashing
                bytes32 hash;
                assembly {
                    hash := keccak256(needleptr, needlelen)
                }

                for (idx = 0; idx <= selflen - needlelen; idx++) {
                    bytes32 testHash;
                    assembly {
                        testHash := keccak256(ptr, needlelen)
                    }
                    if (hash == testHash) return ptr;
                    ptr += 1;
                }
            }
        }
        return selfptr + selflen;
    }

    /*
     * @dev Splits the slice, setting `self` to everything after the first
     *      occurrence of `needle`, and `token` to everything before it. If
     *      `needle` does not occur in `self`, `self` is set to the empty slice,
     *      and `token` is set to the entirety of `self`.
     * @param self The slice to split.
     * @param needle The text to search for in `self`.
     * @param token An output parameter to which the first token is written.
     * @return `token`.
     */
    function split(
        slice memory self,
        slice memory needle,
        slice memory token
    ) internal pure returns (slice memory) {
        uint256 ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
        token._ptr = self._ptr;
        token._len = ptr - self._ptr;
        if (ptr == self._ptr + self._len) {
            // Not found
            self._len = 0;
        } else {
            self._len -= token._len + needle._len;
            self._ptr = ptr + needle._len;
        }
        return token;
    }

    /*
     * @dev Splits the slice, setting `self` to everything after the first
     *      occurrence of `needle`, and returning everything before it. If
     *      `needle` does not occur in `self`, `self` is set to the empty slice,
     *      and the entirety of `self` is returned.
     * @param self The slice to split.
     * @param needle The text to search for in `self`.
     * @return The part of `self` up to the first occurrence of `delim`.
     */
    function split(slice memory self, slice memory needle)
        internal
        pure
        returns (slice memory token)
    {
        split(self, needle, token);
    }

    
}
