### Task

>This gatekeeper introduces a few new challenges. Register as an entrant to pass this level.

### Level Help

- Remember what you've learned from getting past the first gatekeeper - the first gate is the same.
- The assembly keyword in the second gate allows a contract to access functionality that is not native to vanilla Solidity. [See here](https://docs.soliditylang.org/en/v0.4.23/assembly.html) for more information. The extcodesize call in this gate will get the size of a contract's code at a given address - you can learn more about how and when this is set in section 7 of the [yellow paper](https://ethereum.github.io/yellowpaper/paper.pdf).
- The ^ character in the third gate is a bitwise operation (XOR), and is used here to apply another common bitwise operation [see here](https://docs.soliditylang.org/en/v0.4.23/miscellaneous.html#cheatsheet). The Coin Flip level is also a good place to start when approaching this challenge.

### Observations 

- `gateOne` can be passed when the tx caller is a smart contract. Since `msg.sender != tx.origin`.

- `gateTwo` can be passed when the tx caller smart contract has a `extcodesize` of 0. This is achievable when the malicious caller contract makes it's calls from the constructor.

- `gateThree` can be passed when the... uint64 type casted, bytes8 of the hash of the encoded msg.sender address.... XOR 's with a gatekey to = all 1's in uint64.

This is a reverse engineerable operations. Because A XOR B = C and A XOR C = B.

### Steps

- `gateOne` passed when we call contract through our own contract.

- `gateThree` passed when 

`uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max`

Because of A xor B = C and A xor C = B. We do:

`bytes8 _gateKey = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max)`

- `gateTwo` we do all this in the constructor of our contract so it runs once on deploy.


