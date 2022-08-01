### Task

>The creator of this contract was careful enough to protect the sensitive areas of its storage.

>Unlock this contract to beat the level.

>Things that might help:
>* Understanding how storage works
>* Understanding how parameter parsing works
>* Understanding how casting works

>Tips:
>* Remember that metamask is just a commodity. Use another tool if it is presenting problems. Advanced gameplay could involve using remix, or your own web3 provider.

### Observations

This contract stored the `unlock()` function key in index=2 of the `bytes32[3] private data;` array. We can access this through the web3js method `getStorageAt()`even when it's a private variable.

Solidity storage slots are of 32bytes capacity. Discover which index storage slot data[2] is stored, and we have the key.

### Technical Observations

`bool locked` = 1 byte; `constant ID` = 0 (not stored in storage); 
`uint8 flattening` = 1 byte; `uint8 denomination` = 1 byte; 
`uint16 awkwardness` = 2bytes; `bytes32[3] data` = 3 * 32 bytes;

Therefore `locked` + `flattening` + `denomination` + `awkwardness` are in Slot index 0.

`data[0]` in Slot index 1. `data[1]` in Slot index 2. `data[2]` in Slot index 3.


### Steps

`contract.locked` returns true.

`instance` returns the contract address.

`web3.eth.getStorageAt(instance, 3)` calls for the data stored in Slot index 3.

Copy the returned a bytes32 string.

Using the Casting contract I wrote `PrivacyHack.sol` deployed in remix.
Call `cast(bytes32)` with the copied string. 

Copy the returned bytes16 string.

`contract.unlock("")` with copied string will unlock the contract.

`contract.locked()` now returns false.

