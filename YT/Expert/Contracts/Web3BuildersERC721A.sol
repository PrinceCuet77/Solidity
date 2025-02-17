// SPDX-License-Identifier: MIT

// Compatible with OpenZeppelin Contracts ^5.0.0

pragma solidity ^0.8.22;

import {ERC721A} from "https://github.com/exo-digital-labs/ERC721R/blob/main/contracts/ERC721A.sol";
import "https://github.com/exo-digital-labs/ERC721R/blob/main/contracts/IERC721R.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Web3BuildersERC721A is ERC721A, Ownable {
  uint256 public constant mintPrice = 1 ether;
  uint256 public constant maxMintPerUser = 5;
  uint256 public constant maxMintSupply = 100;

  uint256 public constant refundPeriod = 3 minutes; // People can refund their NFT within 3 minutes
  uint256 public refundEndTimestamp;

  mapping(uint256 => uint256) public refundEndTimestamps;
  mapping(uint256 => bool) public hasRefunded;
  
  address public refundAddress;

  constructor() ERC721A("Web3Builders", "WE3") Ownable(msg.sender){
    refundAddress = address(this); // Refund in smart contract address
    refundEndTimestamp = block.timestamp + refundPeriod;
  }

  function _baseURI() internal pure override returns (string memory) {
    return "ipfs://QmbseRTJWSsLfhsiWwuB2R7EtN93TxfoaMz1S5FXtsFEUB/";
  }

  function safeMint(uint256 quantity) public payable {
    require(msg.value >= quantity * mintPrice, "Not Enough Funds!");
    require(_numberMinted(msg.sender) + quantity <= maxMintPerUser, "You Have Crossed The Mint Limit!");
    require(_totalMinted() + quantity <= maxMintSupply, "Sold Out!");

    _safeMint(msg.sender, quantity);

    refundEndTimestamp = block.timestamp + refundPeriod; // Calculate the refund time while minting

    // `_currentIndex` will be next non-minted NFT
    for (uint256 i = _currentIndex - quantity; i < _currentIndex; i++) {
        refundEndTimestamps[i] = refundEndTimestamp; // Track refund time for every single NFT
    }
  }

  function refund(uint256 tokenId) external {
    // You have to be the owner of the NFT
    require(block.timestamp < getRefundDeadline(tokenId), "Refund Period Expired!");
    require(msg.sender == ownerOf(tokenId), "Not Your NFT!");
    uint256 refundAmount = getRefundAmount(tokenId);

    // Transfer ownership of NFT
    _transfer(msg.sender, refundAddress, tokenId);

    // Mark refunded
    hasRefunded[tokenId] = true;

    // Refund the Price
    // Address.sendValue(payable(msg.sender), refundAmount);
    payable(msg.sender).transfer(refundAmount);
  }

  function getRefundDeadline(uint256 tokenId) public view returns (uint256) {
    if (hasRefunded[tokenId]) {
        return 0;
    }
    return refundEndTimestamps[tokenId];
  }

  function getRefundAmount(uint256 tokenId) public view returns (uint256) {
    if (hasRefunded[tokenId]) {
        return 0;
    }
    return mintPrice;
  }

  function withdraw() external onlyOwner {
    require(block.timestamp > refundEndTimestamp, "It's Not Past The Refund Period!");

    uint256 balance = address(this).balance;
    payable(msg.sender).transfer(balance);
  }
}