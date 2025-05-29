- [Foundry](#foundry)
  - [Foundry \& VS Code Setup](#foundry--vs-code-setup)
  - [Demo Smart Contract](#demo-smart-contract)
  - [Compile \& Deploy Using `forge`](#compile--deploy-using-forge)
  - [18. Deploy A Smart Contract Locally Using `anvil`](#18-deploy-a-smart-contract-locally-using-anvil)
  - [19. What is a transaction](#19-what-is-a-transaction)
  - [20. Important: private key safety](#20-important-private-key-safety)
  - [Never Use A Env File](#never-use-a-env-file)

# Foundry

## Foundry & VS Code Setup

- Course Github Repo [Repo link](https://github.com/Cyfrin/foundry-full-course-cu)
- Discussion [link](https://github.com/Cyfrin/foundry-full-course-cu/discussions)
- Foundary Installation

```cmd
curl -L https://foundry.paradigm.xyz | bash
foundaryup
```

- Check the versions

```cmd
forge --version
cast --version
anvil --version
chisel --version
```

- Project initialization

```
mkdir SimpleStorage
cd SimpleStorage
forge init
```

- Installed VS Code extension
- `Solidity` - Nomic Foundation
- `Even Better TOML`
- `settings.json` settings

```
"[solidity]": {
	"editor.defaultFormatter": "NomicFoundation.hardhat-solidity"
}
```

## Demo Smart Contract

- Solidity smart contract code:

```js
// I'm a comment!
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

// pragma solidity ^0.8.0;
// pragma solidity >=0.8.0 <0.9.0;

contract SimpleStorage {
    uint256 myFavoriteNumber;

    struct Person {
        uint256 favoriteNumber;
        string name;
    }
    // uint256[] public anArray;
    Person[] public listOfPeople;

    mapping(string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public {
        myFavoriteNumber = _favoriteNumber;
    }

    function retrieve() public view returns (uint256) {
        return myFavoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        listOfPeople.push(Person(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}
```

## Compile & Deploy Using `forge`

- To enable the RPC url and some demo accounts & private key using `anvil`
- Open a new terminal:

```cmd
anvil
```

- Open another terminal & compile the code

```cmd
forge compile
```

- Deploy a smart contract locally using `forge`
- Run the following command:

```cmd
forge create SimpleStorage --interactive
```

- Then need to enter the private key
- Alternate way is

```cmd
forge create SimpleStorage --rpc-url http://127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

- It's not safe to use the private key in the terminal
- Remove the private key from the history

```cmd
history -c
```

## 18. Deploy A Smart Contract Locally Using `anvil`

- I can write script using solidity
- File naming convension of script extension `.s.sol`
- Mainly, writing a smart contract to deploy a smart contract
- To notify foundry it's a script file, write the following lines

```js
import { Script } from 'forge-std/Script.sol'; // Import the script contract
import { SimpleStorage } from '../src/SimpleStorage.sol'; // Import the would be deployed smart contract
```

- Everything inside `startBroadcast()` and `stopBroadcast()` is going to send for deployment
- `script/DeploySimpleStorage.s.sol`

```js
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

contract DeploySimpleStorage is Script {
    function run() external returns (SimpleStorage) {
        vm.startBroadcast();
        SimpleStorage simpleStorage = new SimpleStorage();
        vm.stopBroadcast();

        return simpleStorage;
    }
}
```

- Deploy the smart contract using script

```cmd
forge script script/DeploySimpleStorage.s.sol
```

- `forge` automatically deploy smart contract or run the script on a temporary `anvil` chain

- And we need to deploy the smart contract and broadcast

```cmd
forge script script/DeploySimpleStorage.s.sol --rpc-url http://127.0.0.1:8545 --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

## 19. What is a transaction

- Have the hex value of the gas in `broadcast/DeploySimpleStorage.s.sol/31337/run-1748326436.json`

```json
"transaction": {
  "from": "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266",
  "gas": "0xac458",
  "value": "0x0",
}
```

- Convert the hex value into decimal value

```cmd
cast --to-base 0xac458 dec
```

- `r`, `s`, `v` is the private key to signature the transaction
- Need the private key to actually sign the transaction & send it
- After a new deploy, nonce value will be increased

## 20. Important: private key safety

- `.env` & put it in the `.gitignore` file

```js
PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
RPC_URL=http://127.0.0.1:8545
```

- In the bash terminal, run the following command to add the variables of the environment variables in the terminal

```cmd
source .env
```

- To see that variables are loaded in the terminal

```cmd
echo $PRIVATE_KEY
```

- Again deploy the smart contract using `forge` with `.env` variables

```cmd
forge create SimpleStorage --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

- For more safety purpose, use `Ethsign` - Sign Ethereum transactions using a JSON keystore or hardware wallet.

## Never Use A Env File

- Encrypt the private key into a JSON format using ERC-2335:BLS12-381 Keystore

```cmd
cast wallet import defaultKey --interactive
```

- Enter private key
- Enter new password
- To view the `defaultKey`

- Output will be like
- Shows the address of the private key

```txt
`defaultKey` keystore was saved successfully. Address: 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266
```

```cmd
cast wallet list
```

```cmd
cd Foundry/SimpleStorage
forge script script/DeploySimpleStorage.s.sol:DeploySimpleStorage --rpc-url http://localhost:8545 --account defaultKey --sender 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266 --broadcast -vvvv
```

- Give the same password
- Another way is to provide the password file
- Make a password file in the root folder named `.password`
- Add a `--password-file` in the command
- I can find the keystores in the home directory & view the `defaultKey`

```cmd
cd
cd .foundry/keystores
ls
cat defaultKey # Read the `defaultKey`
```

- Remove the history

```cmd
history -c
rm .bash_history
```

- A
