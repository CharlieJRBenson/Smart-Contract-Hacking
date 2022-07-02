### TASK
The goal of this level is for you to steal all the funds from the contract.

### Observations
This contract makes the critical error of transfering funds to a user before altering the users balance.

As solidity runs in a single threaded procedural process, this can be exploited through a malicious "Re-entrancy" contract.

To allow my withdraw request to pass the condition, I must hold a balance on the ```Reentrance{}``` contract.

Upon recieving any funds without any call data, our malicious contract's fallback function with be triggered.

Recursively calling ```withdraw()``` on the ```Reentrance{}``` contract, all before our balance can ever be updated.

This recursive loop will continue until all of the contract's funds are drained.

### Steps

Check contract's balance.
```getBalance(instance)```

Deploy ```ReenterHack{}``` on Remix IDE with a seed value of 1 finney and with correct external contract instance address ```ogContract```. 

Call function ```donateToOg()```, which donates 1 finney and adds this contract address to the list of ```balances```.

Now just trigger the fallback by sending Ether without calldata, through a low level interaction on Remix.

Check updated balance after funds have been drained.
```getBalance(instance)```