# api https://agg.iotabee.com 

## GET /tokens Get all the supported tokens in this service.
### response result
```json
[
    {
        "contract": "0x038c4a46eB66f15Bc8739D9e23e3f46db95f102c",
        "symbol": "USDC",
        "decimal": 18
    },
    {
        "contract": "0x1b10CAdebbf96BC2AaA3AFfd78414AB50eCeF571",
        "symbol": "WSMR",
        "decimal": 18
    },
    {
        "contract": "0x39DEE4dFA8A94fB02F4004a38543c853F859d79E",
        "symbol": "SOONtest",
        "decimal": 8
    },
    {
        "contract": "0x5026a8F54A07578ebBdC9d589Df21b67D75094be",
        "symbol": "USDT",
        "decimal": 18
    },
    {
        "contract": "0x68018Bf6127aD04Ad9b6b0f8ACf18fD5651dE0C8",
        "symbol": "TT3",
        "decimal": 18
    },
    {
        "contract": "0x8CB067473a564F2e72cBcd21d2e2d01CfcB4D222",
        "symbol": "TT1",
        "decimal": 18
    },
    {
        "contract": "0xb6bB5544C6E43970BB6b0f7eb7b99c45343d206e",
        "symbol": "TT4",
        "decimal": 18
    },
    {
        "contract": "0xf0D82b7837fC074B8d349e3cEd773089fA77Fde3",
        "symbol": "TT2",
        "decimal": 18
    }
]
```

## GET /pools Get all the supported pools in this service.
### response result
```json
[
    {
        "contract": "0x5F4cE0e5a3638d6Fb9E467F1DE83229C73F48D09",
        "token0": "0x68018Bf6127aD04Ad9b6b0f8ACf18fD5651dE0C8",
        "token1": "0xb6bB5544C6E43970BB6b0f7eb7b99c45343d206e",
        "fee_rate": 10000,
        "space": 200,
        "version": 3,
        "platform": 1
    },
    {
        "contract": "0x7326c0F9d0B64E23eec22d39d571e71a69a011CE",
        "token0": "0x68018Bf6127aD04Ad9b6b0f8ACf18fD5651dE0C8",
        "token1": "0xf0D82b7837fC074B8d349e3cEd773089fA77Fde3",
        "fee_rate": 10000,
        "space": 200,
        "version": 3,
        "platform": 1
    },
    {
        "contract": "0x93e625FA4e6d8Af18B218B54Ea897F3b94413323",
        "token0": "0x1b10CAdebbf96BC2AaA3AFfd78414AB50eCeF571",
        "token1": "0xf0D82b7837fC074B8d349e3cEd773089fA77Fde3",
        "fee_rate": 10000,
        "space": 200,
        "version": 3,
        "platform": 1
    },
    {
        "contract": "0xA2a8D047287Af25977DFa056e3B8ddc24E2a5AFB",
        "token0": "0x39DEE4dFA8A94fB02F4004a38543c853F859d79E",
        "token1": "0xf0D82b7837fC074B8d349e3cEd773089fA77Fde3",
        "fee_rate": 10000,
        "space": 200,
        "version": 3,
        "platform": 1
    },
    {
        "contract": "0xB097471b46B6bE2cfFCC903B539a6a426C5Bc4bD",
        "token0": "0xb6bB5544C6E43970BB6b0f7eb7b99c45343d206e",
        "token1": "0xf0D82b7837fC074B8d349e3cEd773089fA77Fde3",
        "fee_rate": 10000,
        "space": 200,
        "version": 3,
        "platform": 1
    },
    {
        "contract": "0xdF9F078C30B90e251eC66b6B17722e8b563194cB",
        "token0": "0x1b10CAdebbf96BC2AaA3AFfd78414AB50eCeF571",
        "token1": "0x68018Bf6127aD04Ad9b6b0f8ACf18fD5651dE0C8",
        "fee_rate": 10000,
        "space": 200,
        "version": 3,
        "platform": 1
    },
    {
        "contract": "0xE0bE6538F6DCEa1Bd7825f9dBc406D54F100EbCc",
        "token0": "0x1b10CAdebbf96BC2AaA3AFfd78414AB50eCeF571",
        "token1": "0x39DEE4dFA8A94fB02F4004a38543c853F859d79E",
        "fee_rate": 10000,
        "space": 200,
        "version": 3,
        "platform": 1
    },
    {
        "contract": "0xE43b85EdAA1811971015995ECd9f6394E799aDD2",
        "token0": "0x1b10CAdebbf96BC2AaA3AFfd78414AB50eCeF571",
        "token1": "0xb6bB5544C6E43970BB6b0f7eb7b99c45343d206e",
        "fee_rate": 10000,
        "space": 200,
        "version": 3,
        "platform": 1
    }
]
```

