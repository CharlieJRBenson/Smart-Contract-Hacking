This contract transfers the current prize (and Kingship) to the new highest bidder for Kingship. I created a malicious contract that cannot receive this prize.

```KingHack{}``` has function ```becomeKing(address _to)``` to trigger the ```King{}``` contract's ```recieve()``` fallback function.

```KingHack{}``` has no ```recieve()``` fallback function. So the ```king.transfer(msg.value)``` line, will fail. 

Kingship will still be transferred to our malicious contract and the attempt to regain Kingship will fail due to the ```contract.prize()``` inaccuracy.


### Steps

Find out the value of current prize.
```await contract.prize()```

Using Remix, on malicious contract, Call ```becomeKing()``` with the instance address, and ```msg.value``` of ```1000000000000000 Wei``` (= contract.prize).

Check Prize and check King is changed to malicious contract address.
```await contract.prize()```
```await contract._king()```

Upon Submitting the reclaim of Kingship will now fail.
