pragma solidity =0.5.16;

import "./FuzzBeforeAfter.sol";
import "../mocks/IToken.sol";

contract FuzzHandlers is FuzzBeforeAfter {
    function uniswapV2Pair_approve(address spender, uint256 value)
        public
        updateGhostsWithOperationType(OperationType.NONE)
    {
        uniswapV2Pair.approve(spender, value);
    }

    function uniswapV2Pair_burn(address to)
        public
        updateGhostsWithOperationType(OperationType.REMOVE)
        asCurrentSender
    {
        uniswapV2Pair.burn(to);
    }

    function uniswapV2Pair_mint(address to) public updateGhostsWithOperationType(OperationType.ADD) asCurrentSender {
        uniswapV2Pair.mint(to);
    }

    function uniswapV2Pair_permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public updateGhostsWithOperationType(OperationType.NONE) asCurrentSender {
        /**
         * @todo: for us to be able to get proper coverage on this function,
         * - we'll have to add a valid address in the `senderAddresses` in the medusa.json file
         * - using the private key of said valid address, generate signatures for it
         * - require that medusa use only this caller and one of the valid signatures when calling this method
         * - then can we get coverage of this part because of the constraints around cryptography and fuzzing tools
         */
        uniswapV2Pair.permit(owner, spender, value, deadline, v, r, s);
    }

    function uniswapV2Pair_skim(address to) public updateGhostsWithOperationType(OperationType.NONE) asCurrentSender {
        uniswapV2Pair.skim(to);
    }

    function uniswapV2Pair_swap(uint256 amount0Out, uint256 amount1Out, address to, bytes memory data)
        public
        updateGhostsWithOperationType(OperationType.SWAP)
        asCurrentSender
    {
        uniswapV2Pair.swap(amount0Out, amount1Out, to, data);
    }

    function uniswapV2Pair_setFeeToZeroAddress()
        public
        updateGhostsWithOperationType(OperationType.NONE)
        asCurrentSender
    {
        uniswapV2Factory.setFeeTo(address(0));
    }

    function uniswapV2Pair_setFeeTo(address feeTo)
        public
        updateGhostsWithOperationType(OperationType.NONE)
        asCurrentSender
    {
        uniswapV2Factory.setFeeTo(feeTo);
    }

    function uniswapV2Pair_sync() public updateGhostsWithOperationType(OperationType.NONE) asCurrentSender {
        uniswapV2Pair.sync();
    }

    function uniswapV2Pair_transfer(address to, uint256 value)
        public
        updateGhostsWithOperationType(OperationType.NONE)
        asCurrentSender
    {
        uniswapV2Pair.transfer(to, value);
    }

    function uniswapV2Pair_transferFrom(address from, address to, uint256 value)
        public
        updateGhostsWithOperationType(OperationType.NONE)
        asCurrentSender
    {
        uniswapV2Pair.transferFrom(from, to, value);
    }

    function tokenA_approve(address spender, uint256 amount)
        public
        updateGhostsWithOperationType(OperationType.NONE)
        asCurrentSender
    {
        tokenA.approve(spender, amount);
    }

    function tokenA_mint(address account, uint256 _amount)
        public
        updateGhostsWithOperationType(OperationType.NONE)
        asCurrentSender
    {
        uint256 amount = between(_amount, 0, 1_000_000 ether);
        tokenA.mint(account, amount);
    }

    function tokenA_transfer(address recipient, uint256 amount)
        public
        updateGhostsWithOperationType(OperationType.NONE)
        asCurrentSender
    {
        tokenA.transfer(recipient, amount);
    }

    function tokenA_transferFrom(address sender, address recipient, uint256 amount)
        public
        updateGhostsWithOperationType(OperationType.NONE)
        asCurrentSender
    {
        tokenA.transferFrom(sender, recipient, amount);
    }

    function tokenB_approve(address spender, uint256 amount)
        public
        updateGhostsWithOperationType(OperationType.NONE)
        asCurrentSender
    {
        tokenB.approve(spender, amount);
    }

    function tokenB_mint(address account, uint256 _amount)
        public
        updateGhostsWithOperationType(OperationType.NONE)
        asCurrentSender
    {
        uint256 amount = between(_amount, 0, 1_000_000 ether);
        tokenB.mint(account, amount);
    }

    function tokenB_transfer(address recipient, uint256 amount)
        public
        updateGhostsWithOperationType(OperationType.NONE)
        asCurrentSender
    {
        tokenB.transfer(recipient, amount);
    }

    function tokenB_transferFrom(address sender, address recipient, uint256 amount)
        public
        updateGhostsWithOperationType(OperationType.NONE)
        asCurrentSender
    {
        tokenB.transferFrom(sender, recipient, amount);
    }
}
