// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity =0.8.12;

import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract CongruentProxy is ERC1967Proxy {
    constructor(address _logic, bytes memory _data) ERC1967Proxy(_logic, _data){
    }
}
