// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
 
contract Crowdsale {
   using SafeMath for uint256;
 
   address public owner; // the owner of the contract
   address payable public escrow; // wallet to collect raised ETH
   uint256 public savedBalance = 0; // Total amount raised in ETH
   mapping (address => uint256) public balances; // Balances in incoming Ether

   event SendEth(address indexed _receiver, uint256 indexed _value, uint256 indexed _timestamp); //indexed means that you can research events with these parameters
 
   // Initialization
   constructor(address payable _escrow) public{
       owner = msg.sender;
       // add address of the specific contract
       escrow = _escrow;
   }
  
   // function to receive ETH
   receive() payable public {
       balances[msg.sender] = balances[msg.sender].add(msg.value);
       savedBalance = savedBalance.add(msg.value);
       escrow.transfer(msg.value);

       emit SendEth(escrow, msg.value, block.timestamp);
   }
  
   // refund investisor
   function withdrawPayments() public{
       address payable payee = msg.sender;
       uint256 payment = balances[payee];

       require(payment!=0);
       require(address(this).balance >= payment);
 
       savedBalance = savedBalance.sub(payment);
       balances[payee] = 0;
       payee.send(payment);

       emit SendEth(payee, payment, block.timestamp);
       
   }
}