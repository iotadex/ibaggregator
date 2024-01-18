# api https://aggregator.iotabee.com 

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


["0x6C890075406C5DF08b427609E3A2eAD1851AD68D","0x1426116752d65111278c9e598E80E3B055D8D571","0x174d211F46994860500DB4d66B3EFE605A82BF95","0x1cDF3F46DbF8Cf099D218cF96A769cea82F75316","0x3bBb9B7848De06778fEE4fE0bC4d9AB271e56648","0x3C844FB5AD27A078d945dDDA8076A4084A76E513","0x5dA63f4456A56a0c5Cb0B2104a3610D5CA3d48E8","0x68acf9Da768a5f43c7D29999D44e9e39026DDDc4","0xa158A39d00C79019A01A6E86c56E96C461334Eb0","0xc0E49f8C615d3d4c245970F6Dc528E4A47d69a44","0xc5759E47b0590146675C560163036C302Fa05bC3","0xd2a67f5C808C7F525845975423F9979809188E44","0xd459140CFA38f3488F2076c3A4e9271Cf2f2E40C","0xE9308Bf2d95d11E324E0C62FF24bBD4bbc5dA546","0x1074010000000000000000000000000000000000"]