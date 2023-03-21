### Task
>This elevator won't let you reach the top of your building. Right?

### Observations 

This contract expects the sender to be a Building class Contract. 
```Building building = Building(msg.sender);```

And through it's use of a Building interface it will call the ```Building{}``` function ```isLastFloor(uint)```.

If I make a malicious Building contract, I have full control of what this function can do and return.



### Steps 
