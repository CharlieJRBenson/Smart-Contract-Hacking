Force.sol is an empty contract with no payable fallback function.

However I can still send it ether by self destructing a contract with a balance. 

```selfdestruct``` is a solidity function that destroys ```this``` contract and transfers any of ```this.balance``` to the given address.

The ```ForceHack{}``` contract has a ```selfDest()``` function with the instance of ```Force{}``` address.

### Steps

Transfer Ether to ```collect()``` function.

It will return the contract balance to confirm recieved.

Then call ```selfDest()``` and it will destroy the malicious contract, sending its contents to ```Force{}```.