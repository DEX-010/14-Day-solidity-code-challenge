//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;

contract GadgetStore{
    struct NewGadget{
        string Name;
        string model;
        address owner;
        uint256 price;
        bool isSold;
    }

    // constructor(){
    //     NewGadget[0]= NewGadget('Dell XPS 13', '79484B',  address(this),  25);
    //     NewGadget[1]= NewGadget('Dell XPS 13', '7C64BD',address(this) ,   0);      
    //   }
    NewGadget[] public listofGadgets;
    mapping(string => address) public RetailtoModelpurchase;

    function add_new(string memory name, string memory _model, address _owner, uint256 _price, bool _issold) public{
        listofGadgets.push(
            NewGadget(name , 
            _model,
            _owner,
            _price,
            _issold)
        );
        RetailtoModelpurchase[_model] = _owner;
    }

    function get_gadget(uint256 index)public view returns(address, uint256, bool){
    //Creating a revert mechanism for the index search
        require(index < listofGadgets.length, "Index is out of range");
        //Creating an instance of the gadget struct and calling it
        NewGadget memory gadget = listofGadgets[index];
        return (gadget.owner, gadget.price, gadget.isSold);
    }
    function updategadgetstore(uint256 index, string memory _Name, uint256 _price, string memory new_model, bool _issold)public onlygadgetowner(index){
        NewGadget storage gadgets= listofGadgets[index];
        gadgets.Name = _Name;
        gadgets.price= _price;
        gadgets.model = new_model;
        gadgets.isSold = _issold;
    }

    function gadgetsold(bool _issold, uint256 index) public{
        NewGadget memory gadgetstate = listofGadgets[index];
        require(gadgetstate.isSold == false, "Gadget is sold");
    }

    //function deletegadgetdata()pubic{}
//     function lookupgadget()public{      
//     }
// }


    modifier onlygadgetowner(uint256 index){
        require((msg.sender ==listofGadgets[index].owner),"Access Denied");
        _;        
    }
}