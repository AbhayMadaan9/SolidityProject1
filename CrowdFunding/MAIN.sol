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

    function Reefund() public{
        require(block.timestamp > deadline && raisedAmount < target, "You are eligeble to get refund");
        require(contributors[msg.sender]>0);
        address payable user = payable(msg.sender);
        user.transfer(contributors[msg.sender]);
        contributors[msg.sender] = 0;
    }
    struct Request {
        string description;
        address payable receipient;
        uint value;
         bool completed;
         uint NoOfVotors;
         mapping(address=>bool) voters;
    }
    mapping(uint=>Request) public requests; //different voters vote to charity money for differnt purposes so each voters have different requests to use theirs contributed ethers.

    modifier OnlyManager {
        require(msg.sender == manager, "Invalid User");
        _;
    }
    uint numRequests;
    function createRequest(string memory desc, address payable resc, uint val) public OnlyManager {
        //manager makes a request for accessing the ethers
        Request storage newReq = requests[numRequests]; //we cannot use memory with it because whenever we use mapping in struct we can't use memory keyword with it.
        numRequests++;
        newReq.description = desc;
        newReq.receipient = resc;
        newReq.value = val;
        newReq.completed = false;
        newReq.NoOfVotors = 0;
    }
    function voteRequest(uint _reqNo) public{
        require(contributors[msg.sender] > 0, "Contribute first");
        Request storage Req = requests[_reqNo];
        require(Req.voters[msg.sender] == false, "You have already voted");
        Req.voters[msg.sender] = true;
        Req.NoOfVotors++;
    }
    //Check if manager can take ethers if voting is in his favor.
    function MakePayment(uint reqNo) public OnlyManager {
        require(raisedAmount >= target);
        Request storage Reqi =  requests[reqNo];
        require(Reqi.completed == false, "Req has alredy been made");
        require(Reqi.NoOfVotors > NoOfContibutors/2, "Majority not supported");
        Reqi.completed = true;
    }
}