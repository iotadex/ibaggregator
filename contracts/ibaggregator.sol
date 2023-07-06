// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import "./interfaces/ISwapRouterV2.sol";
import "./interfaces/ISwapRouterV3.sol";

contract IbAggregatorRouter {
    /// @notice Thrown when attempting to execute commands and an incorrect number of inputs are provided
    error LengthMismatch();
    /// @notice Thrown when a required command has failed
    error ExecutionFailed(uint256 commandIndex);

    struct SwapRouter {
        uint8 version;
        address router;
        address weth;
    }
    mapping(bytes1 => SwapRouter) public swapRouters;

    function execute(
        bytes calldata commands,
        bytes[] calldata inputs,
        uint256 deadline
    ) external payable {}

    function execute(
        bytes calldata commands,
        bytes[] calldata inputs
    ) public payable {
        uint256 numCommands = commands.length;
        if (inputs.length != numCommands) revert LengthMismatch();

        bool success;
        uint256 outAmount;
        for (uint256 commandIndex = 0; commandIndex < numCommands; ) {
            bytes1 command = commands[commandIndex];

            bytes calldata input = inputs[commandIndex];

            //(success, outAmount) = swap(command, input);

            if (!success) {
                revert ExecutionFailed({commandIndex: commandIndex});
            }

            unchecked {
                commandIndex++;
            }
        }
    }

    /*
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        //uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
*/
    function swap(bytes1 platform, bytes calldata inputs) public {
        SwapRouter memory swapRouter = swapRouters[platform];
        if (platform > 0x0f) {
            address tokenIn;
            address tokenOut;
            uint24 fee;
            address recipient;
            uint256 amountIn;
            uint256 amountOutMin;
            uint160 sqrtPriceLimitX96;
            assembly {
                tokenIn := calldataload(inputs.offset)
                tokenOut := calldataload(add(inputs.offset, 0x20))
                fee := calldataload(add(inputs.offset, 0x40))
                recipient := calldataload(add(inputs.offset, 0x60))
                amountIn := calldataload(add(inputs.offset, 0x80))
                amountOutMin := calldataload(add(inputs.offset, 0xA0))
                sqrtPriceLimitX96 := calldataload(add(inputs.offset, 0xC0))
            }
        } else {}
    }

    function swapV3(
        bytes1 platform,
        ISwapRouter.ExactInputSingleParams calldata params
    ) public payable {
        SwapRouter memory swapRouter = swapRouters[platform];
        //transfer token
        address tokenIn = params.tokenIn;
        if (tokenIn == address(0)) {
            tokenIn = swapRouter.weth;
            require(msg.value >= params.amountIn, "mismatch eth in");
        } else {}
    }

    function swapV2(
        uint8 platform,
        ISwapRouter.ExactInputSingleParams calldata params
    ) public payable {}
}
