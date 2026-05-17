// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract ArcGigs {
    using SafeERC20 for IERC20;

    address public usdcToken;
    address public owner;
    
    // Setting job listing fee to 10 USDC (assuming USDC has 6 decimals)
    uint256 public jobListingFee = 10 * 10**6;

    struct Job {
        string title;
        string company;
        string description;
        address poster;
    }

    Job[] public jobs;

    // Set the token address and the contract owner
    constructor(address _usdcToken) {
        usdcToken = _usdcToken;
        owner = msg.sender;
    }

    // Function to post a job by paying a USDC fee to the owner
    function postJob(string memory _title, string memory _company, string memory _description) external {
        // Transfer the listing fee safely from the employer to the contract owner
        IERC20(usdcToken).safeTransferFrom(msg.sender, owner, jobListingFee);

        // Add the job details to the array
        jobs.push(Job(_title, _company, _description, msg.sender));
    }

    // Function to get the total number of jobs posted
    function getJobsCount() external view returns (uint256) {
        return jobs.length;
    }
}
