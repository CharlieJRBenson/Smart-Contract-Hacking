### Task

>A contract creator has built a very simple token factory contract. Anyone can create new tokens with ease. After deploying the first token contract, the creator sent `0.001 ether` to obtain more tokens. They have since lost the contract address.

>This level will be completed if you can recover (or remove) the `0.001 ether` from the lost contract address.

### Observations 

- `destroy(_to)` function is public and will withdraw all `ether` held in contract to the `_to` address, because of the `selfdestruct()` fuction.
- if we find the contract address that will give us the funds.
- The fastest solution is to find the address on etherscan, under the level address's internal txs. However for the sake of research we will skip etherscan.
- Contract addresses are deterministic. We can calculate the missing address.
- The definition in the ethereum yellow paper is:
>The address of the new account is defined as being the rightmost 160 bits of the Keccak hash of the RLP encoding of the structure containing only the sender and the account nonce. Thus we define the resultant address for the new account `a ≡ B96..255 KEC RLP (s, σ[s]n − 1)`
- To simplify:
`adress ≡ first160bits of keccak(RLP(creator_address, nonce)`
- - The creator_address is the factory contract address.
- - The nonce is the number of contracts made by this factory already.
- - keccak is a built in hashing function on the EVM.
- - RLP is a serialisation encoder.

### Steps
- write a contract that calculates this value based on an inputted adddress.

```
function calc_address(address _a) public pure returns(address expectedAddress){}
```
- encoding a 160bit address is `0xd6, 0x94` according to docs. And all integers less than `0x7f` is itself. 
- fill the function with (assuming nonce == 1 == `0x01`):
```
return address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), _a, bytes1(0x01))))));
```
- On Remix, deploy this and call `calc_address()` with the level instance address as parameter.
- Open instance of returned address on remix.
- Check balance and `name` == InitialToken, to assure this is correct.
- Call `destroy(_to)` with `_to` == wallet address.
