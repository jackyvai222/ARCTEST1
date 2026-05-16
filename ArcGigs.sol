// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract ArcGigs {
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
        // Transfer the listing fee from the employer to the contract owner
        IERC20(usdcToken).transferFrom(msg.sender, owner, jobListingFee);
        
        // Add the job details to the array
        jobs.push(Job(_title, _company, _description, msg.sender));
    }

    // Function to get the total number of jobs posted
    function getJobsCount() external view returns (uint256) {
        return jobs.length;
    }
}
