pragma solidity =0.5.16;

import "./FuzzClamped.sol";

contract FuzzProps is FuzzClamped {
    function prop_uniswapV2Pair_swap() public view {
        if (operationType == OperationType.SWAP) {
            uint256 beforeK = uint256(_before.reserve0) * uint256(_before.reserve1);
            uint256 afterK = uint256(_after.reserve0) * uint256(_after.reserve1);
            assert(beforeK <= afterK);
        }
    }

    /**
     * Swapping decreases and increases token balances appropriately
     */
    function prop_uniswapV2Pair_swap_token_reserves() public view {
        if (operationType == OperationType.SWAP) {
            uint256 b0 = uint256(_before.reserve0);
            uint256 b1 = uint256(_before.reserve1);
            uint256 a0 = uint256(_after.reserve0);
            uint256 a1 = uint256(_after.reserve1);

            assert((b0 < a0 && b1 > a1) || (b0 > a0 && b1 < a1));
        }
    }

    /**
     * mint increases K
     */
    function prop_uniswapV2Pair_mint_increases_K() public view {
        if (operationType == OperationType.ADD) {
            uint256 beforeK = uint256(_before.reserve0) * uint256(_before.reserve1);
            uint256 afterK = uint256(_after.reserve0) * uint256(_after.reserve1);
            assert(beforeK < afterK);
        }
    }
    /**
     * burn decreases K
     */

    function prop_uniswapV2Pair_burn_decreases_K() public view {
        if (operationType == OperationType.REMOVE) {
            uint256 beforeK = uint256(_before.reserve0) * uint256(_before.reserve1);
            uint256 afterK = uint256(_after.reserve0) * uint256(_after.reserve1);
            assert(beforeK > afterK);
        }
    }
}
