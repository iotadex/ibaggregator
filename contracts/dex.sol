// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

contract DexManagae {
    // dex id => the address of SwapRouter
    mapping(uint8 => address) public swapRouters;
}
