Force.sol is an empty contract with no payable fallback function.

However I can still send it ether by self destructing a contract with a balance. 

```selfdestruct``` is a solidity function that destroys ```this``` contract and transfers any of ```this.balance``` to the given address.

The ```ForceHack{}``` contract has a ```selfDest()``` function with the instance of ```Force{}``` address.

### Steps

Transfer Ether to ```collect()``` function.

It will return the contract balance to confirm recieved.

Then call ```selfDest()``` and it will destroy the malicious contract, sending its contents to ```Force{}```.

Now check balance of ```Force``` Contract using it's address.

```getBalance("0x72066485510a2C57880802CB10134153886fE88c")```