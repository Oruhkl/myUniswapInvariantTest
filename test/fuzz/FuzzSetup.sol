pragma solidity =0.5.16;

import "../../contracts/UniswapV2Factory.sol";
import "../../contracts/UniswapV2Pair.sol";
import {Vm, IHevm} from "./Hevm.sol";
import {MockToken} from "../mocks/MockToken.sol";

contract FuzzSetup {
    UniswapV2Factory uniswapV2Factory;
    UniswapV2Pair uniswapV2Pair;
    Counter counter;

    MockToken tokenA;
    MockToken tokenB;

    IHevm vm = Vm.vm();

    address feeSetter;
    address currentSender;

    event PairCreated(address pair);

    constructor() public {
        vm.prank(msg.sender);
        counter = new Counter();
        uniswapV2Factory = new UniswapV2Factory(address(this));

        // uniswapV2Factory.setFeeToSetter(address(this));
        uniswapV2Factory.setFeeTo(address(this));

        tokenA = new MockToken("TokenA", "TKNa", 18);
        tokenB = new MockToken("TokenB", "TKNb", 18);

        // vm.prank(msg.sender);
        uniswapV2Pair = UniswapV2Pair(uniswapV2Factory.createPair(address(tokenA), address(tokenB)));
    }

    event Log(string);

    function t(bool b, string memory reason) internal {
        if (!b) {
            emit Log(reason);
            assert(false);
        }
    }

    function between(uint256 value, uint256 low, uint256 high) internal pure returns (uint256) {
        if (value < low || value > high) {
            uint256 range = high - low + 1;
            uint256 clamped = (value - low) % (range);
            if (clamped < 0) clamped += range;
            uint256 ans = low + clamped;
            return ans;
        }
        return value;
    }

    modifier asCurrentSender() {
        currentSender = counter.incrementCounter();
        if (tokenA.balanceOf(currentSender) < (2 ** 31)) {
            tokenA.mint(currentSender, (2 ** 127));
        }
        if (tokenB.balanceOf(currentSender) < (2 ** 31)) {
            tokenB.mint(currentSender, (2 ** 127));
        }
        emit PairCreated(address(uniswapV2Pair));
        vm.startPrank(currentSender);
        tokenA.approve(address(uniswapV2Pair), (2 ** 255));
        tokenB.approve(address(uniswapV2Pair), (2 ** 255));
        _;
        vm.stopPrank();
        currentSender = address(0);
    }
}

contract Counter {
    uint256 counter;

    function incrementCounter() external returns (address) {
        counter++;
        return address(msg.sender);
    }
}
