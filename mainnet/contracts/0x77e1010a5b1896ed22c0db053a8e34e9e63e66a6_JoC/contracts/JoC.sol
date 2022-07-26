
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Journey of Curiosity
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                          //
//                                                                                                                                          //
//                                                                                                                                          //
//                     ___           ___           ___           ___           ___                                ___           ___         //
//        ___         /\  \         /\  \         /\  \         /\  \         /\__\                              /\  \         /\__\        //
//       /\__\       /::\  \        \:\  \       /::\  \        \:\  \       /:/ _/_         ___                /::\  \       /:/ _/_       //
//      /:/__/      /:/\:\  \        \:\  \     /:/\:\__\        \:\  \     /:/ /\__\       /|  |              /:/\:\  \     /:/ /\__\      //
//     /::\  \     /:/  \:\  \   ___  \:\  \   /:/ /:/  /    _____\:\  \   /:/ /:/ _/_     |:|  |             /:/  \:\  \   /:/ /:/  /      //
//     \/\:\  \   /:/__/ \:\__\ /\  \  \:\__\ /:/_/:/__/___ /::::::::\__\ /:/_/:/ /\__\    |:|  |            /:/__/ \:\__\ /:/_/:/  /       //
//      ~~\:\  \  \:\  \ /:/  / \:\  \ /:/  / \:\/:::::/  / \:\~~\~~\/__/ \:\/:/ /:/  /  __|:|__|            \:\  \ /:/  / \:\/:/  /        //
//         \:\__\  \:\  /:/  /   \:\  /:/  /   \::/~~/~~~~   \:\  \        \::/_/:/  /  /::::\  \             \:\  /:/  /   \::/__/         //
//         /:/  /   \:\/:/  /     \:\/:/  /     \:\~~\        \:\  \        \:\/:/  /   ~~~~\:\  \             \:\/:/  /     \:\  \         //
//        /:/  /     \::/  /       \::/  /       \:\__\        \:\__\        \::/  /         \:\__\             \::/  /       \:\__\        //
//        \/__/       \/__/         \/__/         \/__/         \/__/         \/__/           \/__/              \/__/         \/__/        //
//          ___           ___           ___                       ___           ___                                                         //
//         /\__\         /\  \         /\  \                     /\  \         /\__\                                                        //
//        /:/  /         \:\  \       /::\  \       ___         /::\  \       /:/ _/_       ___           ___           ___                 //
//       /:/  /           \:\  \     /:/\:\__\     /\__\       /:/\:\  \     /:/ /\  \     /\__\         /\__\         /|  |                //
//      /:/  /  ___   ___  \:\  \   /:/ /:/  /    /:/__/      /:/  \:\  \   /:/ /::\  \   /:/__/        /:/  /        |:|  |                //
//     /:/__/  /\__\ /\  \  \:\__\ /:/_/:/__/___ /::\  \     /:/__/ \:\__\ /:/_/:/\:\__\ /::\  \       /:/__/         |:|  |                //
//     \:\  \ /:/  / \:\  \ /:/  / \:\/:::::/  / \/\:\  \__  \:\  \ /:/  / \:\/:/ /:/  / \/\:\  \__   /::\  \       __|:|__|                //
//      \:\  /:/  /   \:\  /:/  /   \::/~~/~~~~   ~~\:\/\__\  \:\  /:/  /   \::/ /:/  /   ~~\:\/\__\ /:/\:\  \     /::::\  \                //
//       \:\/:/  /     \:\/:/  /     \:\~~\          \::/  /   \:\/:/  /     \/_/:/  /       \::/  / \/__\:\  \    ~~~~\:\  \               //
//        \::/  /       \::/  /       \:\__\         /:/  /     \::/  /        /:/  /        /:/  /       \:\__\        \:\__\              //
//         \/__/         \/__/         \/__/         \/__/       \/__/         \/__/         \/__/         \/__/         \/__/              //
//                                                                                                                                          //
//                                                                                                                                          //
//                                                                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract JoC is ERC721Creator {
    constructor() ERC721Creator("Journey of Curiosity", "JoC") {}
}