## GET /paths?srcToken={0}&desToken={1}&amountIn={2}
### request params
| name      |  type  | description              |
| -------   | :----: | ----------------------   |
| srcToken  | string | source token's contract  |
| desToken  | string | destination token's contract |
| amountIn  | string | source token's amount  |
### response result
```json
{
    "level_tree": [
        [
            {
                "symbol": "TT3",
                "contract": "0x68018Bf6127aD04Ad9b6b0f8ACf18fD5651dE0C8",
                "amount": 1000000000,
                "percentage": {
                    "0x7326c0F9d0B64E23eec22d39d571e71a69a011CE": 10000
                }
            }
        ]
    ],
    "paths": [
        [
            {
                "pool": {
                    "contract": "0x7326c0F9d0B64E23eec22d39d571e71a69a011CE",
                    "token0": "0x68018Bf6127aD04Ad9b6b0f8ACf18fD5651dE0C8",
                    "token1": "0xf0D82b7837fC074B8d349e3cEd773089fA77Fde3",
                    "fee_rate": 10000,
                    "space": 200,
                    "version": 3,
                    "platform": 1
                },
                "direction": 1,
                "amount_in": 1000000000,
                "amount_out": 2501000
            }
        ]
    ]
}
```

## introduction
### platform
| platform | name       | 
| ---      | :--------: | 
| 0x10     | iotabee    |
| 0x11     | tangleswap |
| 0x01     | shimmersea |

## tokens 
["0x6C890075406C5DF08b427609E3A2eAD1851AD68D","0x1426116752d65111278c9e598E80E3B055D8D571","0x174d211F46994860500DB4d66B3EFE605A82BF95","0x1cDF3F46DbF8Cf099D218cF96A769cea82F75316","0x3bBb9B7848De06778fEE4fE0bC4d9AB271e56648","0x3C844FB5AD27A078d945dDDA8076A4084A76E513","0x5dA63f4456A56a0c5Cb0B2104a3610D5CA3d48E8","0x68acf9Da768a5f43c7D29999D44e9e39026DDDc4","0xa158A39d00C79019A01A6E86c56E96C461334Eb0","0xc0E49f8C615d3d4c245970F6Dc528E4A47d69a44","0xc5759E47b0590146675C560163036C302Fa05bC3","0xd2a67f5C808C7F525845975423F9979809188E44","0xd459140CFA38f3488F2076c3A4e9271Cf2f2E40C","0xE9308Bf2d95d11E324E0C62FF24bBD4bbc5dA546","0x1074010000000000000000000000000000000000","0x4794Aeafa5Efe2fC1F6f5eb745798aaF39A81D3e","0xa4f8C7C1018b9dD3be5835bF00f335D9910aF6Bd","0x326f23422CE22Ee5fBb5F37f9fa1092d095546F8","0x4638C9fb4eFFe36C49d8931BB713126063BF38f9","0xbD17705cA627EFBB55dE22A0F966Af79E9191c89","0xb0119035d08CB5f467F9ed8Eae4E5f9626Aa7402","0x264F2e6142CE8bEA68e5C646f8C07db98A9E003A","0x8E9b86C02F54d4D909e25134ce45bdf2B6597306","0xeCE555d37C37D55a6341b80cF35ef3BC57401d1A","0xE6373A7Bb9B5a3e71D1761a6Cb4992AD8537Bf28","0xE5f3dCC241Dd008E3c308e57cf4F7880eA9210F8","0x83b090759017EFC9cB4d9E45B813f5D5CbBFeb95"]

