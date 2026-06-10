# ARC Smart Contracts Suite

Welcome to the **ARC Smart Contracts** repository. This project contains a collection of robust, secure, and gas-optimized smart contracts deployed on the **Arc Network Testnet**. All token interactions within these contracts are built around **USDC** (6 decimals) and utilize OpenZeppelin's standard libraries for maximum security.

---

## 🚀 Deployed Contracts Overview

Here is the list of currently deployed contracts on the Arc Network Testnet:

### 1. ArcVault
* **Contract Address:** 0xF081F95ada182e854531c2Aebc79B15Cd11c430c
* **Purpose:** A secure time-lock vault where users can lock their USDC tokens for a specific duration.
* **Security Feature:** Implements the Checks-Effects-Interactions pattern and `SafeERC20` to prevent reentrancy and silent transfer failures.

### 2. ArcRewardsNFT
* **Contract Address:** 0xB9DDDE8FD8D202F4544A7697aEF1d126ca3624e4
* **Purpose:** A precise reward distribution system driven by NFT minting. Users pay 5 USDC to mint an NFT, and the accumulated funds form a dynamic reward pool.
* **Key Feature:** Uses a high-precision global tracking multiplier ($10^{18}$) to prevent any truncation or mathematical precision loss during reward claims.

### 3. ArcMultiSend
* **Contract Address:** 0xED854782774fDd51e2dBc90441fABB3D8a6ab493
* **Purpose:** A highly gas-optimized batch transfer utility.
* **Optimization:** Instead of calling `transferFrom` inside a loop (which wastes a lot of gas), it calculates the total amount, pulls the tokens from the user's wallet in **one single transfer**, and then safely distributes them to multiple recipients.

### 4. ArcGigs
* **Contract Address:** 0xC1FDD3fe5D7A3790ba3Dc01BDB75Fd7Bd3Db6A03
* **Purpose:** A decentralized job board contract where employers can post jobs by paying a fixed listing fee of 10 USDC directly to the contract owner.
* **Security Feature:** Fully secured with OpenZeppelin's `SafeERC20` to handle standard and non-standard ERC20 behaviors safely.

### 5. ArcEscrow
* **Contract Address:** 0x13799350963f8925cd78Ddf4f3302C090D87D51d
* **Purpose:** A secure trust-less escrow system for peer-to-peer deals with an integrated neutral Arbiter (or contract owner) to resolve disputes.
* **Workflow:** 1. Buyer deposits the contract amount into the escrow using `depositEscrow()`.
  2. Once work is delivered, the buyer or arbiter calls `approvePayment()` to release funds to the seller.
  3. If a dispute arises, the arbiter can trigger `refundBuyer()` to safely return funds to the buyer.

---

## 🛠️ Testing & Deployment Guide (Remix IDE)

To interact with these contracts in Remix, always follow this operational flow:

1. **Prerequisite (USDC Approval):** Since these contracts pull USDC from your wallet using `safeTransferFrom`, you must first go to the core USDC Token Contract (`0x3910B7cbb3341f1F4bF4cEB66e4A2C8f204FE2b8`) and call the **`approve`** function. 
   * **Spender:** Input the address of the specific deployed ARC contract.
   * **Amount:** Input the required USDC amount scaled to 6 decimals (e.g., `10000000` for 10 USDC).

2. **Environment:** Set your Remix Environment to **Injected Provider - MetaMask** and connect to the **Arc Network Testnet (Chain ID: 5042002)**.

3. **Execution:** Once approved, you can freely trigger functions like `mintNFT()`, `postJob()`, or `depositEscrow()` without any transaction reverts.

---

## 🔒 Security Standards Applied

* **SafeERC20:** Protects against tokens that do not return a boolean value on transfers.
* **Reentrancy Mitigation:** Strict adherence to updating internal states before executing external token transfers.
* **Integer Overflow/Truncation Prevention:** All reward allocation logic scales mathematical values safely before division.

## 📄 License

This project is licensed under the MIT License.
