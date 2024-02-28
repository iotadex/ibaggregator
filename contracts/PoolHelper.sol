// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.8.0;

import "./interfaces/IUniswapV3Pool.sol";
import "./interfaces/ILBPair.sol";

/// @title PoolHelper contract
contract PoolHelper {
    uint256 private constant OFFSET = 128;
    uint256 private constant MASK_128 = 0xffffffffffffffffffffffffffffffff;

    struct PopulatedTick {
        int24 tick;
        int128 liquidityNet;
        uint128 liquidityGross;
    }

    function getPopulatedTicksInWord(
        address pool,
        int16 tickBitmapIndex
    )
        public
        view
        returns (PopulatedTick[] memory populatedTicks, uint64 height)
    {
        // fetch bitmap
        uint256 bitmap = IUniswapV3Pool(pool).tickBitmap(tickBitmapIndex);

        // calculate the number of populated ticks
        uint256 numberOfPopulatedTicks;
        for (uint256 i = 0; i < 256; i++) {
            if (bitmap & (1 << i) > 0) numberOfPopulatedTicks++;
        }

        // fetch populated tick data
        int24 tickSpacing = IUniswapV3Pool(pool).tickSpacing();
        populatedTicks = new PopulatedTick[](numberOfPopulatedTicks);
        for (uint256 i = 0; i < 256; i++) {
            if (bitmap & (1 << i) > 0) {
                int24 populatedTick = ((int24(tickBitmapIndex) << 8) +
                    int24(int256(i))) * tickSpacing;
                (
                    uint128 liquidityGross,
                    int128 liquidityNet,
                    ,
                    ,
                    ,
                    ,
                    ,

                ) = IUniswapV3Pool(pool).ticks(populatedTick);
                populatedTicks[--numberOfPopulatedTicks] = PopulatedTick({
                    tick: populatedTick,
                    liquidityNet: liquidityNet,
                    liquidityGross: liquidityGross
                });
            }
        }
        height = uint64(block.number);
    }

    function ticks(
        address pool,
        int24 tick
    ) public view returns (uint128, int128, uint256) {
        (
            uint128 liquidityGross,
            int128 liquidityNet,
            ,
            ,
            ,
            ,
            ,

        ) = IUniswapV3Pool(pool).ticks(tick);
        return (liquidityGross, liquidityNet, block.number);
    }

    function tickLiquidity(
        address pool
    ) public view returns (uint160, int24, uint128, uint256) {
        (uint160 sqrtPriceX96, int24 tick, , , , , ) = IUniswapV3Pool(pool)
            .slot0();
        uint128 liquidity = IUniswapV3Pool(pool).liquidity();
        return (sqrtPriceX96, tick, liquidity, block.number);
    }

    function getBinsReserves(
        address pool
    )
        public
        view
        returns (uint24[] memory ids, bytes32[] memory reserves, uint64 height)
    {
        ILBPair pair = ILBPair(pool);
        uint24 activeId = pair.getActiveId();
        ids = new uint24[](256);
        reserves = new bytes32[](256);
        uint24 id = activeId + 1;
        for (uint8 i = 0; i < 127; i++) {
            id = pair.getNextNonEmptyBin(true, id);
            if (id == type(uint24).max) break;
            ids[i] = id;
            (uint128 x, uint128 y) = pair.getBin(id);
            bytes32 z;
            assembly {
                z := or(and(x, MASK_128), shl(OFFSET, y))
            }
            reserves[i] = z;
        }
        id = activeId;
        for (uint8 i = 0; i < 127; i++) {
            id = pair.getNextNonEmptyBin(false, id);
            if (id == type(uint24).max) break;
            ids[i + 128] = id;
            (uint128 x, uint128 y) = pair.getBin(id);
            bytes32 z;
            assembly {
                z := or(and(x, MASK_128), shl(OFFSET, y))
            }
            reserves[i + 128] = z;
        }
        height = uint64(block.number);
    }

    struct LBPairParameters {
        uint16 baseFactor;
        uint16 filterPeriod;
        uint16 decayPeriod;
        uint16 reductionFactor;
        uint24 variableFeeControl;
        uint16 protocolShare;
        uint24 maxVolatilityAccumulator;
        uint24 volatilityAccumulator;
        uint24 volatilityReference;
        uint24 idReference;
        uint40 timeOfLastUpdate;
        uint24 activeId;
    }

    function getLBPairParameters(
        address pool
    ) public view returns (LBPairParameters memory p, uint64 height) {
        ILBPair pair = ILBPair(pool);
        (
            p.baseFactor,
            p.filterPeriod,
            p.decayPeriod,
            p.reductionFactor,
            p.variableFeeControl,
            p.protocolShare,
            p.maxVolatilityAccumulator
        ) = pair.getStaticFeeParameters();
        (
            p.volatilityAccumulator,
            p.volatilityReference,
            p.idReference,
            p.timeOfLastUpdate
        ) = pair.getVariableFeeParameters();
        p.activeId = pair.getActiveId();
        height = uint64(block.number);
    }
}
