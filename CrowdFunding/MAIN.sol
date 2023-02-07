// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >= 0.7.0 < 0.9.0;

contract CrowdFund {
    mapping (address => uint)  public contributors;
    address public manager;
    uint public deadline;
    uint public target;
    uint public raisedAmount;
    uint public NoOfContibutors;
    uint public MinContibution;

    constructor(uint _target, uint _deadline) {
        target = _target;
        deadline = _deadline+block.timestamp;
        MinContibution = 100 wei;
        manager = msg.sender;
    }

    function sendEth() public payable {
        require(block.timestamp < deadline, "Deadline has passesd");
        require(msg.value >=  MinContibution, "Not enough");

        if(contributors[msg.sender] == 0){
            NoOfContibutors++;
        }
        contributors[msg.sender] +=msg.value;
        raisedAmount += msg.value; 
    }
    function GetContractBal() public view returns(uint) {
        return address(this).balance;
    }
}