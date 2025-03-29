//SPDX-License-Identifier: MIT

pragma solidity 0.8.16;

contract SendWithdrawMoney {
  // Stored all the sent ether from different account
  uint public balanceReceived;

  // Deposit ether
  function depositAllEth() public payable {
    balanceReceived += msg.value;
  }

  // Get the balance of the smart contract itself
  function getContractBalance() public view returns(uint) {
    return address(this).balance; // Get the balance of the contract
  }

  // Withdraw all balances & send to the executor account
  function withdrawAll() public {
    address payable to = payable(msg.sender);
    to.transfer(getContractBalance());
  }

  // Withdraw all balances of mentioned account
  function withdrawToAddress(address payable to) public {
    to.transfer(getContractBalance());
  }
}