insert INTO `pool`(`contract`,`token0`,`token1`,`fee_rate`,`space`,`version`,`platform`) VALUES("0x1cC8e24022EBd1c9a08ff853792Ea8Bf13b9D867","0x5dA63f4456A56a0c5Cb0B2104a3610D5CA3d48E8","0x0",3000,25,21,1);
insert INTO `pool`(`contract`,`token0`,`token1`,`fee_rate`,`space`,`version`,`platform`) VALUES("0x1E96DeB50F41a9215212E7bC1b6b42282C006003","0x0","0xa4f8C7C1018b9dD3be5835bF00f335D9910aF6Bd",3000,20,21,1);
insert INTO `pool`(`contract`,`token0`,`token1`,`fee_rate`,`space`,`version`,`platform`) VALUES("0x6a23eEfdE1bDFA4F0D2eF3886D5927A8F6803dc3","0x4638C9fb4eFFe36C49d8931BB713126063BF38f9","0x0",3000,25,21,1);
insert INTO `pool`(`contract`,`token0`,`token1`,`fee_rate`,`space`,`version`,`platform`) VALUES("0xD2b48955A0FC68551275b0EC0699baC1e973D7CB","0xb0119035d08CB5f467F9ed8Eae4E5f9626Aa7402","0x0",3000,25,21,1);
insert INTO `pool`(`contract`,`token0`,`token1`,`fee_rate`,`space`,`version`,`platform`) VALUES("0x854E4412Bad441153031D0498781C82e3d2ff4F6","0xeCE555d37C37D55a6341b80cF35ef3BC57401d1A","0xa4f8C7C1018b9dD3be5835bF00f335D9910aF6Bd",3000,1,21,1);
insert INTO `pool`(`contract`,`token0`,`token1`,`fee_rate`,`space`,`version`,`platform`) VALUES("0x8B1778E3756a1ae7124433240e5678B0F6831C1d","0x5dA63f4456A56a0c5Cb0B2104a3610D5CA3d48E8","0xa4f8C7C1018b9dD3be5835bF00f335D9910aF6Bd",3000,25,21,1);
insert INTO `pool`(`contract`,`token0`,`token1`,`fee_rate`,`space`,`version`,`platform`) VALUES("0x398737AAeD4c16ea7Ba6533D24A96e2573292151","0xbD17705cA627EFBB55dE22A0F966Af79E9191c89","0xa4f8C7C1018b9dD3be5835bF00f335D9910aF6Bd",3000,50,21,1);
insert INTO `pool`(`contract`,`token0`,`token1`,`fee_rate`,`space`,`version`,`platform`) VALUES("0x653E3ec798b77409523BB5817a6C002f05746f12","0x4794Aeafa5Efe2fC1F6f5eb745798aaF39A81D3e","0xa4f8C7C1018b9dD3be5835bF00f335D9910aF6Bd",3000,50,21,1);
insert INTO `pool`(`contract`,`token0`,`token1`,`fee_rate`,`space`,`version`,`platform`) VALUES("0x4bA7CdBbA2b173DAE283CA2264D1f87628cB5b24","0xE6373A7Bb9B5a3e71D1761a6Cb4992AD8537Bf28","0x0",3000,25,21,1);
insert INTO `pool`(`contract`,`token0`,`token1`,`fee_rate`,`space`,`version`,`platform`) VALUES("0xe4d730B40a3E60eB0A32DD8DEab54A28Cc63a6cb","0xE6373A7Bb9B5a3e71D1761a6Cb4992AD8537Bf28","0x0",3000,100,21,1);

0x
0000000000000000000000000000000000000000000000000000000000000001
000000000000000000000000a4f8c7c1018b9dd3be5835bf00f335d9910af6bd
0000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000de6b3068c2ddd53cdabad7fe05a30403429b15e0
0000000000000000000000000000000000000000000000000000000000000dac", "0x
0000000000000000000000000000000000000000000000000000000000000011
0000000000000000000000005da63f4456a56a0c5cb0b2104a3610d5ca3d48e8
0000000000000000000000000000000000000000000000000000000000002710
000000000000000000000000508966d23a06b274afed6069d08efd0ea0827ac8
0000000000000000000000000000000000000000000000000000000000000dac", "0x
0000000000000000000000000000000000000000000000000000000000000010
0000000000000000000000003c844fb5ad27a078d945ddda8076a4084a76e513
0000000000000000000000000000000000000000000000000000000000002710
000000000000000000000000de6b3068c2ddd53cdabad7fe05a30403429b15e0
0000000000000000000000000000000000000000000000000000000000000bb8", "0x
0000000000000000000000000000000000000000000000000000000000000010
0000000000000000000000005da63f4456a56a0c5cb0b2104a3610d5ca3d48e8
0000000000000000000000000000000000000000000000000000000000002710
000000000000000000000000508966d23a06b274afed6069d08efd0ea0827ac8
0000000000000000000000000000000000000000000000000000000000002710", "0x
0000000000000000000000000000000000000000000000000000000000000001
0000000000000000000000005da63f4456a56a0c5cb0b2104a3610d5ca3d48e8
0000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000508966d23a06b274afed6069d08efd0ea0827ac8
0000000000000000000000000000000000000000000000000000000000002710
" ]

    function getBinsReserves(address pool) public view 
        returns(uint24[] memory ids, uint128[] memory reservesX, uint128[] memory reservesY, uint64 height) {
        ILBPair pair = ILBPair(pool);
        uint24 activeId = pair.getActiveId();
        ids = new uint24[](256);
        reservesX = new uint128[](256);
        reservesX = new uint128[](256);
        uint24 id = activeId + 1;
        for (uint16 i= 0; i < 128; i++) {
            id = pair.getNextNonEmptyBin(true, id);
            if (id == type(uint24).max ) break;
            ids[i] = id;
            (reservesX[i], reservesY[i]) = pair.getBin(id);
        }
        id = activeId;
        for (uint16 i= 0; i < 128; i++) {
            id = pair.getNextNonEmptyBin(false, id);
            if (id == 0 ) break;
            ids[i + 128] = id;
            (reservesX[i + 128], reservesY[i + 128]) = pair.getBin(id);
        }
        height = uint64(block.number);
    }