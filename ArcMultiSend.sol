// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract ArcMultiSend {
    // Function to send USDC to multiple addresses in a single transaction
    function tokenMultiSend(
        address tokenAddress, 
        address[] calldata recipients, 
        uint256[] calldata amounts
    ) external {
        require(recipients.length == amounts.length, "Arrays length must match");
        require(recipients.length > 0, "Recipients list cannot be empty");

        IERC20 token = IERC20(tokenAddress);

        for (uint256 i = 0; i < recipients.length; i++) {
            require(recipients[i] != address(0), "Invalid recipient address");
            bool success = token.transferFrom(msg.sender, recipients[i], amounts[i]);
            require(success, "Token transfer failed");
        }
    }
}
