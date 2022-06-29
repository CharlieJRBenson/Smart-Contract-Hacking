### Task

>The contract below represents a very simple game: whoever sends it an amount of ether that is larger than the current prize becomes the new king. On such an event, the overthrown king gets paid the new prize, making a bit of ether in the process! As ponzi as it gets xD
>
>Such a fun game. Your goal is to break it.
>
>When you submit the instance back to the level, the level is going to reclaim kingship. You will beat the level if you can avoid such a self proclamation.

### Observations

This contract transfers the current prize (and Kingship) to the new highest bidder for Kingship. I created a malicious contract that cannot receive this prize.

```KingHack{}``` has function ```becomeKing(address _to)``` to trigger the ```King{}``` contract's ```recieve()``` fallback function.

```KingHack{}``` has no ```recieve()``` fallback function. So the ```king.transfer(msg.value)``` line, will fail. 

Kingship will still be transferred to our malicious contract and the attempt to regain Kingship will fail due to the ```contract.prize()``` inaccuracy.


### Steps

Find out the value of current prize.
```await contract.prize()```

Using Remix on the malicious contract, call ```becomeKing()``` with the instance address, and ```msg.value``` of ```1000000000000000 Wei``` (= contract.prize).

Check Prize and check King is changed to malicious contract address.
```await contract.prize()```
```await contract._king()```

Upon Submitting the reclaim of Kingship will now fail.
