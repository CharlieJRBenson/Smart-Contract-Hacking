### [Contracts](https://github.com/tinchoabbate/damn-vulnerable-defi/tree/v3.0.0/contracts/selfie)
### Task

>A new cool lending pool has launched! It’s now offering flash loans of DVT tokens. It even includes a fancy governance mechanism to control it.

>What could go wrong, right ?

>You start with no DVT tokens in balance, and the pool has 1.5 million. Your goal is to take them all.

### Observations

- Looks like a solid flashloan pool at the moment, but it inherits and utilises a fancy governance mechanism to execute transactions and function calls.

- There is a strange function `emergencyExit(address)` which sends the pools total funds to the address, as long as the cool came from the governance contract.

- That seems like the focus immediately - Find a way to break the governance to call this function with my address.

- To queue an action in the gov contract I need more than 50% of the token total supply.

- Fortunately the flashloan pool holds the same token as used for governance, and the pool holds >50% of the total supply. (1,500,000 / 2,000,000).

- So we should just be able to create a contract to flashloan the maximum, queue a governance action, then repay the flashloan.

### Steps 