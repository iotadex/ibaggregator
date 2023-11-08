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
| platform | name    | 
| ---      | :----:  | 
| 1f       | iotabee |

["0x1b10CAdebbf96BC2AaA3AFfd78414AB50eCeF571","0xf0D82b7837fC074B8d349e3cEd773089fA77Fde3"]
[2,1]
["0x000000000000000000000000000000000000000000000000000000000000001f000000000000000000000000f0D82b7837fC074B8d349e3cEd773089fA77Fde300000000000000000000000000000000000000000000000000000000000027100000000000000000000000007ce74c6Ab0a15dCBf7CCCC27BAA8De7449a48b02000000000000000000000000000000000000000000000000000000000000000a","0x000000000000000000000000000000000000000000000000000000000000001f00000000000000000000000039DEE4dFA8A94fB02F4004a38543c853F859d79E00000000000000000000000000000000000000000000000000000000000027100000000000000000000000005717B3DadA9AA2E6bC2f402f74391ad5A95A2D860000000000000000000000000000000000000000000000000000000000002706","0x000000000000000000000000000000000000000000000000000000000000001f00000000000000000000000039DEE4dFA8A94fB02F4004a38543c853F859d79E00000000000000000000000000000000000000000000000000000000000027100000000000000000000000005717B3DadA9AA2E6bC2f402f74391ad5A95A2D860000000000000000000000000000000000000000000000000000000000002710"]

["0x39DEE4dFA8A94fB02F4004a38543c853F859d79E","0xf0D82b7837fC074B8d349e3cEd773089fA77Fde3"]
[1,1]
["0x000000000000000000000000000000000000000000000000000000000000001f000000000000000000000000f0D82b7837fC074B8d349e3cEd773089fA77Fde300000000000000000000000000000000000000000000000000000000000027100000000000000000000000007ce74c6Ab0a15dCBf7CCCC27BAA8De7449a48b020000000000000000000000000000000000000000000000000000000000002710","0x000000000000000000000000000000000000000000000000000000000000001f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002710000000000000000000000000115F2963D64b56019Deac562058B95C6ba2d15dc0000000000000000000000000000000000000000000000000000000000002710"]
tokenIns:
0x39DEE4dFA8A94fB02F4004a38543c853F859d79E
0xf0D82b7837fC074B8d349e3cEd773089fA77Fde3
0x115F2963D64b56019Deac562058B95C6ba2d15dc
counts:
1
1

inputs:
0x
000000000000000000000000000000000000000000000000000000000000001f
000000000000000000000000f0D82b7837fC074B8d349e3cEd773089fA77Fde3
0000000000000000000000000000000000000000000000000000000000002710
0000000000000000000000007ce74c6Ab0a15dCBf7CCCC27BAA8De7449a48b02
0000000000000000000000000000000000000000000000000000000000002710

0x
000000000000000000000000000000000000000000000000000000000000001f
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000002710
0000000000000000000000009FCe0d4B53089a0772a3628A3e782461af1524f4 // my addr
0000000000000000000000000000000000000000000000000000000000002710