// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract Bank {
    using SafeMath for uint;
    mapping(address => uint) private _balances;
    
    function deposit(uint _amount) public {
        require(msg.sender != address(0), "No deposit allowed for the address zero");
        require(_amount >= 0, "Amount must be higher than 0");
        _balances[msg.sender] = _balances[msg.sender].add(_amount);
    }
    
    function transfer(address _recipient, uint _amount) public{
        require(_recipient != address(0), "No transfer allowed to the address zero");
        require(_amount >= 0, "Amount must be higher than 0");
        require(_balances[msg.sender] >= _amount, "You have not enough balance");
        _balances[_recipient] = _balances[_recipient].add(_amount);
        _balances[msg.sender] = _balances[msg.sender].sub(_amount);
    }
    
    function balanceOf() public view returns(uint){
        return _balances[msg.sender];
    }

}