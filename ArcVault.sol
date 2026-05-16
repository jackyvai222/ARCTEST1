// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function transfer(address to, uint256 value) external returns (bool);
}

contract ArcVault {
    address public usdcToken;
    
    struct LockBox {
        uint256 amount;
        uint256 unlockTime;
    }
    
    mapping(address => LockBox) public balances;

    // Initialize the contract with the USDC token address
    constructor(address _usdcToken) {
        usdcToken = _usdcToken;
    }

    // Function to lock USDC for a specific duration (in seconds)
    function deposit(uint256 _amount, uint256 _lockDurationInSeconds) external {
        require(_amount > 0, "Amount must be greater than 0");
        require(balances[msg.sender].amount == 0, "Already have an active lockbox");

        // Transfer USDC from user to this contract
        IERC20(usdcToken).transferFrom(msg.sender, address(this), _amount);

        // Record the locked amount and the release time
        balances[msg.sender] = LockBox({
            amount: _amount,
            unlockTime: block.timestamp + _lockDurationInSeconds
        });
    }

    // Function to withdraw USDC after the lock time has passed
    function withdraw() external {
        LockBox memory box = balances[msg.sender];
        require(box.amount > 0, "No funds locked");
        require(block.timestamp >= box.unlockTime, "Funds are still locked");

        // Clear the user's balance before transferring to prevent reentrancy attacks
        delete balances[msg.sender];
        
        // Transfer the USDC back to the user
        IERC20(usdcToken).transfer(msg.sender, box.amount);
    }
}
