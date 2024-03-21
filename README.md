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

command to run test -> npx hardhat test selfie.challenge.js About to use github linker and "@audit" tag to document stuff in .md file as mentioned here

---- before executing the code ------

I was unable to write report, because I dont have any clue how to write a good report.

** DO NOT READ FURTHER BELOW IF YOU HAVE NOT ALREADY TRIED SOLVING ** - highly recommended.

## Solution :

when compared with [this](https://medium.com/@JohnnyTime/damn-vulnerable-defi-v3-challenge-6-walkthrough-selfie-solution-2dd62fe89dd7)

## Concepts Learned :

1. my logic was correct but was unable to impliment Interface because little confused regarding Interface concept. Had to check it on the above mentioned URL.

2. Concept wise nothing new to learn.

## Hack & How to stop it

The protocol had issue that user can submit the action queue and execute it. Rather a particular check should be made of the excecuting the function that wether the user has some tokens in token contract.
