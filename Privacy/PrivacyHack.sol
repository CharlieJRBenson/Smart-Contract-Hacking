//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.4;

contract PrivacyHack{
    //this contracts sole purpose is to type cast a HEX value
    //bytes32 to bytes16
    function cast(bytes32 input) public pure returns(bytes16) {
        return bytes16(input);
    }
}