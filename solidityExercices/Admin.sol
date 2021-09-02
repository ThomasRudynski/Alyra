// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Admin is Ownable{
    mapping(address => bool) private _whitelist;
    mapping(address => bool) private _blacklist;
    
    event Whitelisted(address _address);
    event Blacklisted(address _address);
    
    
    modifier ownWhitelist(){
        require(msg.sender == owner(), "Only contract owner can whitelist");   
        _;
    }
    
    modifier ownBlacklist(){
        require(msg.sender == owner(), "Only contract owner can blacklist");   
        _;
    }
    
    function isWhitelisted(address _address) public view returns(bool){
        return _whitelist[_address];
    }
    
    function isBlacklisted(address _address) public view returns(bool){
        return _blacklist[_address];
    }
    
    function whitelist(address _address) public ownWhitelist {
        require(!_blacklist[_address], "Address blacklisted");
        require(!_whitelist[_address], "Address already whitelisted");
        _whitelist[_address] = true;
        emit Whitelisted(_address);
    }
    
    function blacklist(address _address) public ownBlacklist {
        require(!_blacklist[_address], "Address already blacklisted");
        require(msg.sender != _address, "Owner cannot be blacklisted");
        _blacklist[_address] = true;
        _whitelist[_address] = false;
        emit Blacklisted(_address);
    }
}