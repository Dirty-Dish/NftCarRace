// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {
    using SafeMathChainlink for uint256;

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;
    AggregatorV3Interface public priceFeed;

    constructor(address _priceFeed) public {
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    //payable mean can accept payment
    //used to pay for things
    function fund() public payable {
        //makes sure minimum is $50
        uint256 minimumUSD = 50 * 10 **  18;
        require(getConvertionRate(msg.value) >= minimumUSD, "You Need to supply more ETH.");

        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
        // convert eth to usd
    }

    function getVersion() public view returns(uint256){
        return priceFeed.version();
    }
    function getPrice() public view returns(uint256){
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer);
    }
    //sees how much eth they sent in usd
    function getConvertionRate(uint256 ethAmount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;
    }

    function getEntranceFee() public view returns (uint256){
        //min usd
        uint256 minimumUSD = 50 * 10**18;
        uint256 price = getPrice();
        uint256 percision = 1 *10**18;
        return(minimumUSD * percision) / price;
    }



    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function withdraw() payable onlyOwner public {
        msg.sender.transfer(address(this).balance);

        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }
}