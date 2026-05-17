// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract ArcMultiSend {
    using SafeERC20 for IERC20;

    /**
     * @notice Sends a specific ERC20 token to multiple recipients in a single transaction.
     * @param _token The address of the ERC20 token to be sent.
     * @param _recipients An array of receiver addresses.
     * @param _amounts An array of token amounts corresponding to each receiver.
     */
    function multiSendToken(
        address _token, 
        address[] calldata _recipients, 
        uint256[] calldata _amounts
    ) external {
        uint256 length = _recipients.length;
        require(length == _amounts.length, "Recipients and amounts length mismatch");
        require(length > 0, "Recipients list cannot be empty");

        uint256 totalAmount = 0;
        
        // Calculate the total amount needed for all transfers
        for (uint256 i = 0; i < length; i++) {
            totalAmount += _amounts[i];
        }

        // Pull all tokens from the sender to this contract in ONE single transfer (Saves a lot of Gas)
        IERC20(_token).safeTransferFrom(msg.sender, address(this), totalAmount);

        // Distribute the tokens to all recipients safely
        for (uint256 i = 0; i < length; i++) {
            IERC20(_token).safeTransfer(_recipients[i], _amounts[i]);
        }
    }
}
