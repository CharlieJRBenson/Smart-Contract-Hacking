### [Contracts](https://github.com/tinchoabbate/damn-vulnerable-defi/tree/v3.0.0/contracts/puppet)

### Task

>There’s a lending pool where users can borrow Damn Valuable Tokens (DVTs). To do so, they first need to deposit twice the borrow amount in ETH as collateral. The pool currently has 100000 DVTs in liquidity.

>There’s a DVT market opened in an old [Uniswap v1 exchange](https://docs.uniswap.org/contracts/v1/overview), currently with 10 ETH and 10 DVT in liquidity.

>Pass the challenge by taking all tokens from the lending pool. You start with 25 ETH and 1000 DVTs in balance.

### Observations

- `calculateDepositRequired()` will tell us how much DVT we can borrow with out 25Eth budget.
- Uniswap has a 1-to-1 ratio DVT-to-Eth, and a `DEPOSIT_FACTOR` of 2. "Borrow 1 Deposit 2". 25 Eth gets 12.5 DVT.
- Required deposit is calculated based on the ratio of the Uniswap Market. I have enough Eth to manipulate the price.

- 
### Steps