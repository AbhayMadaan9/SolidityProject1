// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract lottery{
    address public manager;
    address payable[] public participants;

//In the starting of contract we inform that manager has the control of contract by giving the address of contract.
    constructor()  
    {
        manager = msg.sender;  //msg.sender will get the address of contract 
    }

    receive() external payable //this is special inbuilt func. used to get ether from participants in contract mostly used with external keyword and it is always payable and it has no parameters
    {
         //this is like if statemenet below code is executed if require statement is true.
        require(msg.value == 2 ether);
        participants.push(payable(msg.sender));
    }
    function getbalance() public view returns(uint) {
        require(msg.sender == manager);
        return address(this).balance;
    }
    //https://ethereum.stackexchange.com/questions/11572/how-does-the-keccak256-hash-function-work/45585,
    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, participants.length))); //this hash function is used to generate random from participants it is converted to uint. It is not usually used
    }
    //we use the logic that we take modulo of random generated value with lenth of participants since on taking the moduo the number generated will lie from 0-lengthOfParticipants.
    function selectWinner() public {
        require(msg.sender == manager);
        require(participants.length >= 3);

        uint rand = random();
        uint len = participants.length;
        address payable winner;
        uint index = rand%len;
        winner = participants[index];
        winner.transfer(getbalance());
        participants = new address payable[](0); //reseting the participants array
    }
}