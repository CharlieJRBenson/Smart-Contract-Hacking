### Task

>This contract utilizes a library to store two different times for two different timezones. The constructor creates two instances of the library for each time to be stored.

>The goal of this level is for you to claim ownership of the instance you are given.

### Level Help

- Look into Solidity's documentation on the `delegatecall` low level function, how it works, how it can be used to delegate operations to on-chain. libraries, and what implications it has on execution scope.
- Understanding what it means for `delegatecall` to be context-preserving.
- Understanding how storage variables are stored and accessed.
- Understanding how casting works between different data types.

### Observations 

- `delegatecall` gives the delegate contract access to the respective storage slot being altered of the calling contract. For example, in this contract calling `setTime()` changes slot 0 in the `LibraryContract`, `storedTime`, therefore slot 0 in the `Preservation` contract will be altered. In this case, `timeZone1Library`.
- We can call the function `setFirstTime(uint _timeStamp)` passing any address and it will alter the `timeZone1Library` to be this address.
- Now all we need is a malicious contract that alters the other slots/variables, such as `owner`.
- The contract would need all the same variables in the same order as the `Preservation` contract.
- The contract will need a function with the same signature `setTime(uint _time)`, and the content of the function can alter the owner slot.

### Steps
- Create malicious contract with storage slots:
```
address public timeZone1Library;
address public timeZone2Library;
address public owner; 
uint storedTime;
```
- Create function with identicle signature, and make it alter the owner:

```
function setTime(uint _time) public {
    owner = msg.sender;
}
```

- Deploy malicious contract, and note the address after a cast `uint(address)`.
- Access a `Preservation` instance, preferably on remix.
- Call `Preservation`'s `setFirstTime(uint MALICIOUSADDRESS)`.
- Now check `timeZone1Library` == MALICIOUSADDRESS.
- Call `Preservation`'s `setFirstTime(ANYINTEGER)`.
- Now check owner has changed to `msg.sender` which is my EOA address.