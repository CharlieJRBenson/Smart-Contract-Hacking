### Task 

>Claim ownership of the contract below to complete this level.

### Observations

This contract allows transfer of ownership when ```tx.origin != msg.sender```.

Therefore I create a malicious contract simply to call the ```changeOwner``` function, as the ```tx.origin``` can only be a wallet address, not a contract address.

Therefore calling this function through a proxy contract will trigger the ```changeOwner()``` condition.