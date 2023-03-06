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
- The `return(p,s)` takes variables `p` and `s`.
- - `p` is the position in memory where the returnable value is stored.
- - `s` is the size of the data to return (in hex). `0x42` is 32 bytes so `s = 0x20`.

- Opcodes are written similar to Reverse Polish Notation
- - Example RPN: `4 * 3 + 2` would be `4 3 * 2 +`
- - Example Opcode order: `return(p,s)` would be `p s return`.

### Steps

#### Runtime Bytecode

- Store using `mstore(p,v)`, a value(`v = 0x42`) in an arbitrary memory position (`p = 0x10`):

```
v: push1 0x42 // in hex -> 6042
p: push1 0x10 // in hex -> 6010
mstore        // in hex -> 52
```

- Return the value stored at `0x10`, specifying the size `0x20`:

```
s: push1 0x20 // in hex -> 6020
p: push1 0x10 // in hex -> 6010
return        // in hex -> F3
```

- The bytecode sequence should therefore be (which has a runtime opcode of 10 bytes).
```
604260105260206010F3
```

#### Initialisation Bytecode

