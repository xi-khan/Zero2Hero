// SPDX-License-Identifier: None
pragma solidity ^0.8.17;


contract BootcampContract {

    uint256 number;
    address deployer;

    // depluer address set to msg.sedner on deployment
    constructor() {
        deployer = msg.sender;
    }

    address constant deadAddress = 0x000000000000000000000000000000000000dEaD;

    function returnAddress() view external returns (address) {
        if(msg.sender == deployer) {
            return deadAddress;
        }
        return deployer;
    }


    function store(uint256 num) public {
        number = num;
    }


    function retrieve() public view returns (uint256){
        return number;
    }
}