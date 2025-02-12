- [Learning Solidity from YT as An Expert](#learning-solidity-from-yt-as-an-expert)
  - [Build ERC-721 Contract](#build-erc-721-contract)

# Learning Solidity from YT as An Expert

## Build ERC-721 Contract

- Todo list:
  - Add public mint function
  - Add payment requirement
  - Add supply limit
  - Add allowlist mint
  - Clean up code
  - Add withdraw functionq
- First visit [OpenZeppelin Smart Contract Wizard](https://wizard.openzeppelin.com/)
- It's an interactive smart contract generator based on OpenZeppelin Contracts.
- Select `ERC721` tab
- Enable some features like:
  - `Mintable` - Privileged account will be able to emit new tokens
  - `Auto Increment Ids` - New tokens will be automatically an incremental id
  - `Burnable` - Token holders will be able to destroy their tokens
  - `Pausable` - Allow to pause the contract/mint
  - `Enumerable` - Allows to keep track of how many ntfs have minted so far
  - `URI Storage` - Allows updating token URIs for individual token IDs.
- I can see the smart contract in `Web3Builders.sol` file
- After deployment, I can view the smart contract in the test **OpenSea** website. [see more](https://testnets.opensea.io/)
- Need to login using **Metamask**
- Copy the contract address from Etherscan
- ![Etherscan For ERC721](photo/ERC721-contract-address.png)
- Search Test OpenSea using that contract address
- Start 46:00 minutes