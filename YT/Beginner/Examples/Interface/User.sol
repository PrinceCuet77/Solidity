// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// 1️⃣ Create a new Player and save it to players mapping with the given data

contract User {
  struct Player {
    address playerAddress;
    string username;
    uint256 score;
  }

  mapping(address => Player) public players;

  function createUser(address userAddress, string memory username) external {
    require(players[userAddress].playerAddress == address(0), "User already exists");

    Player storage newPlayer = players[userAddress];
    newPlayer.playerAddress = userAddress;
    newPlayer.username = username;
    newPlayer.score = 0;

    // Alternate way
    // Player memory newPlayer = Player({
    //   playerAddress: userAddress,
    //   username: username,
    //   score: 0
    // });
  }
}

// Instruction (MUST):
// 1. First deploy `User` smart contract
// 2. Then deploy `Game` smart contract with the address of `User` smart contract

// What will be happened? (BE CAREFULL)
// 1. Flow is `Game` -> `User`
// 2. In `Game` contract, `msg.sender` means the sender address
// 3. In `User` contract, `msg.sender` means the `Game` contract address