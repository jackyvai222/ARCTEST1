// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract ArcRewardsNFT {
    using SafeERC20 for IERC20;

    address public usdcToken;
    uint256 public mintPrice = 5 * 10**6; // 5 USDC (6 decimals)
    uint256 public totalMinted;
    uint256 public rewardPool;

    mapping(address => uint256) public nftBalances;
    mapping(address => uint256) public rewardsClaimed; 
    
    uint256 private totalRewardPerNFT;

    constructor(address _usdcToken) {
        usdcToken = _usdcToken;
    }

    function mintNFT() external {
        IERC20(usdcToken).safeTransferFrom(msg.sender, address(this), mintPrice);
        
        nftBalances[msg.sender] += 1;
        totalMinted += 1;
        rewardPool += mintPrice;
        
        // Update global reward tracking without losing precision
        totalRewardPerNFT = rewardPool / totalMinted;
    }

    function claimReward() external {
        uint256 totalNFTs = nftBalances[msg.sender];
        require(totalNFTs > 0, "Must own at least one NFT");
        
        // Secure mathematical tracking
        uint256 totalOwed = totalRewardPerNFT * totalNFTs;
        uint256 share = totalOwed - rewardsClaimed[msg.sender];
        
        require(share > 0, "No rewards available or already claimed");

        // Update state before interaction (Prevents Reentrancy)
        rewardsClaimed[msg.sender] += share;
        rewardPool -= share;

        // safeTransfer for token transfer
        IERC20(usdcToken).safeTransfer(msg.sender, share);
    }
}
