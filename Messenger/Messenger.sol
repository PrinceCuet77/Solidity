// Functionality:
// 1. Only owner can set the message
// 2. Other can't change the message but can view the message
// 3. Count how many times the message is updated

// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.26;

contract Messenger {
  address public owner;
  string public message;
  uint8 public counter;

  constructor() {
    owner = msg.sender;
  }

  function getMessage() public view returns(string memory) {
    return message;
  }

  function setMessage(string memory _message) public {
    if (owner == msg.sender) {
      counter++;
      message = _message;
    }
  } 
}