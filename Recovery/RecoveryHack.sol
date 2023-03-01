// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CalcAddress{
    //assumes nonce == 1 == 0x01
    function calc_address(address _a) public pure returns(address expectedAddress){
        return address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), _a, bytes1(0x01))))));
    }
}