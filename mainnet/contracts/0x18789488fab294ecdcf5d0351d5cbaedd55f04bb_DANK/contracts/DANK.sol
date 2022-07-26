
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Dankus
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                    //
//                                                                                                                                    //
//                                                                                                                                    //
//        ┐───└▀██████████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███▓██████████└────    //
//        └▓▄┌──░█████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███▓█████▀────╒─    //
//        ──╙╦┌░┐└▀███████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▓▀└───────    //
//        ╜═─└╟╗┌───▀██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█╜──────────    //
//        ▄╓──▒─╙╩┐──┌└▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▀─┌────┌────┌─    //
//        ╙▀▀─╝╗──└▓▄─└┌─▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▀─┌───────┌──└└─    //
//        ▓╦▄┌┌└╙╨───╙╗░┌─╙█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▀└────────────╓╓─└    //
//        ╓╟▓┐┌───╗───╙▓▄──┌└▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█┘───────────────────    //
//        ───╙╙▓──░╨╖┌─└▓▓╖─└─└▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣╣╣╣╣╣╣╣╣╣╣╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▀┘────┌────────┌─└──└──    //
//        └└╙──╟╩╩▄──╗───└╙▓▄┐░──▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣╣╣╢╣╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╣╢╢╢╣╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▀─────────┌─────╘═───┌───    //
//        ══─┐┌┌┌─└╨╥▒╢┌───┌└▓▓────╙▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣╣╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╣╣╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╣╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▀───────┌───┌────┌┌┌┌──────    //
//        ──└─└└╙└─└╨▓▄░╙╦─┌─└╝▓▄┌───╚▓▓▓▓▓▓▓▓▓╣╣╢╢╢╢╢╢╢╢╢╣╢╢╢╣╣╢╣▒▒▒▒▒▒▒╢╣╣╢╣╢╢╢╢╢╢╢╢╢╢╢╢╢╣╣▓▓▓▓▓▓▓▓▓────┌────────▄═───└└└──────┌    //
//        ▓▓▓▓═────┌┌───▓▄▓┐────└╙╫┌░─└▓╢▓▓╣╣╣╢╢╢╢╢╢╢╢╢╣╢▒▒▒╣▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒╢╢╢╢╢╢╢╢╢╢╢╢╣╣▓▓▓╜───────────┌╓──┌┌┌───────╟▓▓▓▒    //
//        ░║▓┌─└───└└└└─╙╩▓▓▓──┌└─└╩▄──┐─╙▓╢╢╢╢╢╢╢╣╣▒▒▒▒▒▒▒▒█▄╣▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒╢╣▒▒▒▒╣╢╢╢╢╢╢╢▓╙─────────────═─┌─└─────────────┌    //
//        ▓▓▓▓▓▓▓░└┌┐╔╖╓┌┌─╙▓▓▓╖────┌▀▄┌└╕─╙╢╢╢╢╢▒▒▒▒▒▒▒▒▒▒▐███╜║▒▒▒▒▒░▒▒▒▒▒▒▒╜▒▄▓▓▒▒▒▒▒▒▒╢╢╢╢╢▓─╒─┌┌────┌┌─┌┌┌┌─────═─═───║╜─────    //
//        ▀▀▓▓╣└─░───────────┘╙▀▓▓╦┌───▀╗─╘┌╟╢╣▒▒▒▒▒▒▒▒▒▒▒▒██████▒╜╨╨╨▒▒▒▒╜▒▄▄█▓█▀▒▒▒▒▒▒▒▒▒▒▒╫▒╔╢┌───┌──────═──┌──┌┌┌─┌┌┌────╜╙╙└╙    //
//        ░╥▓▓▓▓▓▓▓═──└└────╒╓╖─┌▓▓──────╓▓▒▒▒╜▒▒▒▒▒▒▒▒░░▄█████████▀▓▓▓▓▓▓▓███▓█░░░░▒▒▒▒▒▒▒▒▐▓╝╢▒▒╖──┌─┌────┌╖╓┌┌─────────────────    //
//        ▓░╙╙▒▓▓▄▄▄╦═─╖║╙╚╜╙▀▀╙▌└═──└╙─▄▓╝└░╚╣╢║▒▒▒░░▄███████▀▀▀▀▀▀▀▀▀▀▀██████▌╙░░░░░░░▒▒▒▒▒▒▓▄╖╢╬▓─────────────└└─┘└└┐─╓═──────╙    //
//        ║▓░▒▓▓▓▓▓▓╙────┌┌╓║▀┘╧─╚─┌░╒┌▓▓▓████████▓█████▀▀─────────────────╙▀██▀█▄╙░░░░░░░▒▒▒▒▒▒▀▓▓▒▓░────────▄▄▄▄▄╓┌──┌──────────    //
//        ─└╫╗──╓▓▓▓▓▓▓▓▓╢╢▓▀╨▄╙╦┌─└┴─▓▓▓╢▒▒▀████████▀───────┌┌╓┌──╓▄▓▓╥╓─────▀███▓▓▄▄▄▄▄▄▄╬╣║▒▒▒▒▀█╣▓└┌───────└▀▀▀▀╣▒┐───────────    //
//        ╦╦▄▓▓▓▒╜└─░└└═╖▄▒▓╧─▌─▄─░▒╓▓╢╣▒▒▒▒▒░████▀──────┌▄▓▓▓▓▓▓██▓▓▓▓▓▓▓▓╗───▐██████▀▀▀░░░░▒▒▒▒▒▒▒█▒╫─┌─────┌┌──└─┌─────╓▄█▀▀╩═▓    //
//        ▌└─░▀▓▀▓▓╦┐┌──░▒╢╢╖─┐───╙╖▓▒▒▒▒▒▒▒▒▄███▀─────╓███▓▓▓▓▓▓▀▀███▓▓▓▓▓▓▓▓┌███▓▀─────└░░░░▒▒▒▒▒▒▓▓█▒─────────────┌╒═╙────┌───└    //
//        ╙╖┘┌──╛─╛╙╙╨▓▄╖▒╢▓▓▓└╙┘─═▄▓╣╢▒▒▒▒▄█████─────▄█████▓█▓▓░░░─▀████▓▓▓▓▓▓▓██▀────────░░░░▒▒▒▒▒▒▓▓▒────┌└─└┌═┘▀╜╕──╓─────────    //
//        ╓═░──┌╜└─┌┌▐─▒║▒╢║╜╣╜┌┌──▓▒▒▄▄█████████▄┌──▐███████▓░░░░░░┌┌┌┌▓████▓╢▓▓▓┌────────└░░░░▒▒▒▒▓░▒▒┌──┌──────┌┌──└─┌───┌───═╓    //
//        ────└┌─┌─────└└▀▀▒▓▀═┘─└┌▐▓▒▒▒▒▀▀▀▀▀▀█████▄███████▀░░░░░▒▒▒▓▀▒╢╢╣▀█▓█▓╫▓██▄───────░░░░▒▒▒▒▒▒░──────┌─╓────────┌▐▄───────    //
//        ┌───┌╥░└╙╙═╖┐┌┌▒╫╜▓═┌┌───┌▓▒╢╣▒▒▒░░░░──▀███████████████▓▓▓░░╟▓▓█▀╣█████╢▓▀▀▀──────┌░░░▒▒▒▒▒▒╜───┌──────╓┌──────┌─▀▄▄───┌    //
//        ─┌─╙╦┌└─────┌▐┌╢╫╬╦╦────┌──▓▒▒▒▒▒░░░░──▄███████████▓███▓▌╙╙╖╙╩▓▓╝░╙╙█▓█╬▓─────────┌░░░░▒░▒▒╨└──═╓──────═─└────────┐▀██╖─    //
//        ░─┤╓╣└─╥┌─────┌▒╢╗╫╕┌╓╤─┌──│▓▓▒╣▒▒░░░┌██▀▀▀██████▓██▓▓╢▓▓──╙░░▒░░░──█▓█╣▓─────────┌░░▒░░▒▒╜─────╔▓╦──└─────┌┌──└─────└▀█    //
//        ░╒└─╓▄└─┌─└╙══╖╓╫▓╙╙▒╫▀┌─░───▐▓▒▓▓▓░░░─────█████▌▓▓▄╫▓▓█▓▓▓▄╥▒▒▒▒───█▓█╣▓────────┌░░▐╓░▒▓╝┐───┌┌──└╗╓───└────┌──┌▀█▄───═    //
//        ─┌╕╜▓▓▓╖─╓─┌┌─└╙╨╣▒╟▒▓░╓╗▒╥╖▒░▀█▓▓███▄▄────▐█████▌▓▓▓▓█████▓▓▄▄▓▒░─┌█▓█╢▓────────╨╜╙▒╫╢╜─┌┌└──┌╙▄┌────────────┌─┌─┐╙▀▌▄─    //
//        ╣░░┌┘─▒▒╙───────┌░╢▓▒▒▒▒▒▒▒▒░╢▒▓▓██▓▓▓▓██▄▄┌██████╣▓▓▓█████▓▓▒▒─▓▄▓▓▓▓▓╫▓▌─┌┌┌┌┌─╓╦╬▓▀┌─────────└───────────────═────┌▀█    //
//        └┌└─╓╟▓╬╖░┌┐╙░┬╖▒╣╢╣╢╢╢▒▒▒╢╫▒╢▓▓▓▓▓██▓█▓████████████████▓▓▀▀░░─▐██▓▓▓▓▓╫▓▓▓▒╣▒▒╢╢╢▓▀──────┌───└──╙─╥╗─└▓▒──┌──────└╕───═    //
//        ─┌╓╜╙┌──╠▓╖░▒▒░░░░░▒▓▒▒╢▒╢╫╢╫▀╫╢▓▓▓▓█████████████████████▓▓▓▓▓▓▓▓▓████▓▓▓▓╢▓▓▓▓▄▓▀╙╕───────└▄╤──╓─┌▓▒─╦▒▒╒░░────┌───└═▄─    //
//        ▒░╘──▌╓╜╜╢▄░░░░▒▒▒▒▒▒╣╫╣╣╢╢▒╣╣╫▓╣╢▓▓▓▓█▓█████████████████████████▓▓███▓▌█▓▓▓██▌▀┌───┌─┌─┐────┐─▐▒╓█▓▓▓▓▓▒░▒──┐╒──└─────└    //
//        ────┬└─╖╜╜╙╨▒░▓▒╣▒▒▒▒▒▒▓▒▒▒╣╢╢▓▓▓▓▓▓▓▓▓███████████████████████▓▓╢╣▒█████▐▓▓▓█▀┌└═───┐────╙▓╥──▄▓▓██▓▓▓╣▒▒▓▐╦┌──╒┌───────    //
//        ─┌╧░┌╔║░░╖▄▓▓█╣▒▒▒▒╣▒╢╢╢╢╣╣╣╣▒╣╢╢▓▓▓▓▓▓▓▓▓▓█████████████████▓▒╢╢╣▒▒████▓▌█▓▓──────═┌┌┘╗▄┌└╓╗▄█████╢▓█▒▓▀──┌▀▀█▄─────┐───    //
//        └┌╖▒╜░░▄▓▓▓▓▒▒▒▒▒▒▒▒▒▓╣▓▓▒▒▒▒▒╫╣╣▒╣▓╢╫▓▓▓▓▓███████████████▓▓▒▒╢╢▒▒░▐█████╢▓┐┌┌──▄───└└─╟╓▓▓▓████████▓╜──┌────┌╙▀█▄▄────┐    //
//        ╜░░░▄▓▓╢▒╢▒▒╢▒▓▒▒▒▒▒▒▒▒▒▒▒▒▒╢╣╣╢▓╩╙╙╜▒▒╢▓▓▓████▓███████▓▓▓╢╣╢╢╢▒░░░╙█████▓▓░──────────┌▓█▓████████▀──╓─└──└═┌──┌─╙▀██▄┌─    //
//        ╖╔▓╣╢╣▒▒▒▒▒▒▓▒╣▒▒▒▒╢╣╢▒▓╣▒▓▓▓▓╜└└└░░▒╢╢╢╢╢▓▓█████▓█▓▓▓▓▒▒▒▒╣╢▒▒▒░░┌┌░▀████▓▌╖╖╖╖╖╖╓╓╓┌┌▓▓███████▄╦╦└──└┌──└──╘╜─┌───╙▀██    //
//        ▓▒▒▒▒╢▒▓╣▒▒▒▒▒▒▒▓▒╢╢▓╣▒▓╢╢▒╣╣░┌░░░░─└║▒▒▒▒▓▓██▓██▓▓▓╢╣▒▒▒▒╢╢╢╣▒░░▒▒▒▒▒╨████▓░░░░░░░░░░╟▓██▓▌──────└└┐────┌─┌──┘──└▀▄▄┌─╙    //
//        ▒▒▒▒▀▀░░▒▒▒▒▒▒▒▀╣╫▓▓╫▓╣▓╣▓▓╣▒░░░░▒░░──▒▒▒▒▒▓█▓▓█▀█░░░▒▒╢▒▒▒▒▒▒▒▒▒▒░░────▐███▌──└└░░░░╔▓██▓╣─┌─────┌┌──╕──└┐─────┌───▀███    //
//        ▓▒▒░▒▒▒▒░▒▒▒▒▓▒╣▒▓▒█▓╣▒╣╫▒╣▓╣▒░░░▒▒▒░░║▒▒░░▓█▓▓▓▒░▀░░░░░▒▒╢╢╣▒▒▒░░░░░░░░▒▀█▌──┌─┌░└░╓▓██▓▓▒───└▀╙└──└─▌──┌─└┐╒────────└▀    //
//        ░░░▒▓▀░▒▒▒▒▓▒╢▒▓▒▒▒▒╣▒▓▓▒╣▒╫▓▒▒▒▒╣╜╜└──╣▒▒░▓▀░░▒▒░░░░░░▒░░▒╢▒▒░░░░░░░░░░─┌┌┌┌┌┌▒░┌┌╓▓▓█▓▓╣░─────└┐────┐──└┐──└───┐──────    //
//        ░▒╜░▒▒▒▒▒▒▒▒╢╫▒▒▒▒▒╣╣╢▒▒╣╣╫╣▓╜╙░░└─┌┌───╚▒▒▒▒░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░▓╣▒▒╫▓▓█▓▓▓▒──┌┌┌┌──└────└┐───┌───────┐───    //
//        ░▒░▄░░▒▒▒▒▒▒▒▒▒▒▒╣╢╢▒▒╣▒▒╢▓╢░┌┌┌┌┌░┌─────╢╢╣▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒╢╣╢▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▓▓╣╫▓▓▓▓▓▓╣▒─▄──└─┌────└────────┐──────╙█▄    //
//        ██▀░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒╢╣▒▓╣╢░┌░░░░░░░───╒▓▓▓╣╣╣▒▒▒▒▒▒▒▒▒▒▒╢╫▓╣╣╢╣▒▒▒▒╢╢╢╢╣╣╣▓█▓▓▓▓▓▓▓▓▓╣╣▒─└█──└─┌╓──└┬═└──────▀▄───┌──▀    //
//        ▀░░▒▒▒▒╫▓▒▒▒▒▒▒▒▒▒▒╣╢╢╢▒▓▒▓▒░╫╣╬╝▒▒▒▒░─┌███▓▓▓╣╣╣▒▒▒▒▒▒╢╣╢╢▓▓▓▀░╓╖╓─╗╠▓▓▓▓▓▓████▓▓██▓▓▓▓╣▒───█▄──┐─╓─╓───╜───┌──└██┐└─┌─    //
//        ░║░▀▒╢╣▒▒▒▓▒▒▒▒▒▓╣▓▓╣╢▓▒▓▓╢╣╥╥▒▒▒▒▒▒▒▒▒╖╖╖╖╖╓╓┌┌┌░╙╙╙╙╙╙╙╙╙╙░░▒▒▒▒▒╢╢╬▓▓▓▓▓█████▓█████▓▓╣▒──┌╓█▓▄─┌──└▓┐────└▄╓───▀██▄▄─    //
//        ▒▄█▓█▓▒▒▒▒▄█▒╢▓▒▓▓▓╢╫▓╣▓█▓▓▓╣╣▒▒▒╣╢╢╢╢╣▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒╢╢╢╣▓▓▓█████████████▓▓▒─┐─┌┐█▓█╗──┌▐██▄───└█▌▄─┌└████    //
//        █████▒▒▄███╢▓▒▓█▓▓▓▓▓▓█▓▓╫██▓▓▓▓╢╢╣▓▓▓▓▓▓▓▓╣╢╢╢╢╢▓▓▓▓▓▓▓▓▓███▄▒▒▒▒╢╢╢╣╢╢▓╫████████████▓▓▓▒╓─┌──▐█▓▓▄┌┐░██▓▒─┌└▐███▄▄─███    //
//                                                                                                                                    //
//                                                                                                                                    //
//                                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract DANK is ERC721Creator {
    constructor() ERC721Creator("Dankus", "DANK") {}
}
