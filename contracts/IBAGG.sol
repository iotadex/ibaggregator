// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}


// File contracts/interfaces/IShimmerSea.sol

pragma solidity >0.8.10;

/**
 * @title Liquidity Book Router Interface
 * @author Trader Joe
 * @notice Required interface of LBRouter contract
 */
interface ILBRouter {
    /**
     * @dev This enum represents the version of the pair requested
     * - V1: Joe V1 pair
     * - V2: LB pair V2. Also called legacyPair
     * - V2_1: LB pair V2.1 (current version)
     */
    enum Version {
        V1,
        V2,
        V2_1
    }

    /**
     * @dev The path parameters, such as:
     * - pairBinSteps: The list of bin steps of the pairs to go through
     * - versions: The list of versions of the pairs to go through
     * - tokenPath: The list of tokens in the path to go through
     */
    struct Path {
        uint256[] pairBinSteps;
        Version[] versions;
        IERC20[] tokenPath;
    }

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        Path memory path,
        address to,
        uint256 deadline
    ) external returns (uint256 amountOut);

    function swapExactTokensForNATIVE(
        uint256 amountIn,
        uint256 amountOutMinNATIVE,
        Path memory path,
        address payable to,
        uint256 deadline
    ) external returns (uint256 amountOut);

    function swapExactNATIVEForTokens(uint256 amountOutMin, Path memory path, address to, uint256 deadline)
        external
        payable
        returns (uint256 amountOut);
}


// File contracts/interfaces/ISwapRouterV2.sol

pragma solidity >=0.6.2;

interface ISwapRouterV2 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapExactETHForTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);

    function swapTokensForExactETH(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapExactTokensForETH(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapETHForExactTokens(
        uint amountOut,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);
}


// File contracts/interfaces/ISwapRouterV3.sol

pragma solidity >=0.7.5;
pragma abicoder v2;

/// @title Router token swapping functionality
/// @notice Functions for swapping tokens via Uniswap V3
interface ISwapRouterV3 {
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    /// @notice Swaps `amountIn` of one token for as much as possible of another token
    /// @param params The parameters necessary for the swap, encoded as `ExactInputSingleParams` in calldata
    /// @return amountOut The amount of the received token
    function exactInputSingle(
        ExactInputSingleParams calldata params
    ) external payable returns (uint256 amountOut);

    struct ExactInputParams {
        bytes path;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
    }

    /// @notice Swaps `amountIn` of one token for as much as possible of another along the specified path
    /// @param params The parameters necessary for the multi-hop swap, encoded as `ExactInputParams` in calldata
    /// @return amountOut The amount of the received token
    function exactInput(
        ExactInputParams calldata params
    ) external payable returns (uint256 amountOut);

    struct ExactOutputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountOut;
        uint256 amountInMaximum;
        uint160 sqrtPriceLimitX96;
    }

    /// @notice Swaps as little as possible of one token for `amountOut` of another token
    /// @param params The parameters necessary for the swap, encoded as `ExactOutputSingleParams` in calldata
    /// @return amountIn The amount of the input token
    function exactOutputSingle(
        ExactOutputSingleParams calldata params
    ) external payable returns (uint256 amountIn);

    struct ExactOutputParams {
        bytes path;
        address recipient;
        uint256 deadline;
        uint256 amountOut;
        uint256 amountInMaximum;
    }

    /// @notice Swaps as little as possible of one token for `amountOut` of another along the specified path (reversed)
    /// @param params The parameters necessary for the multi-hop swap, encoded as `ExactOutputParams` in calldata
    /// @return amountIn The amount of the input token
    function exactOutput(
        ExactOutputParams calldata params
    ) external payable returns (uint256 amountIn);

    /// @notice Unwraps the contract's WETH9 balance and sends it to recipient as ETH.
    /// @dev The amountMinimum parameter prevents malicious contracts from stealing WETH9 from users.
    /// @param amountMinimum The minimum amount of WETH9 to unwrap
    /// @param recipient The address receiving ETH
    function unwrapWETH9(
        uint256 amountMinimum,
        address recipient
    ) external payable;

    /// @return Returns the address of WETH9
    function WETH9() external view returns (address);
}


// File contracts/libraries/TransferHelper.sol

pragma solidity >=0.6.0;

library TransferHelper {
    /// @notice Transfers tokens from the targeted address to the given destination
    /// @notice Errors with 'STF' if transfer fails
    /// @param token The contract address of the token to be transferred
    /// @param from The originating address from which the tokens will be transferred
    /// @param to The destination address of the transfer
    /// @param value The amount to be transferred
    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 value
    ) internal {
        (bool success, bytes memory data) =
            token.call(abi.encodeWithSelector(IERC20.transferFrom.selector, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'STF');
    }

    /// @notice Transfers tokens from msg.sender to a recipient
    /// @dev Errors with ST if transfer fails
    /// @param token The contract address of the token which will be transferred
    /// @param to The recipient of the transfer
    /// @param value The value of the transfer
    function safeTransfer(
        address token,
        address to,
        uint256 value
    ) internal {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(IERC20.transfer.selector, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'ST');
    }

    /// @notice Approves the stipulated contract to spend the given allowance in the given token
    /// @dev Errors with 'SA' if transfer fails
    /// @param token The contract address of the token to be approved
    /// @param to The target of the approval
    /// @param value The amount of the given token the target will be allowed to spend
    function safeApprove(
        address token,
        address to,
        uint256 value
    ) internal {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(IERC20.approve.selector, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'SA');
    }

    /// @notice Transfers ETH to the recipient address
    /// @dev Fails with `STE`
    /// @param to The destination of the transfer
    /// @param value The value to be transferred
    function safeTransferETH(address to, uint256 value) internal {
        (bool success, ) = to.call{value: value}(new bytes(0));
        require(success, 'STE');
    }
}


// File contracts/ownable.sol


pragma solidity >=0.8.18;

contract Ownable {
    address public owner;
    address internal newOwner;

    //transfer the owner
    function transferOwner(address _owner) external {
        require(msg.sender == owner, "forbidden");
        newOwner = _owner;
    }

    //accept the owner
    function acceptOwner() external {
        require(msg.sender == newOwner, "forbidden");
        owner = newOwner;
        newOwner = address(0);
    }
}


// File contracts/ibaggregator.sol

pragma solidity 0.8.18;





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
                    amountOut += ao;
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
            }else{
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
        //address[] memory path = new address[](2);
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
