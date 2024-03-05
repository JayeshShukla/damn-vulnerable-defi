// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "solady/src/utils/SafeTransferLib.sol";
import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";
import "./NaiveReceiverLenderPool.sol";

/**
 * @title FlashLoanReceiver
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
contract FlashLoanReceiver is IERC3156FlashBorrower {

    address private pool;
    address private constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    error UnsupportedCurrency();

    constructor(address _pool) {
        pool = _pool;
    }
    /**
    @notice 
    1) reverts if : 
        pool is not the caller, 
        currency is not ETH

     */
    function onFlashLoan( // 0x90ed06ae
        address,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata
    ) external returns (bytes32) {
        assembly { // gas savings
            // will execute if pool is not the caller.
            if iszero(eq(sload(pool.slot), caller())) {
                mstore(0x00, 0x48f5c3ed)
                revert(0x1c, 0x04)
            }
        }
        
        if (token != ETH)
            revert UnsupportedCurrency();
        
        uint256 amountToBeRepaid;
        unchecked {
            amountToBeRepaid = amount + fee;
        }

        _executeActionDuringFlashLoan();

        // call(), reverts if the execution fails
        SafeTransferLib.safeTransferETH(pool, amountToBeRepaid);

        return keccak256("ERC3156FlashBorrower.onFlashLoan");
        // 0x439148f0bbc682ca079e46d6e2c2f0c1e3b820f1a291b069d8882abf8cf18dd9
    }

    // Internal function where the funds received would be used
    function _executeActionDuringFlashLoan() internal { }

    // Allow deposits of ETH
    receive() external payable {}
}
