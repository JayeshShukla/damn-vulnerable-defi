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

command to run test -> npx hardhat test naive-receiver.challenge.js

** DO NOT READ FURTHER BELOW IF YOU HAVE NOT ALREADY TRIED SOLVING ** - highly recommended.

As you we can see the code in "FlashLoanPlayer.sol", is way too long and the given solution [here](https://medium.com/@JohnnyTime/damn-vulnerable-defi-v3-naive-receiver-challenge-2-solution-complete-walkthrough-73a06de164ef) is precise and short.

## Concepts Learned In Actions
1) Upon experimenting with SafeTransferLib.safeTransferETH, it was observed that the lending account must hold the desired amount requested by the borrower. Additionally, SafeTransferLib throws an error if the available funds in the pool are reduced to zero and the borrower attempts to borrow beyond this zero balance.

2)While exploring the concept of reentrancy attacks in FlashLoanPlayer.sol, it was initially believed that a reentrancy attack was successfully executed. However, it was later realized that the attack did not involve reentering the function while its execution was incomplete, which is the essence of a reentrancy attack. Despite attempting to implement a nonReentrant modifier to prevent the attack, it proved ineffective. This experience highlighted the importance of thoroughly dry running code to gain a deeper understanding of underlying concepts.
