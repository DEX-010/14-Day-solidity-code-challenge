// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {FundTheCourse} from "./Main.sol";

contract ExtendWallet {
    FundTheCourse public courseInstance;

    constructor(address _courseInstance) {
        courseInstance = FundTheCourse(_courseInstance);
    }

    // Used to receive plain Ether transfers (e.g., address(this).send(value))
    receive() external payable {
        // You can trigger default behavior like logging or forwarding
        // For now, we'll simply accept the Ether
    }

    // Handles calls to non-existent functions
    fallback() external payable {
        // Could be used to redirect or log unexpected interactions
    }

    // Example of a function that calls into the main contract
    function createCallback(address _receiver, string calldata _courseName) external payable {
        courseInstance.createFund{value: msg.value}(_receiver, _courseName);
    }

    // Check contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
