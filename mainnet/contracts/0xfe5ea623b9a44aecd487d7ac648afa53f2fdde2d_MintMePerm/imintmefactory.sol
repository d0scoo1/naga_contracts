/*
This file is part of the MintMe project.

The MintMe Contract is free software: you can redistribute it and/or
modify it under the terms of the GNU lesser General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

The MintMe Contract is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU lesser General Public License for more details.

You should have received a copy of the GNU lesser General Public License
along with the MintMe Contract. If not, see <http://www.gnu.org/licenses/>.

@author Ilya Svirin <is.svirin@gmail.com>
*/
// SPDX-License-Identifier: GNU lesser General Public License

pragma solidity ^0.8.0;


interface IMintMeFactory
{
    function feeWei() view external returns(uint256);
    function fundsReceiver() view external returns(address payable);
    function baseURI() view external returns(string memory);
    function onTransfer(address sender, address receiver, uint256 tokenId) external;
    function onCollectionUpdated(string memory contentCID) external;
    function onCollectionTransfer(address newOwner) external;
    function onTokenUpdated(uint256 tokenId, string memory contentCID) external;
}
