// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract ArcEscrow {
    using SafeERC20 for IERC20;

    address public usdcToken;
    address public buyer;
    address public seller;
    address public arbiter; // Owner or arbitrator who can resolve disputes
    uint256 public amount;
    bool public isApproved;
    bool public isFunded;

    constructor(address _usdcToken, address _seller, uint256 _amount) {
        usdcToken = _usdcToken;
        buyer = msg.sender;
        seller = _seller;
        arbiter = msg.sender; // The deployer is set as the arbitrator
        amount = _amount;
    }

    // Buyer deposits the contract amount into this escrow contract
    function depositEscrow() external {
        require(msg.sender == buyer, "Only buyer can deposit funds");
        require(!isFunded, "Escrow already funded");
        
        isFunded = true;
        IERC20(usdcToken).safeTransferFrom(buyer, address(this), amount);
    }

    // Buyer approves the work and releases the locked USDC to the seller
    function approvePayment() external {
        require(msg.sender == buyer || msg.sender == arbiter, "Not authorized to approve");
        require(isFunded, "Funds not deposited yet");
        require(!isApproved, "Payment already approved");
        
        isApproved = true;
        IERC20(usdcToken).safeTransfer(seller, amount);
    }

    // Arbitrator can refund the buyer if the seller fails to deliver
    function refundBuyer() external {
        require(msg.sender == arbiter, "Only arbiter can refund");
        require(isFunded, "Funds not deposited yet");
        require(!isApproved, "Payment already approved");
        
        isFunded = false;
        IERC20(usdcToken).safeTransfer(buyer, amount);
    }
}
