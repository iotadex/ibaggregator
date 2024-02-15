// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.18;

import "./interfaces/ISwapRouterV2.sol";
import "./interfaces/ISwapRouterV3.sol";
import "./interfaces/IShimmerSea.sol";
import "./libraries/TransferHelper.sol";
import "./ownable.sol";

contract IbAggregatorRouter is Ownable {
    uint16 public constant PERCENT = 10000;
    uint16 public constant FEERATE = 10;
    address public immutable feeReceipt;

    struct SwapRouter {
        address router; // the swap router contract address
        address weth; // wrap eth contract address
    }
    // platform => swap router, if v2 platform <= 0x0f, if v3 platform > 0x0f
    mapping(uint8 => SwapRouter) public swapRouters;
    // all the routers
    address[] internal routers;

    modifier checkDeadline(uint256 deadline) {
        require(block.timestamp <= deadline, "deadline") ;
        _;
    }

    event AggregatorSwap(address indexed sender, address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOut);

    constructor(address receipt) {
        owner = msg.sender;
        feeReceipt = receipt;

        address router = 0xb783f05F28DFABD0d09Ccb524e6C6289Cb0e7C1F;
        address weth = ISwapRouterV3(router).WETH9();
        swapRouters[16] = SwapRouter(router, weth);
        routers.push(router);

        router = 0x1372C03B0c542017a256473706BA6121F8263980;
        weth = 0xBEb654A116aeEf764988DF0C6B4bf67CC869D01b;
        swapRouters[17] = SwapRouter(router, weth);
        routers.push(router);

        router = 0x1dBCC54d42503dA1455A38ab74b0e6b780d65Bc0; 
        weth = 0xBEb654A116aeEf764988DF0C6B4bf67CC869D01b;
        swapRouters[1] = SwapRouter(router, weth);
        routers.push(router);
    }

    /// @notice Executes the encoded swap commands along with provided inputs as params. The first tokenIn is ETH. Reverts if deadline has expired.
    /// @param tokenIns A set of tokens, each token contains several inputs params.
    /// @param counts The count of each tokenIn contains inputs params.
    /// @param inputs An array of byte strings containing abi encoded inputs for each swap command
    /// @param deadline The deadline by which the transaction must be executed
    function executeFromEth(
        address[] calldata tokenIns,
        uint8[] calldata counts,
        bytes[] calldata inputs,
        address tokenOut,
        uint256 amountOutMin,
        uint256 deadline
    ) external payable checkDeadline(deadline) {
        require(counts.length == tokenIns.length, "length of counts error");
        if (counts[0] > 1){ // take fee
            TransferHelper.safeTransferETH(feeReceipt, msg.value * FEERATE /PERCENT);
        }

        amountOutMin = execute(tokenIns, counts, inputs, tokenOut, amountOutMin);
        
        emit AggregatorSwap(msg.sender, tokenIns[0], tokenOut, msg.value, amountOutMin);
    }

    /// @notice Executes the encoded swap commands along with provided inputs as params. The first tokenIn is ERC20. Reverts if deadline has expired.
    /// @param tokenIns A set of tokens, each token contains several inputs params.
    /// @param counts The count of each tokenIn contains inputs params.
    /// @param inputs An array of byte strings containing abi encoded inputs for each swap command
    /// @param deadline The deadline by which the transaction must be executed
    function executeFromToken(
        address[] calldata tokenIns,
        uint8[] calldata counts,
        bytes[] calldata inputs,
        address tokenOut,
        uint256 amountIn,
        uint256 amountOutMin,
        uint256 deadline
    ) external checkDeadline(deadline) {
        require(counts.length == tokenIns.length, "length of counts error");
        TransferHelper.safeTransferFrom(
            tokenIns[0],
            msg.sender,
            address(this),
            amountIn
        );

        if (counts[0] > 1){ // take fee
            TransferHelper.safeTransfer(tokenIns[0], feeReceipt, (amountIn * FEERATE) / PERCENT);
        }

        amountOutMin = execute(tokenIns, counts, inputs, tokenOut, amountOutMin);
        emit AggregatorSwap(msg.sender, tokenIns[0], tokenOut, amountIn, amountOutMin);
    }

    function execute(
        address[] calldata tokenIns,
        uint8[] calldata counts,
        bytes[] calldata inputs,
        address tokenOut,
        uint256 amountOutMin
    ) internal returns (uint256 amountOut){
        uint256 inputIndex = 0;
        for (uint256 i = 0; i < tokenIns.length; i++) {
            uint256 amountIn;
            if (tokenIns[i] == address(0)){
                amountIn = address(this).balance;
            }else{
                amountIn = IERC20(tokenIns[i]).balanceOf(address(this)); 
            }
            for (uint256 j = 0; j < counts[i]; j++) {
                (uint256 ao, address to) = swap(tokenIns[i], amountIn, inputs[inputIndex]);
                if ((to == 0x1074010000000000000000000000000000000000) && (tokenOut == address(0))){
                    amountOut += ao * 1000000000000;
                }else if (tokenOut == to){
                    amountOut += ao;
                }
                inputIndex++;
            }
        }
        require(amountOut >= amountOutMin, "amount out min required");
    }

    function swap(
        address tokenIn,
        uint256 amountIn,
        bytes calldata inputs
    ) internal returns(uint256 amountOut, address tokenOut){
        uint8 platform;
        assembly {
            platform := calldataload(inputs.offset)
        }
        SwapRouter memory swapRouter = swapRouters[platform];
        require(swapRouter.router != address(0), "don't support");

        if (platform > 0x0f) {
            uint24 fee;
            address recipient;
            uint16 percent;
            assembly {
                tokenOut := calldataload(add(inputs.offset, 0x20))
                fee := calldataload(add(inputs.offset, 0x40))
                recipient := calldataload(add(inputs.offset, 0x60))
                percent := calldataload(add(inputs.offset, 0x80))
            }
            amountIn = (amountIn * percent) / PERCENT;
            amountOut = swapUniV3(swapRouter, recipient, tokenIn, tokenOut, fee, amountIn);
        }else {
            address recipient;
            uint16 percent;
            assembly {
                tokenOut := calldataload(add(inputs.offset, 0x20))
                recipient := calldataload(add(inputs.offset, 0x40))
                percent := calldataload(add(inputs.offset, 0x60))
            }
            amountIn = (amountIn * percent) / PERCENT;
            if (platform == 0x01){
                amountOut = swapShimmerSea(swapRouter, recipient, tokenIn, tokenOut, amountIn);
            } else if (platform == 0x02){
                amountOut = swapLine(swapRouter, recipient, tokenIn, tokenOut, amountIn);
            } else{
                amountOut = swapUniV2(swapRouter, recipient, tokenIn, tokenOut, amountIn);
            }
        }
    }

    function swapUniV3(SwapRouter memory swapRouter, address recipient, address tokenIn, address tokenOut, uint24 fee, uint256 amountIn) internal returns(uint256 amountOut){
        if (tokenOut == address(0)) {
            amountOut = ISwapRouterV3(swapRouter.router)
                .exactInputSingle(
                    ISwapRouterV3.ExactInputSingleParams(
                        tokenIn,
                        swapRouter.weth,
                        fee,
                        address(0),
                        type(uint256).max,
                        amountIn,
                        0,
                        0
                    )
                );
            ISwapRouterV3(swapRouter.router).unwrapWETH9(
                0,
                recipient
            );
        } else {
            if (tokenIn == address(0)) {
                amountOut = ISwapRouterV3(swapRouter.router).exactInputSingle{
                    value: amountIn
                }(
                    ISwapRouterV3.ExactInputSingleParams(
                        swapRouter.weth,
                        tokenOut,
                        fee,
                        recipient,
                        type(uint256).max,
                        amountIn,
                        0,
                        0
                    )
                );
            } else {
                amountOut = ISwapRouterV3(swapRouter.router).exactInputSingle(
                    ISwapRouterV3.ExactInputSingleParams(
                        tokenIn,
                        tokenOut,
                        fee,
                        recipient,
                        type(uint256).max,
                        amountIn,
                        0,
                        0
                    )
                );
            }
        }
    }

    function swapUniV2(SwapRouter memory swapRouter, address recipient, address tokenIn, address tokenOut, uint256 amountIn) internal returns(uint256 amountOut){
        address[] memory path = new address[](2);
        if (tokenIn == address(0)) {
            path[0] = swapRouter.weth;
            path[1] = tokenOut;
            uint[] memory outs = ISwapRouterV2(swapRouter.router).swapExactETHForTokens{
                value: amountIn
            }(0, path, recipient, type(uint256).max);
            amountOut = outs[0];
        } else if (tokenOut == address(0)) {
            path[0] = tokenIn;
            path[1] = swapRouter.weth;
            uint[] memory outs = ISwapRouterV2(swapRouter.router).swapExactTokensForETH(
                amountIn,
                0,
                path,
                recipient,
                type(uint256).max
            );
            amountOut = outs[0];
        } else {
            path[0] = tokenIn;
            path[1] = tokenOut;
            uint[] memory outs = ISwapRouterV2(swapRouter.router).swapExactTokensForTokens(
                amountIn,
                0,
                path,
                recipient,
                type(uint256).max
            );
            amountOut = outs[0];
        }
    }

    mapping(address => mapping(address => uint256[])) public pairBinSteps;
    mapping(address => mapping(address => ILBRouter.Version[])) public versions;
    function swapShimmerSea(SwapRouter memory swapRouter, address recipient, address tokenIn, address tokenOut, uint256 amountIn) internal returns(uint256 amountOut){
        if (tokenIn == address(0)) {
            ILBRouter.Path memory path = getShimmerSeaPath(swapRouter.weth, tokenOut);
            amountOut = ILBRouter(swapRouter.router).swapExactNATIVEForTokens{
                value: amountIn
            }(
                0, 
                path, 
                recipient, 
                type(uint256).max
            );
        } else if (tokenOut == address(0)) {
            ILBRouter.Path memory path = getShimmerSeaPath(tokenIn, swapRouter.weth);
            amountOut = ILBRouter(swapRouter.router).swapExactTokensForNATIVE(
                amountIn,
                0,
                path,
                payable(recipient),
                type(uint256).max
            );
        } else {
            ILBRouter.Path memory path = getShimmerSeaPath(tokenIn, tokenOut);
            amountOut = ILBRouter(swapRouter.router).swapExactTokensForTokens(
                amountIn,
                0,
                path,
                recipient,
                type(uint256).max
            );
        }
    }

    function getShimmerSeaPath(address tokenIn, address tokenOut) internal view returns (ILBRouter.Path memory path){
        IERC20[] memory p = new IERC20[](2);
        p[0] = IERC20(tokenIn);
        p[1] = IERC20(tokenOut);
        path = ILBRouter.Path(pairBinSteps[tokenIn][tokenOut], versions[tokenIn][tokenOut], p);
    }

    function setShimmerSeaPath(address[] memory tokens0, address[] memory tokens1, uint256[] memory _binSteps, uint8[] memory _versions) external{
        require(msg.sender == owner, "forbiden");
        for (uint256 i = 0; i < tokens0.length; i++) {
            uint256[] memory binSteps = new uint256[](1);
            binSteps[0] = _binSteps[i];
            ILBRouter.Version[] memory vs = new ILBRouter.Version[](1);
            vs[0] = ILBRouter.Version(_versions[i]);

            pairBinSteps[tokens0[i]][tokens1[i]] = binSteps;
            pairBinSteps[tokens1[i]][tokens0[i]] = binSteps;
            versions[tokens0[i]][tokens1[i]] = vs;
            versions[tokens1[i]][tokens0[i]] = vs;
        }
    }

    mapping(address => mapping(address => uint256[])) public linePairBinSteps;
    mapping(address => mapping(address => ILBRouter.Version[])) public lineVersions;
    function swapLine(SwapRouter memory swapRouter, address recipient, address tokenIn, address tokenOut, uint256 amountIn) internal returns(uint256 amountOut){
        if (tokenIn == address(0)) {
            ILBRouter.Path memory path = getSwapLinePath(swapRouter.weth, tokenOut);
            amountOut = ILBRouter(swapRouter.router).swapExactNATIVEForTokens{
                value: amountIn
            }(
                0, 
                path, 
                recipient, 
                type(uint256).max
            );
        } else if (tokenOut == address(0)) {
            ILBRouter.Path memory path = getSwapLinePath(tokenIn, swapRouter.weth);
            amountOut = ILBRouter(swapRouter.router).swapExactTokensForNATIVE(
                amountIn,
                0,
                path,
                payable(recipient),
                type(uint256).max
            );
        } else {
            ILBRouter.Path memory path = getSwapLinePath(tokenIn, tokenOut);
            amountOut = ILBRouter(swapRouter.router).swapExactTokensForTokens(
                amountIn,
                0,
                path,
                recipient,
                type(uint256).max
            );
        }
    }

    function getSwapLinePath(address tokenIn, address tokenOut) internal view returns (ILBRouter.Path memory path){
        IERC20[] memory p = new IERC20[](2);
        p[0] = IERC20(tokenIn);
        p[1] = IERC20(tokenOut);
        path = ILBRouter.Path(linePairBinSteps[tokenIn][tokenOut], lineVersions[tokenIn][tokenOut], p);
    }

    function setSwapLinePath(address[] memory tokens0, address[] memory tokens1, uint256[] memory _binSteps, uint8[] memory _versions) external{
        require(msg.sender == owner, "forbiden");
        for (uint256 i = 0; i < tokens0.length; i++) {
            uint256[] memory binSteps = new uint256[](1);
            binSteps[0] = _binSteps[i];
            ILBRouter.Version[] memory vs = new ILBRouter.Version[](1);
            vs[0] = ILBRouter.Version(_versions[i]);

            linePairBinSteps[tokens0[i]][tokens1[i]] = binSteps;
            linePairBinSteps[tokens1[i]][tokens0[i]] = binSteps;
            lineVersions[tokens0[i]][tokens1[i]] = vs;
            lineVersions[tokens1[i]][tokens0[i]] = vs;
        }
    }

    function addRouter(uint8 platform, address router) external {
        require(msg.sender == owner, "forbiden");
        address weth;
        if (platform > 0x0f) {
            weth = ISwapRouterV3(router).WETH9();
        } else if (platform > 0x01) {
            weth = ISwapRouterV2(router).WETH();
        }
        swapRouters[platform] = SwapRouter(router, weth);
        routers.push(router);
    }

    function approve(address[] calldata tokens) external {
        uint n = tokens.length;
        uint256 m = routers.length;
        for (uint256 i = 0; i < n; i++) {
            for (uint256 j = 0; j < m; j++) {
                IERC20(tokens[i]).approve(routers[j], type(uint256).max);
            }
        }
    }

    receive() external payable {}
}
