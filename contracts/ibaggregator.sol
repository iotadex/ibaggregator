// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import "./interfaces/ISwapRouterV2.sol";
import "./interfaces/ISwapRouterV3.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./libraries/TransferHelper.sol";

contract IbAggregatorRouter {
    /// @notice Thrown when attempting to execute commands and an incorrect number of inputs are provided
    error LengthMismatch();
    /// @notice Thrown when a required command has failed
    error ExecutionFailed(uint256 commandIndex);

    /// @notice Thrown when executing commands with an expired deadline
    error TransactionDeadlinePassed();

    struct SwapRouter {
        uint8 version;
        address router;
        address weth;
    }
    mapping(bytes1 => SwapRouter) public swapRouters;

    modifier checkDeadline(uint256 deadline) {
        if (block.timestamp > deadline) revert TransactionDeadlinePassed();
        _;
    }

    function executeEth(
        address[] calldata tokenIns,
        uint8[] calldata counts,
        bytes[] calldata inputs,
        uint256 deadline
    ) external payable checkDeadline(deadline) {
        uint256 numTokenIns = tokenIns.length;
        if (counts.length != numTokenIns) revert LengthMismatch();

        uint256 amountIn = msg.value;
        for (uint256 j = 0; j < counts[0]; j++) {
            bytes calldata input = inputs[j];
            swap(address(0), amountIn, input);
        }

        uint256 inputIndex = counts[0];
        for (uint256 i = 1; i < numTokenIns; i++) {
            amountIn = IERC20(tokenIns[i]).balanceOf(address(this));
            for (uint256 j = 0; j < counts[i]; j++) {
                bytes calldata input = inputs[inputIndex];
                swap(tokenIns[i], amountIn, input);
                inputIndex++;
            }
        }
    }

    function execute(
        address[] calldata tokenIns,
        uint8[] calldata counts,
        bytes[] calldata inputs,
        uint256 amountIn,
        uint256 deadline
    ) external payable checkDeadline(deadline) {
        uint256 numTokenIns = tokenIns.length;
        if (counts.length != numTokenIns) revert LengthMismatch();
        TransferHelper.safeTransferFrom(
            tokenIns[0],
            msg.sender,
            address(this),
            amountIn
        );
        uint256 inputIndex = 0;
        for (uint256 i = 0; i < numTokenIns; i++) {
            amountIn = IERC20(tokenIns[i]).balanceOf(address(this));
            for (uint256 j = 0; j < counts[i]; j++) {
                bytes calldata input = inputs[inputIndex];
                swap(tokenIns[i], amountIn, input);
                inputIndex++;
            }
        }
    }

    function swap(
        address tokenIn,
        uint256 amountTotalIn,
        bytes calldata inputs
    ) internal returns (uint256) {
        bytes1 platform;
        assembly {
            platform := calldataload(inputs.offset)
        }
        SwapRouter memory swapRouter = swapRouters[platform];

        if (platform > 0x0f) {
            address tokenOut;
            uint24 fee;
            address recipient;
            uint8 percent;
            assembly {
                tokenOut := calldataload(add(inputs.offset, 0x20))
                fee := calldataload(add(inputs.offset, 0x40))
                recipient := calldataload(add(inputs.offset, 0x60))
                percent := calldataload(add(inputs.offset, 0x80))
            }
            return
                ISwapRouter(swapRouter.router).exactInputSingle(
                    ISwapRouter.ExactInputSingleParams(
                        tokenIn == address(0) ? swapRouter.weth : tokenIn,
                        tokenOut,
                        fee,
                        recipient,
                        999999999999999,
                        (amountTotalIn * percent) / 100,
                        0,
                        0
                    )
                );
        } else {}
        return 0;
    }
}
