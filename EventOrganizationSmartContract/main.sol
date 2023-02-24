// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >= 0.7.0<0.9.0;

contract Main {
    struct Event {
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }

    mapping (uint => Event) public events;
    mapping (address => mapping (uint  => uint)) public tickets;
    uint public nextId;

    function createEvent(string memory name, uint date, uint price, uint ticketCount) external {
        require(date>block.timestamp, "Not possible like doing event before creating it");
        require(ticketCount>0);

        events[nextId] = Event(msg.sender, name, date, price, ticketCount, ticketCount); 
        nextId++;
    }

    function buyTicket(uint id, uint quantity) external payable{
        require(events[id].date != 0, "Event does not exist since initially date is initialised with 0");
        require(block.timestamp < events[id].date, "Event has already occured");
        Event storage _event = events[id];
        require(msg.value == (_event.price*quantity), "Ether is not enough");
        require(_event.ticketRemain >= quantity, "Not enough");
        _event.ticketRemain -= quantity;
        tickets[msg.sender][id] +=quantity;
    }
    function transferTicket(uint id, uint quantity, address to) external{
        require(events[id].date != 0, "Event does not exist since initially date is initialised with 0");
        require(block.timestamp < events[id].date, "Event has already occured");
        require(tickets[msg.sender][id]>=quantity, "Not enough tickets");
        tickets[to][id] += quantity;
    }
}