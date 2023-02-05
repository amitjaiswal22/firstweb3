// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
contract EventContract {
    struct Event{
     address organizer;
     string name;
     //date are in epox time (in seond)

     uint date;
     uint price;
     uint ticketCount;
     uint ticketRemain;
    }
    mapping (uint=>Event) public events;
    mapping (address=>mapping(uint=>uint)) public tickets;
    uint public nextId;
    
    function createEvent(string memory name ,uint date,uint price,uint ticketCount) external{
        require(date>block.timestamp,"YOU CAN ORGANIZE EVENT FOR FUTURE DATE");
        require(ticketCount>0,"YOU CAN ORGANIZE EVENT ONLY IF YOU CREATE MORE THAN 0 TICKETS ");
       // events is map which hold Event(structure datatype)
        events[nextId]=Event(msg.sender,name,date,price,ticketCount,ticketCount);
        nextId++;
            }
    function buyTicket(uint id,uint quantity) external payable{
        require(events[id].date!=0,"EVENT DOES NOT EXIST");
        require(events[id].date>block.timestamp,"EVENT HAS ALREADY OCCURED");
        Event storage _event=events[id];
        require(msg.value==(_event.price*quantity),"YOUR MONEY IS NOT ENOUGH");
        require(_event.ticketRemain>=quantity,"NOT ENOUGH TICKETS");
        _event.ticketRemain-=quantity;
        tickets[msg.sender][id]+=quantity;
    } 
    function transferTicket(uint id,uint quantity,address to) external{
        require(events[id].date!=0,"EVENT DOES NOT EXIST");
        require(events[id].date>block.timestamp,"EVENT HAS ALREADY OCCURED");
        require(tickets[msg.sender][id]>=quantity,"YOU DO NOT HAVE ENOUGH TICKETS");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;
       }
    }       
