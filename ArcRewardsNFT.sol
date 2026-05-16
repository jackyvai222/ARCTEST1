// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function transfer(address to, uint256 value) external returns (bool);
}

contract ArcRewardsNFT {
    address public usdcToken;
    
    // Setting NFT mint price to 5 USDC (assuming USDC has 6 decimals)
    uint256 public mintPrice = 5 * 10**6; 
    uint256 public totalMinted;
    uint256 public rewardPool;

    mapping(address => uint256) public nftBalances;
    mapping(address => bool) public rewardClaimed;

    // Initialize the contract with the USDC token address
    constructor(address _usdcToken) {
        usdcToken = _usdcToken;
    }

    // Function to mint an NFT by paying 5 USDC, which goes directly into the reward pool
    function mintNFT() external {
        // Transfer USDC from user to this contract
        IERC20(usdcToken).transferFrom(msg.sender, address(this), mintPrice);
        
        nftBalances[msg.sender] += 1;
        totalMinted += 1;
        rewardPool += mintPrice; // Add the fee to the global reward pool
    }

    // Function for NFT holders to claim their share of rewards from the pool
    function claimReward() external {
        require(nftBalances[msg.sender] > 0, "Must own at least one NFT");
        require(!rewardClaimed[msg.sender], "Reward already claimed");

        // Calculate the user's equal share of the reward pool
        uint256 share = rewardPool / totalMinted;
        rewardClaimed[msg.sender] = true;
        
        // Transfer the calculated reward share to the user
        IERC20(usdcToken).transfer(msg.sender, share);
    }
}
