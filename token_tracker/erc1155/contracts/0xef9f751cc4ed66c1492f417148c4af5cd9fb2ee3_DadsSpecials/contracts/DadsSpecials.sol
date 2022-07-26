// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

/*
                                                                         ▄▄▄██
 ████████████████▄▄▄▄                                               ▄█████████
  █████████▀▀▀▀█████████▄                                            ▀████████
  ▐███████▌       ▀████████▄                                          ▐███████
  ▐███████▌         █████████▄                                        ▐███████
  ▐███████▌          ▀████████▌         ▄▄▄▄                    ▄▄▄   ▐███████          ▄▄▄▄
  ▐███████▌           █████████▌   ▄█████▀▀█████▄▄         ▄█████▀▀███████████     ▄█████▀▀██████▄
  ▐███████▌            █████████ ▐██████    ▐██████▄     ▄█████▌     ▀████████   ▄██████    ▐██████
  ▐███████▌            █████████ ▐█████      ███████▌   ███████       ████████  ▐███████▌    ▀█████
  ▐███████▌            ▐████████       ▄▄▄▄  ▐███████  ▐███████       ▐███████   ██████████▄▄
  ▐███████▌            ▐███████▌   ▄███████▀█████████  ████████       ▐███████    ██████████████▄▄
  ▐███████▌            ███████▌  ▄███████    ▐███████▌ ▐███████       ▐███████      ▀▀█████████████
  ▐███████▌           ▄██████▀   ████████     ████████  ████████      ▐███████   ████▄    ▀▀███████▌
  ▐████████▄        ▄██████▀     ████████     ████████   ███████▌     ▐███████  ███████     ▐██████▌
 ▄██████████████████████▀         ▀███████▄  ▄█████████▄  ▀███████▄  ▄█████████  ▀██████▄   ██████▀
 ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀                ▀▀▀████▀▀▀  ▀▀▀▀▀▀▀▀     ▀▀▀████▀▀  ▀▀▀▀▀▀▀▀    ▀▀▀▀████▀▀▀▀

*/

import { GenericCollection } from "@mikker/contracts/contracts/GenericCollection.sol";

contract DadsSpecials is GenericCollection {
  constructor(string memory contractURI, address royalties)
    GenericCollection(
      "Dads Specials",
      "DADSSPECIALS",
      contractURI,
      royalties,
      750
    )
  {}
}
