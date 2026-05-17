// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract ArcRewardsNFT {
    using SafeERC20 for IERC20;

    address public usdcToken;
    uint256 public mintPrice = 5 * 10**6; // 5 USDC (assuming 6 decimals)
    uint256 public totalMinted;
    uint256 public rewardPool;

    mapping(address => uint256) public nftBalances;
    mapping(address => uint256) public rewardMintIndex;

    constructor(address _usdcToken) {
        usdcToken = _usdcToken;
    }

    function mintNFT() external {
        // Transfer USDC from user to this contract safely
        IERC20(usdcToken).safeTransferFrom(msg.sender, address(this), mintPrice);
        
        nftBalances[msg.sender] += 1;
        totalMinted += 1;
        rewardPool += mintPrice;
    }

    function claimReward() external {
        uint256 totalNFTs = nftBalances[msg.sender];
        require(totalNFTs > 0, "Must own at least one NFT");
        
        // Calculate the claimable share dynamically based on the current pool
        uint256 share = (rewardPool / totalMinted) * totalNFTs;
        require(share > 0, "No rewards available or already claimed");

        // Update the reward pool state before interaction
        rewardPool -= share;
        
        // Reset or adjust user's balance token tracking securely
        nftBalances[msg.sender] = 0; 

        // Transfer the reward share to the user safely
        IERC20(usdcToken).safeTransfer(msg.sender, share);
    }
}
