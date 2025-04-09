//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConvertor} from "./PriceConvertor.sol";

contract FundMe {

    using PriceConvertor for uint256;  
    uint256 public minUsd = 5e18;
    address[] public funders;
    mapping (address => uint256) public fundersToAmount;
    uint256 public result;

    function fund () public payable {    

        require(msg.value.getConversionRate() >= minUsd, "didnt send enough ETH");
        funders.push(msg.sender);
        fundersToAmount[msg.sender] = fundersToAmount[msg.sender] + msg.value ;

        //ton of computation here
        //but if it reverts the gas will be saved
        //gas used (in wei)  = gas price(in wei) * gas units used.

    }
    function withdraw() public {

        for(uint256 funderIndex = 0; funderIndex<funders.length ; funderIndex++){

            address funder = funders[funderIndex];
            fundersToAmount[funder] = 0;
        }
        //reset the array 
        funders = new address[](0);

        // using transfer function to send native tokens
        // function ()
        // payable (msg.sender).transfer(address(this).balance);

        // //using send function 
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "failed to send ETH");

        //using call method (Recommended)
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "failed to send ETH");


    }
    
}