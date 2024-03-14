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

command to run test -> npx hardhat test truster.challenge.js
About to use github linker and "@audit" tag to document stuff in .md file as mentioned [here](https://www.youtube.com/watch?v=oY9Eu1l-C_w&t=3862s)

---- before executing the code ------

I was unable to write report, because I dont have any clue how to write a good report.

** DO NOT READ FURTHER BELOW IF YOU HAVE NOT ALREADY TRIED SOLVING ** - highly recommended.

## Solution :

https://github.com/JayeshShukla/damn-vulnerable-defi/blob/207d65b756fc8a011089b8a1e4d85bbfae58e84c/contracts/truster/FaultyContract.sol

## Concepts Learned In Actions

1. "target.call{value: value}(data)" -> sends calldata (any function selector) with ether as value
2. abi.encodeWithSignature("approve(address,uint256)", spender, amount); -> selector and params to send.
3. as provided above is the link to code, did that in one transaction i.e in a constructor.
   I learned this from "naive_reciever" [2nd CTF of Damn Vulnerable DeFi].

## External solution

As mentioned [here](https://medium.com/@JohnnyTime/damn-vulnerable-defi-truster-challenge-3-solution-complete-walkthrough-cac8adf55233) learned few hardhat related concepts like :

1. let interface = new ethers.utils.Interface(["function approve(address spender, uint256 amount)"])
2. let data = interface.encodeFunctionData("approve", [player.address, TOKENS_IN_POOL]);

The above 2 points describes how I could have achieved the same results just by 2 hardhat testing, no need to deploy a contract to achieve the same which will require some eth to deploy.

POSITIVE TAKE AWAY : The logic I applied is exactly same as given in the URL above.

## Hack & How to stop it

I might me completely or partially wrong, but being wrong is part of the process.
feel free to reach out to me incase you want to correct me.

```solidity

    // this line of code has an issue, as the target contract could be "token"
    // to rectify it one can actually put the condition "target != token".
    target.functionCall(data);
```
