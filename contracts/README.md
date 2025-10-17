# 🛡️ KipuBank - Secure Ether Vault

## 📜 Overview

KipuBank is a smart contract on the Ethereum blockchain that functions as a secure, decentralized bank vault for Ether (ETH). It allows users to deposit and withdraw funds into their personal balance while enforcing strict security rules and limits.

The contract is designed with a strong focus on security, gas optimization, and clarity, adhering to the latest best practices in Solidity development. Key features include a global deposit cap to limit total exposure and a per-transaction withdrawal limit to mitigate potential losses.

-----

## ✨ Features

  - 🔐 **Secure Deposits**: Users can deposit ETH into a personal, isolated balance within the contract.
  - 💸 **Capped Withdrawals**: Withdrawals are limited by a fixed, immutable amount per transaction, set at deployment.
  - 🏦 **Global Vault Limit**: The contract enforces a total `BANK_CAP`, preventing deposits once the vault's total balance reaches this limit.
  - 🚨 **Custom Errors**: All validations revert with clear, custom errors for a better user and developer experience.
  - 📢 **Event Emission**: The contract emits `Deposit` and `Withdrawal` events for successful transactions, allowing for easy off-chain tracking.
  - 🛡️ **Security First**: Implements the `Checks-Effects-Interactions` pattern to prevent re-entrancy attacks.
  - ⛽ **Gas Optimization**: Uses `unchecked` blocks for safe arithmetic operations and minimizes state variable access to reduce transaction costs.
  - 📖 **Fully Documented**: Comprehensive NatSpec comments for all functions, variables, and events, ensuring full transparency on platforms like Etherscan.

-----

## 🚀 Getting Started

### Prerequisites

  - A web browser with an Ethereum wallet extension like `MetaMask`.
  - Some test ETH on a network like `Sepolia`.

### Deployment Instructions

The easiest way to deploy this contract is using the **Remix IDE**.

1.  **Open Remix IDE**: Navigate to [remix.ethereum.org](https://remix.ethereum.org).
2.  **Create File**: Create a new file named `KipuBank.sol` and paste the contract code into it.
3.  **Compile the Contract**:
      - Go to the **"Solidity Compiler"** tab (third icon on the left).
      - Select a compiler version compatible with `^0.8.20` (e.g., `0.8.24`).
      - Click the **"Compile KipuBank.sol"** button. A green checkmark will appear if successful.
4.  **Deploy the Contract**:
      - Go to the **"Deploy & Run Transactions"** tab (fourth icon on the left).
      - Under "Environment", select **"Injected Provider - MetaMask"** and connect your wallet. Make sure you are on the correct test network (e.g., `Sepolia`).
      - In the "Contract" dropdown, `KipuBank` should be selected.
      - Next to the "Deploy" button, you need to provide the constructor arguments:
        ```
        _withdrawalLimit: 100000000000000000  (This is 0.1 ETH in wei)
        _bankCap:       10000000000000000000 (This is 10 ETH in wei)
        ```
      - Click the **"transact"** button and confirm the transaction in MetaMask.

> 🎉 **Congratulations\!** Your KipuBank contract is now deployed. You can find its address under the "Deployed Contracts" section in Remix.

-----

## Interacting with the Contract

Once deployed, you can interact with the contract's functions directly from the Remix interface.

### Depositing Ether (`addFunds`)

The `addFunds` function is `payable`, which means you send ETH along with the transaction.

1.  In Remix, under "Deployed Contracts", find your `KipuBank` instance.
2.  In the **VALUE** input field (on the left panel), enter the amount of ETH you wish to deposit and select "Ether" from the dropdown.
3.  Click the orange **`addFunds`** button and confirm the transaction in MetaMask.

### Withdrawing Ether (`withdraw`)

1.  Find the `withdraw` function in your deployed contract.
2.  Enter the amount you wish to withdraw (in wei) into the `amount` input field.
3.  Click the **`withdraw`** button and confirm the transaction. The funds will be sent to your wallet.

### Viewing Information (Read Functions)

The blue buttons represent `view` functions, which are free to call as they only read data from the blockchain.

  - `getBalance(address user)`: Check the balance of any user's address.
  - `checkMyFunds()`: A convenience function to check your own balance.
  - `getBankBalance()`: View the total ETH currently held by the contract.
  - `getAvailableCapacity()`: See how much more ETH can be deposited before the `BANK_CAP` is reached.
  - `MAX_WITHDRAW_AMOUNT` / `BANK_CAP`: Check the immutable limits set at deployment.
  - `depositCount` / `totalTransactionsOut`: View the total number of deposit and withdrawal transactions.

-----

## 👨‍💻 Author

**Juan Pablo** — Web3 Developer (Student, ETH-KIPU Module 2)

  * **Repository**: [https://github.com/Roiger19/kipu-bank](https://github.com/Roiger19/kipu-bank)


