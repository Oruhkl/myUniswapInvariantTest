pragma solidity =0.5.16;

import "./FuzzHandlers.sol";

contract FuzzClamped is FuzzHandlers {
    function clamped_uniswapV2Pair_mint(address to) public asCurrentSender {
        require(to != address(0));
        (uint256 reserve0, uint256 reserve1,) = uniswapV2Pair.getReserves();
        uint256 amountToMint = between(0, 1, 2 ** 100);
        if (tokenA.balanceOf(address(uniswapV2Pair)) == 0) tokenA.mint(address(uniswapV2Pair), amountToMint);
        if (tokenB.balanceOf(address(uniswapV2Pair)) == 0) tokenB.mint(address(uniswapV2Pair), amountToMint);
        require(IToken(uniswapV2Pair.token0()).balanceOf(address(uniswapV2Pair)) > reserve0);
        require(IToken(uniswapV2Pair.token1()).balanceOf(address(uniswapV2Pair)) > reserve1);
        uniswapV2Pair_mint(to);
    }

    function clamped_uniswapV2Pair_burn(address to) public asCurrentSender {
        require(to != address(0));
        require(uniswapV2Pair.balanceOf(address(uniswapV2Pair)) > 0);
        require(IToken(uniswapV2Pair.token0()).balanceOf(address(uniswapV2Pair)) > 0);
        require(IToken(uniswapV2Pair.token1()).balanceOf(address(uniswapV2Pair)) > 0);

        uniswapV2Pair_burn(to);
    }

    function clamped_uniswapV2Pair_swap(uint256 amount0Out, uint256 amount1Out, address to, bytes memory data)
        public
        asCurrentSender
    {
        require(to != address(0));
        require(to != address(uniswapV2Pair.token0()) && to != address(uniswapV2Pair.token1()));

        (uint256 reserve0, uint256 reserve1,) = uniswapV2Pair.getReserves();
        require(reserve0 > 1000 && reserve1 > 1000);

        bool swapToken0 = (amount0Out % 2 == 0);

        if (swapToken0) {
            // Swapping token1 for token0
            uint256 token1Balance = IToken(uniswapV2Pair.token1()).balanceOf(address(uniswapV2Pair));
            require(token1Balance > reserve1);

            uint256 token1Input = token1Balance - reserve1;
            require(token1Input > 0);

            // Calculate maximum token0 output with proper fee accounting
            // Formula: amountOut = (amountIn * 997 * reserveOut) / (reserveIn * 1000 + amountIn * 997)
            uint256 numerator = token1Input * 997 * reserve0;
            uint256 denominator = reserve1 * 1000 + token1Input * 997;
            uint256 maxAmount0Out = numerator / denominator;

            require(maxAmount0Out > 0);
            require(maxAmount0Out < reserve0);

            amount0Out = between(amount0Out, 1, maxAmount0Out);
            amount1Out = 0;

            // Verify k-invariant will hold after swap
            uint256 balance0After = reserve0 - amount0Out;
            uint256 balance1After = token1Balance;
            uint256 balance0Adjusted = balance0After * 1000 - 0; // No token0 input
            uint256 balance1Adjusted = balance1After * 1000 - token1Input * 3; // 0.3% fee on input

            require(balance0Adjusted * balance1Adjusted >= reserve0 * reserve1 * (1000 * 1000));
        } else {
            // Swapping token0 for token1
            uint256 token0Balance = IToken(uniswapV2Pair.token0()).balanceOf(address(uniswapV2Pair));
            require(token0Balance > reserve0);

            uint256 token0Input = token0Balance - reserve0;
            require(token0Input > 0);

            // Calculate maximum token1 output
            uint256 numerator = token0Input * 997 * reserve1;
            uint256 denominator = reserve0 * 1000 + token0Input * 997;
            uint256 maxAmount1Out = numerator / denominator;

            require(maxAmount1Out > 0);
            require(maxAmount1Out < reserve1);

            amount0Out = 0;
            amount1Out = between(amount1Out, 1, maxAmount1Out);

            // Verify k-invariant will hold after swap
            uint256 balance0After = token0Balance;
            uint256 balance1After = reserve1 - amount1Out;
            uint256 balance0Adjusted = balance0After * 1000 - token0Input * 3; // 0.3% fee on input
            uint256 balance1Adjusted = balance1After * 1000 - 0; // No token1 input

            require(balance0Adjusted * balance1Adjusted >= reserve0 * reserve1 * (1000 * 1000));
        }

        uniswapV2Pair_swap(amount0Out, amount1Out, to, data);
    }
}
