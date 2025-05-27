- [Smart Wallet](#smart-wallet)
  - [Solidity Mapping](#solidity-mapping)
  - [Struct](#struct)
  - [Struct With Mapping](#struct-with-mapping)
  - [`require`](#require)
  - [`assert`](#assert)
  - [Try/Catch](#trycatch)
  - [Low-Level Solidity Calls In-Depth](#low-level-solidity-calls-in-depth)
  - [Section Summary](#section-summary)
    - [Array](#array)
    - [Enum](#enum)
    - [Transactions \& Errors](#transactions--errors)

# Smart Wallet

## Solidity Mapping

- Mapping doesn't have any length

```js
//SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

contract MappingsStructExample {
  mapping(address => uint) public balanceReceived; // mapping

  function getBalance() public view returns(uint) {
    return address(this).balance; // Check balance of smart contract balance
  }

  function sendMoney() public payable {
    balanceReceived[msg.sender] += msg.value;
  }

  // From: function executor
  // To: address takes from the parameter
  // Send money only function executor already fund money
  function withdrawMoney(address payable _to, uint _amount) public {
    require(_amount <= balanceReceived[msg.sender], "Not enough funds!");
    balanceReceived[msg.sender] -= _amount;
    _to.transfer(_amount);
  }

  // Withdraw all the money I already fund
  function withdrawAllMoney(address payable _to) public {
    uint balanceToSend = balanceReceived[msg.sender];
    balanceReceived[msg.sender] = 0;
    _to.transfer(balanceToSend);
  }
}
```

- I don't follow the following lines

```js
function withdrawAllMoney(address payable _to) public {
  _to.transfer(balanceReceived[msg.sender]);
  balanceReceived[msg.sender] = 0;
}
```

- I have to reduce the value before transaction
- As while processing the transaction, user may execute `withdrawAllMoney` function again
- To prevent reentrance attack

## Struct

```js
//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract Wallet2 {
  // Define a struct
  struct PaymentReceivedStruct {
    address from;
    uint amount;
  }

  // Create a struct variable
  PaymentReceivedStruct public payment;

  function payContract() public payable {
    payment = PaymentReceivedStruct(msg.sender, msg.value);

    // Alternate way
    // payment.from = msg.sender;
    // payment.amount = msg.amount;
  }
}
```

## Struct With Mapping

```js
//SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

contract MappingsStructExample {
  struct Transaction {
    uint amount;
    uint timestamp;
  }

  struct Balance {
    uint totalBalance;
    uint numDeposits;
    mapping(uint => Transaction) deposits;
    uint numWithdrawals;
    mapping(uint => Transaction) withdrawals;
  }

  mapping(address => Balance) public balanceReceived;

  function getBalance(address _addr) public view returns(uint) {
    return balanceReceived[_addr].totalBalance;
  }

  function depositMoney() public payable {
    balanceReceived[msg.sender].totalBalance += msg.value;

    Transaction memory deposit = Transaction(msg.value, block.timestamp);
    balanceReceived[msg.sender].deposits[balanceReceived[msg.sender].numDeposits] = deposit;
    balanceReceived[msg.sender].numDeposits++;
  }

  function withdrawMoney(address payable _to, uint _amount) public {
    balanceReceived[msg.sender].totalBalance -= _amount; //reduce the balance by the amount ot withdraw

    //record a new withdrawal
    Transaction memory withdrawal = Transaction(msg.value, block.timestamp);
    balanceReceived[msg.sender].withdrawals[balanceReceived[msg.sender].numWithdrawals] = withdrawals;
    balanceReceived[msg.sender].numWithdrawals++;

    //send the amount out.
    _to.transfer(_amount);
  }
}
```

## `require`

- Because of `require`, if a transaction fails, then revert the every state before executing that transaction
- And gas spends till `require` execution & revert rest of the gas to the executor account

## `assert`

- Compare something
- If it evaluates to `false`, it will stop the execution of the smart contract
- And it will roll back everything
- It takes all the gas I entered
- To check states of the smart contract that should never be violated
- For example, a balance can only get bigger

```js
//SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

contract ExceptionExample {
  mapping(address => uint8) public balanceReceived;

  function receiveMoney() public payable {
    assert(msg.value == uint8(msg.value));
    balanceReceived[msg.sender] += uint8(msg.value);
    assert(balanceReceived[msg.sender] >= uint8(msg.value));
  }

  function withdrawMoney(address payable _to, uint8 _amount) public {
    require(_amount <= balanceReceived[msg.sender], "Not Enough Funds, aborting");
    assert(balanceReceived[msg.sender] >= balanceReceived[msg.sender] - _amount);
    balanceReceived[msg.sender] -= _amount;
    _to.transfer(_amount);
  }
}
```

## Try/Catch

- `require` will revert with an `error` exception
- So, I can catch the error with error message
- `assert` will fire an `panic` exception

```js
//SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

contract WillThrow {
  function aFunction() public pure {
    require(false, "Error message");
  }
}

contract ErrorHandling {
  event ErrorLogging(string reason);
  function catchError() public {
    WillThrow will = new WillThrow();
    try will.aFunction() {
      //here we could do something if it works
    }  catch Error(string memory reason) {
      emit ErrorLogging(reason);
    }
  }
}
```

## Low-Level Solidity Calls In-Depth

- A

## Section Summary

### Array

- Fixed or dynamic size
- `T[k]` - fixed `k` sized of type `T`
- `T[]` - dynamic size of type `T`
- `T[][5]` - 5 dynamic sized array
- Have two members
  - `length`
  - `push(x)`
- _Be Careful:_
  - Huge gas costs
  - Better to use mappings

### Enum

- Enums are a user-defined type in Solidity
- Will be integers internally
- It fits in `uint8` -> 0~255 in the ABI
- More than 256 values -> `uint16`

```js
enum ActionChoices { GoLeft, GoRight, GoStraight, SitStill }

ActionChoices choice; // Declare
ActionChoices constant defaultChoice = ActionChoices.GoLeft; // Declare & initialize
```

### Transactions & Errors

- Transactions are atomic
- Errors are 'State Reverting'
- No matter where the error happends, the whole transaction is going to be rolled back
