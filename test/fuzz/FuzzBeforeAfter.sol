pragma solidity =0.5.16;

import "./FuzzSetup.sol";

contract FuzzBeforeAfter is FuzzSetup {
    struct Vars {
        uint112 reserve0;
        uint112 reserve1;
    }

    enum OperationType {
        NONE,
        SWAP,
        ADD,
        REMOVE
    }

    OperationType public operationType;

    Vars internal _before;
    Vars internal _after;

    // modifier updateGhosts() {
    //     __before();
    //     _;
    //     __after();
    // }

    modifier updateGhostsWithOperationType(OperationType opType) {
        operationType = opType;
        __before();
        _;
        __after();
    }

    function __before() internal {
        (_before.reserve0, _before.reserve1,) = uniswapV2Pair.getReserves();
    }

    function __after() internal {
        (_after.reserve0, _after.reserve1,) = uniswapV2Pair.getReserves();
    }
}
