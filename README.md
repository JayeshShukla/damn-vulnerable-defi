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

command to run test -> npx hardhat test compromised.challenge.js About to use github linker and "@audit" tag to document stuff in .md file as mentioned here

---- before executing the code ------

I was unable to write report, because I dont have any clue how to write a good report.

** DO NOT READ FURTHER BELOW IF YOU HAVE NOT ALREADY TRIED SOLVING ** - highly recommended.

## Solution :

1. This CTF was very different form the previous one so far, and after trying for long enough I had to do a little bit of cheating I would say, because I was unable to make any sense with the provided snippet. YES! ITS VERY IMPORTANT PART OF THE PROBLEM.

2. the two jibberish set of hexadecimal numbers are nothing but -- private keys of 2 resources.

3. I guess I was unable to think in this direction because never in my dream I would dream the private keys would be leaked. But its ok now ik to be aware of the private key.

4. If you are able to figure the above step out the rest code is walk in the park.

## Concepts Learned :

[here](https://medium.com/@JohnnyTime/damn-vulnerable-defi-v3-compromised-challenge-7-solution-complete-walkthrough-ea9b42c23068)

when comparing my code with the above url these are all the findings :

1. I used onlin tools to convert the hexadecimal to utf-8 text format, you can find more information on, Exchange.md

2. https://github.com/JayeshShukla/damn-vulnerable-defi/blob/207d65b756fc8a011089b8a1e4d85bbfae58e84c/test/compromised/compromised.challenge.js#L80-L82

```javascript
await oracle.connect(signer1).postPrice("DVNFT", 0);
await oracle.connect(signer2).postPrice("DVNFT", 0);
```

here the post suggest "1" instead of "0", but I dont think that is necessary, an oracle can change the price to 0 of the particular NFT, there is no boundation to that.

3. They have also used other other which I dont have to because I reduced the price of nft to 0.

4. while selling the nft, I learnt a ton about hardhat as follows :
   https://github.com/JayeshShukla/damn-vulnerable-defi/blob/207d65b756fc8a011089b8a1e4d85bbfae58e84c/test/compromised/compromised.challenge.js#L84-L87

```javascript
const tx = await exchange.connect(player).buyOne({ value: 1 });
const receipt = await tx.wait();
const event = receipt.events.find((e) => e.event === "TokenBought");
const id = event.args[1].toNumber();
```

## Hack & How to stop it

Simply dont disclouse your PRIVATE KEY.
