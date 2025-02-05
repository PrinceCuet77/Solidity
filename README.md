- [Solidity](#solidity)
  - [Blockchain Basics](#blockchain-basics)
  - [Programming](#programming)
    - [Boolean](#boolean)
    - [Signed/Unsigned Integer](#signedunsigned-integer)

# Solidity

## Blockchain Basics

- Smart contract is a piece of code that running in the blockchain
- Blockchain is a state machine that needs a transaction to change its state
- The state changes through mining & transactions
- Solidity is complied in the EVM bytecode
- In the Ethereum network, every Ethereum node executes the same code as every node has a copy of the chain
- What will happen?
  1. I write solidity smart contract
  2. Code complied by EVM bytecode
  3. Then I send the transaction with that bytecode to the blockchain network
  4. The network will send that code to the every node
  5. Every node in the network will execute the same code as every node has a copy of the whole chain
- `SPDX-License-Identifier: MIT` identifies the license of that file or source code
- `pragma solidity 0.8.14` is a pre-compiler line that tells the pre-compiler to select the rights solidity compiler
- But `pragma solidity ^0.8.14` means `0.8.14` or larger but not more than `0.9`
- Convention: Contract name should be CapWords style
- Every time I click deploy, it will deploy a new instance

## Programming

### Boolean

```js
//SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract ExampleBoolean {
  // Solidity creates a getter method automatically
  bool public myBool; // Define a boolean

  // setter method
  function setMyBool(bool _myBool) public {
    myBool = _myBool;
  }
}
```

### Signed/Unsigned Integer

```js

```
