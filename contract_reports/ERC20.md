https://github.com/JayeshShukla/damn-vulnerable-defi/blob/207d65b756fc8a011089b8a1e4d85bbfae58e84c/node_modules/solmate/src/tokens/ERC20.sol#L81-L101

```solidity
/**
     * @dev balanceOf[msg.sender] =  balanceOf[msg.sender] - amount;
     *      balanceOf[to] = balanceOf[to] + amount
     @dev issue : should be only managed by Pool.
     */
    function transfer(
        address to,
        uint256 amount
    ) public virtual returns (bool) {
        balanceOf[msg.sender] -= amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(msg.sender, to, amount);

        return true;
    }
```
