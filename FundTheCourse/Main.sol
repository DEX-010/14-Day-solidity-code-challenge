// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

error AmountExceeded();
error InvalidIndex();
error CannotFundSelf();

contract FundTheCourse {
    struct CourseFund {
        string courseName;
        address receiver;
        uint256 amountFunded;
        address funder;
    }

    uint256 public amountQuota;
    address public fundingOwner;

    constructor(address _owner, uint256 _quota) {
        fundingOwner = _owner;
        amountQuota = _quota;
    }

    mapping(address => CourseFund[]) public fundsByReceiver;

    function createFund(address _receiver, string calldata _courseName) external payable {
        if (msg.sender == _receiver) revert CannotFundSelf();
        if (address(this).balance + msg.value > amountQuota) revert AmountExceeded();

        CourseFund memory newFund = CourseFund({
            courseName: _courseName,
            receiver: _receiver,
            amountFunded: msg.value,
            funder: msg.sender
        });

        fundsByReceiver[_receiver].push(newFund);

        payable(_receiver).transfer(msg.value);
    }

    function getFundDetails(address _receiver, uint256 index) external view returns (CourseFund memory) {
        if (index >= fundsByReceiver[_receiver].length) revert InvalidIndex();
        return fundsByReceiver[_receiver][index];
    }

    function getTotalFundsByReceiver(address _receiver) external view returns (uint256 total) {
        CourseFund[] storage funds = fundsByReceiver[_receiver];
        for (uint256 i = 0; i < funds.length; i++) {
            total += funds[i].amountFunded;
        }
    }
}
