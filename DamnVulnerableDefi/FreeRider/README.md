### [Contracts](https://github.com/tinchoabbate/damn-vulnerable-defi/tree/v3.0.0/contracts/free-rider)

### Task

>A new marketplace of Damn Valuable NFTs has been released! There’s been an initial mint of 6 NFTs, which are available for sale in the marketplace. Each one at 15 ETH.

>The developers behind it have been notified the marketplace is vulnerable. All tokens can be taken. Yet they have absolutely no idea how to do it. So they’re offering a bounty of 45 ETH for whoever is willing to take the NFTs out and send them their way.

>You’ve agreed to help. Although, you only have 0.1 ETH in balance. The devs just won’t reply to your messages asking for more.

>If only you could get free ETH, at least for an instant.

### Observations

- The NFT marketplace contract has two buy functions, 1 private: `_buyOne()` and 1 external: `buyMany()`.
- The `buyMany()` function takes an array input of the token Id's to purchase and individually calls `_buyOne()` for each.
- The `buyOne()` function checks the `msg.value` is > the token `priceToPay`. However it checks the same `msg.value` for each token, not the combined cost for all tokens.
- In theory we can send the value of 1 NFT and purchase all NFT's because of this bug.
- Then send it to the `FreeRiderRecovery` contract to receive the reward payout.
- Only one problem, we dont have the ETH to pay the price of 1 NFT.
- So we can do all of this in one transaction using a UniswapV2 flash swap.
- Borrow 15WETH (which we dont yet have), unwrap it, purchase ALL nfts, send them to reward contract, swap wrap rewarded eth, repay weth loan. 
- Profit about 30ETH

### Steps

