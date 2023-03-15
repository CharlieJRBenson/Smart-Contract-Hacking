### Task
>There’s a tokenized vault with a million DVT tokens deposited.It’s offering flash loans for free, until the grace period ends.
To pass the challenge, make the vault stop offering flash loans.

>You start with 10 DVT tokens in balance.

### Observations
- Receiver Contract proves the ability and process to take a flash loan. 
- Vault Contract's `flashLoan()` will not provide flash loans if `totalSupply` and `balanceBefore` are not equal. This can be made true by sending the contract tokens instead of depositting.

### 
- Adding this to the hardhat file. To send the address 1 DVT from the player address:
```
await token.connect(player).transfer(vault.address, 1);
```