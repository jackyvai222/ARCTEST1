// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function transfer(address to, uint256 value) external returns (bool);
}

contract ArcEscrow {
    address public usdcToken;
    address public buyer;
    address public seller;
    uint256 public amount;
    bool public isApproved;

    // Initialize the escrow agreement between buyer and seller
    constructor(address _usdcToken, address _seller, uint256 _amount) {
        usdcToken = _usdcToken;
        buyer = msg.sender;
        seller = _seller;
        amount = _amount;
    }

    // Buyer deposits the contract amount into this escrow contract
    function depositEscrow() external {
        require(msg.sender == buyer, "Only buyer can deposit funds");
        IERC20(usdcToken).transferFrom(buyer, address(this), amount);
    }

    // Buyer approves the work and releases the locked USDC to the seller
    function approvePayment() external {
        require(msg.sender == buyer, "Only buyer can approve payment");
        require(!isApproved, "Payment already approved");

        isApproved = true;
        IERC20(usdcToken).transfer(seller, amount);
    }
}
