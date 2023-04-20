### [Contracts](https://github.com/tinchoabbate/damn-vulnerable-defi/tree/v3.0.0/contracts/backdoor)

### Task
> To incentivize the creation of more secure wallets in their team, someone has deployed a registry of [Gnosis Safe wallets](https://github.com/gnosis/safe-contracts/blob/v1.3.0/contracts/GnosisSafe.sol). When someone in the team deploys and registers a wallet, they will earn 10 DVT tokens.

>To make sure everything is safe and sound, the registry tightly integrates with the legitimate [Gnosis Safe Proxy Factory](https://github.com/gnosis/safe-contracts/blob/v1.3.0/contracts/proxies/GnosisSafeProxyFactory.sol), and has some additional safety checks.

>Currently there are four people registered as beneficiaries: Alice, Bob, Charlie and David. The registry has 40 DVT tokens in balance to be distributed among them.

>Your goal is to take all funds from the registry. >In a single transaction.

### Observations

- We can exploit a vulnerability in the _getFallbackManager function. This function retrieves the fallback manager address from the wallet's storage. 
- However, the storage slot calculation is incorrect. It uses the keccak256 hash of the string "fallback_manager.handler.address", but it should use a proper storage slot calculation for Gnosis Safe.

### Steps

- Deploy a malicious Gnosis Safe wallet with a carefully chosen storage slot value that collides with the incorrect calculation of the fallback manager address in the _getFallbackManager function. Set the fallback manager address to a non-zero value, so the InvalidFallbackManager check is bypassed.

- Register as a beneficiary in the WalletRegistry contract. You may need to become the contract owner or persuade the owner to add you as a beneficiary.

- Call the GnosisSafeProxyFactory::createProxyWithCallback function with the malicious wallet's master copy, and set the registry's address as the callback. The proxyCreated function will be executed.

- Since the InvalidFallbackManager check is bypassed, the contract proceeds to register the malicious wallet and transfers the 10 DVT tokens as a reward.

- Implement a fallback function in the malicious fallback manager that calls the WalletRegistry::addBeneficiary function to re-add your address as a beneficiary. This way, you can repeatedly create wallets and collect rewards.

- Repeat steps 3-5 until the balance of the WalletRegistry contract is depleted. You will collect all the DVT tokens in the process.