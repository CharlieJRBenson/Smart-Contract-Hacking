### Task
>To solve this level, you only need to provide the Ethernaut with a Solver, a contract that responds to whatIsTheMeaningOfLife() with the right number.

>Easy right? Well... there's a catch.

>The solver's code needs to be really tiny. Really reaaaaaallly tiny. Like freakin' really really itty-bitty tiny: 10 opcodes at most.

### Level Help
>Hint: Perhaps its time to leave the comfort of the Solidity compiler momentarily, and build this one by hand O_o. That's right: Raw EVM bytecode.
Good luck!


### Observations 

- We'll need to write a contract that returns the number `0x42`
- We'll need to write this contract through the EVM assembly opcodes, translate that to hex data (bytecode) and deploy it through an EVM data transaction.
- The data sent will include the Initialisation opcodes and the Runtime codes. The Init opcodes will run first (the constructor for example), the Runtime is the logic that will return `0x42` in under 10 opcodes. 
#### Runtime logic
- The `return(p,s)` takes variables `p` and `s`.
- - `p` is the position in memory where the returnable value is stored.
- - `s` is the size of the data to return (in hex). `0x42` is 32 bytes so `s = 0x20`.

#### Initialisation Logic
- Runs first and sets the runtime codes to the right place in memory.
- The `codecopy(t,f,s)` does this by taking variables `t`, `f` and `s`.
- - `t` is the memory position of the code. `0x00` is a good default position.
- - `f` is the position of the runtime opcodes within the the bytecode.
- - `s` is the size of the bytecode. `0x0a` is 10, because our runtime bytecode is 10bytes.


Opcodes are written similar to Reverse Polish Notation:
- Example RPN: `4 * 3 + 2` would be `4 3 * 2 +`
- Example Opcode order: `return(p,s)` would be `p s return`.

### Steps

#### Runtime Bytecode

- Store using `mstore(p,v)`, a value(`v = 0x42`) in an arbitrary memory position (`p = 0x50`):

```
v: push1 0x42 // in hex -> 6042
p: push1 0x10 // in hex -> 6050
mstore        // in hex -> 52
```

- Return the value stored at `0x50`, specifying the size `0x20`:

```
s: push1 0x20 // in hex -> 6020
p: push1 0x10 // in hex -> 6050
return        // in hex -> F3
```

- The runtime bytecode sequence should therefore be (which has a runtime opcode of 10 bytes).
```
604260505260206050F3
```

#### Initialisation Bytecode

- Init the code using `codecopy(t,f,s)`, where `t = 0x00`, `s = 0x0a` and `f = 0x..` (we can't know f yet):

```
s: push1 0x0a // in hex -> 600a
f: push1 0x.. // in hex -> 60..
t: push1 0x00 // in hex -> 6000
codecopy      // in hex -> 39
```

- Return the value stored at `0x00`, specifying the size `0x0a`:

```
s: push1 0x0a // in hex -> 600a
p: push1 0x00 // in hex -> 6000
return        // in hex -> F3
```

- The init bytecode sequence should therefore be:
```
600a60..600039600a6000F3.
```
- Which has a size of 12 bytes, or `0x0c` therefore the runtime opcodes start at position `0x0c`. Therefore the `..`or`f` value is `0c`. 
- The final total bytecode therefore looks like this (first 12bytes = init, last 10bytes = runtime):
```
600a600c600039600a6000F3604260505260206050F3
```

In console:

```
web3.eth.sendTransaction({from: "*MyAddress*", data: "600a600c600039600a6000F3604260505260206050F3"}, function(err,result){console.log(result)});
```

- Then get the newly deployed contract address from etherscan.
- Then in console:
`await contract.setSolver("*Address*")`
 