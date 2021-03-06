// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16;
 
contract SimpleStorage {
   uint data;
 
   function set(uint x) public {
       data = x;
   }
 
   function get() public view returns (uint) {
       return data;
   }
}