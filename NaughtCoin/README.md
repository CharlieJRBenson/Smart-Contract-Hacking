### Task

>NaughtCoin is an ERC20 token and you're already holding all of them. The catch is that you'll only be able to transfer them after a 10 year lockout period. Can you figure out how to get them out to another address so that you can transfer them freely? Complete this level by getting your token balance to 0.

### Level Help

- The [ERC20](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md) spec.
- The [OpenZeppelin](https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts) codebase.

### Observations 

- Initially this looks like a poorly implemented ERC20 token, not following the EIP-20 Standards.
- The `lockTokens` modifier applies only under the condition where the `msg.sender` is the `player`. This could be exploited through use of `transferFrom()` using `approve()`, thus avoiding the `transfer()` function.
- Opening an instance of the token contract on Remix, by compiling any ERC20 and then playing with the standard functions.
- As we can see, `transfer()` fails as our tokens are locked.


### Steps
- Copy the `balanceOf()` our address, it's 1000000000000000000000000.
- `approve()` an external address as a spender of all of our tokens.
- Interact with the token contract from the spender address.
- Calling `transferFrom()` with params, from: locked address, amount: 1000000000000000000000000.
- Now check `balanceOf()` original address. The token have been sent, they are free. Hence the Lock has been hacked.


