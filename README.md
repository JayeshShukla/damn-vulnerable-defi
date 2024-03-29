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

command to run test -> npx hardhat test free_rider.challenge.js About to use github linker and "@audit" tag to document stuff in .md file as mentioned here

---- before executing the code ------

I was unable to write report, because I dont have any clue how to write a good report.

** DO NOT READ FURTHER BELOW IF YOU HAVE NOT ALREADY TRIED SOLVING ** - highly recommended.

## Must know before solve :

- uniswapV2 also provides flash swap.
- msg.value for a transaction persist throught out the multitple transaction.

## Solution :

https://github.com/JayeshShukla/damn-vulnerable-defi/blob/207d65b756fc8a011089b8a1e4d85bbfae58e84c/test/free-rider/free-rider.challenge.js#L128-L140

```javascript
it("Execution", async function () {
  const playerContract = await (
    await ethers.getContractFactory("FaultyContract", player)
  ).deploy(
    uniswapPair.address,
    marketplace.address,
    weth.address,
    devsContract.address,
    nft.address
  );

  await playerContract.connect(player).firstTimer();
});
```

## Concepts Learned :

when compared to [this](https://medium.com/@JohnnyTime/damn-vulnerable-defi-v3-challenge-10-solution-free-rider-complete-walkthrough-7da8122691b3)

here are the differences :

- pre calculated the fee to be paid, while my code sends the ether without calculation.
- took the nft's and sent the flash loan right away then transfers the nft to developer,

while my code takes the nft transfers the nft to developer, then sends the loan back to uniswap.

NO MAJOR DIFFERENCE BOTH APPROCH ARE CORRECT.

## Hack & How to stop it

Two major issues found here:

- the "msg.value" validation is on the internal function, which remains the same throught multiple transaction. Rather should have stored it in a variable and made a check and then substracted the NFT_PRICE from the variable.

- the amount for which the NFT is bought, is sent to the new_owner (who bought the nft), rather then sending it to old_owner.
