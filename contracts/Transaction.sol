//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {GadgetStore} from "./meet.sol";

contract TransactionLog{
    error priceDiscrepancy(uint256 required, uint256 provided);
    error GadgetAlreadySold(uint256 gadgetId);
    AggregatorV3Interface public PriceFeed;
    GadgetStore public gadget_store;

    /*
    Network: ZKsync Testnet
    Currency: ETH/USD
    Address: 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF
    */

    constructor(address vendorAddress){
        PriceFeed = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF);
        gadget_store= GadgetStore(vendorAddress);

    }

    // function get_gadget_info(uint index)public{
    //     (address owner, uint256 price,bool isSold) = gadget_store.get_gadget(index);
    // }

    function payTransaction()public view returns(int256){
        (, int256 price, , , ) = PriceFeed.latestRoundData();
        return price;
        price/1e18;
    }
    
    function purchaseGadget(uint256 gadgetId) public payable {
        (address owner,uint256 price, bool isSold) = gadget_store.get_gadget(gadgetId);
        
        if (isSold == true) revert GadgetAlreadySold(gadgetId);
        owner = msg.sender;
        if (msg.value != price) revert priceDiscrepancy(price, msg.value);
        
        // Transfer funds securely to the seller
        payable(owner).transfer(msg.value);
        
        // Update gadget status in `GadgetManager`
        //gadget_store.updategadgetstore(uint256 , string memory _Name, uint256 _price, string memory new_model)
    }
}
