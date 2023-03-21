### Task

>Make it past the gatekeeper and register as an entrant to pass this level.
>
>Things that might help:
>* Remember what you've learned from the Telephone and Token levels.
>* You can learn more about the special function gasleft(), in Solidity's documentation (see here and here).

### Observations

Passing `gateOne()` requires that the call comes from a smart contract address.

Passing `gateTwo()` requires that the remaining gas is an integer multiple of 8191.

Find `instance`'s compiler version and settings on Etherscan.

Passing `gateThree()` requires that the passed key can fulfil various byte conversion properties: 
```
require(uint32(_gateKey) == uint16(_gateKey));
require(uint32(_gateKey) != uint64(_gateKey));
require(uint32(_gateKey) == uint16(tx.origin));
```

`0x11111111 == 0x1111` possible when masked by `0x0000FFFF`.

`0x1111111100001111 != 0x00001111` possible when masked by `0xFFFFFFFF0000FFFF`.

### Steps

