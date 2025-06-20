//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract PowerBillExpense{

    AggregatorV3Interface public PayPrinciple;
    struct PowerSupply{
        uint256 UnitPurchased;
        string SessionId;
        uint256 price;
        address payee;
}
    mapping(address => uint256) public userUnits;
    mapping(address => PowerSupply[])public userRecords;
    uint256 public amountperunit = 0.01e18;
    address public reciever;

    //mapping(uint256 => string) public PricetosessionID;

    PowerSupply[] public PowerRecord;
    constructor(address _reciever){
        //Specifying eth/usd chain to be deployed on ideally;
        //Currently on zksync testnet
        PayPrinciple = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF);
        reciever= _reciever;
    }
    //For populating the global array
    function TransactionLog(uint256 _UnitPurchased, string memory _SessionId, uint256 _price,address _Payee, uint256 ListIndex)public{
        uint256 timestamp = getLatestTimestamp();
        uint256 totalamount= _UnitPurchased * amountperunit;
        //Using the timestamp feature to track the session id and converting to string..
        string memory SessionId = string(abi.encodePacked("Session-", uint2str(timestamp)));
        PowerRecord.push(PowerSupply(
            _UnitPurchased,
            _SessionId,
            _price,
            msg.sender)
            );
    }
    //This is used to initiate a transaction whilst still tracking individual records

    function purchasePower(uint256 _units)public payable{
        uint256 timestamp = getLatestTimestamp();
        uint256 CurrentEthPrice=(_units * amountperunit)/1e18;
        string memory sessionId = string(abi.encodePacked("Session-", uint2str(timestamp)));
        PowerSupply memory record = PowerSupply({
            UnitPurchased: _units,
            SessionId: sessionId,
            price: CurrentEthPrice,
            payee: msg.sender
        });
        userRecords[msg.sender].push(record);
        payable(reciever).transfer(msg.value);
        }

    //Defing the uint2str function..
    //Function for converting Timestamps(integers) to readable Format(string)
    function uint2str(uint _i) internal pure returns (string memory) {
    if (_i == 0) {
        return "0";
    }
    uint j = _i;
    uint length;
    while (j != 0) {
        length++;
        j /= 10;
    }
    bytes memory bstr = new bytes(length);
    uint k = length;
    while (_i != 0) {
        k = k - 1;
        bstr[k] = bytes1(uint8(48 + _i % 10));
        _i /= 10;
    }
    return string(bstr);
}
    function getLatestTimestamp() public view returns (uint256) {
    //For session Id tracking.
    (, , , uint256 updatedAt, ) = PayPrinciple.latestRoundData();
    return updatedAt;
}

    function getLatestPrice()public view returns(int256){
        (,int256 price, , ,)=PayPrinciple.latestRoundData();
        return(price);

    }
    // function TrackExpense(uint256 index) public payable{
    //     require(PowerRecord[index].payee !=msg.sender, "Incorrect payment credentials");
    //     //payable (reciever).transfer(address(msg.value));
        
    // }
    function checkUsage(uint256 index)public{
        PowerSupply memory PowerInstance = PowerRecord[index];
        for(index ;index < PowerRecord.length; index++){
            PowerRecord[index].UnitPurchased;
        }
    }

    //  modifier strictly_owner(uint256 _index){
    //         require(PowerSupply[_index].Payee ==msg.sender, "Access Denied");
    //         _;
    //     }
}
