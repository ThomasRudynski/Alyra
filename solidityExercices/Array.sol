// SPDX-License-Identifier: MIT
pragma solidity 0.6.11;
 
contract Whitelist {
    struct Person { // Structure de données
       uint age;
       string name;
   }

   Person[] public people;
}