// SPDX-License-Identifier: MIT
pragma solidity 0.6.11;
 
contract Whitelist {
    struct Person { // Structure de données
       uint age;
       string name;
   }

   Person[] public people;

   function add(string memory _name, uint _age) public{
        Person memory person = Person(_name, _age);
        people.push(person);
    }
    
    function remove() public{
        people.pop();
    }
}