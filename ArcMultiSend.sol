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
    // Tracks how much reward each user has already claimed
    mapping(address => uint256) public rewardsClaimed; 
    
    // Global tracking rate scaled by 1e18 to prevent precision loss
    uint256 private totalRewardPerNFT;

    constructor(address _usdcToken) {
        usdcToken = _usdcToken;
    }

    function mintNFT() external {
        // Safe transfer of USDC from user to this contract
        IERC20(usdcToken).safeTransferFrom(msg.sender, address(this), mintPrice);
        
        nftBalances[msg.sender] += 1;
        totalMinted += 1;
        rewardPool += mintPrice;
        
        // Dynamic global tracking to prevent any mathematical truncation
        totalRewardPerNFT = (rewardPool * 10**18) / totalMinted;
    }

    function claimReward() external {
        uint256 totalNFTs = nftBalances[msg.sender];
        require(totalNFTs > 0, "Must own at least one NFT");
        
        // Calculate precise share using the 1e18 multiplier
        uint256 totalOwed = (totalRewardPerNFT * totalNFTs) / 10**18;
        uint256 share = totalOwed - rewardsClaimed[msg.sender];
        
        require(share > 0, "No rewards available or already claimed");

        // Update state before external interaction (Checks-Effects-Interactions pattern)
        rewardsClaimed[msg.sender] += share;
        rewardPool -= share;

        // Safe transfer of the reward tokens back to the user
        IERC20(usdcToken).safeTransfer(msg.sender, share);
    }
}
