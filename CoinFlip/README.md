The random generation isnt truly random as it is onchain and decided by a factor and the blockValue.

The blockValue is determined using the blockhash of the previous block.
```blockhash``` and ```block.number``` are known and accessible to everyone on the network. 

Therefore I create a malicious bespoke contract that calculates the 'random outcome' using the same method. Then call the original contract with the correct guess.


