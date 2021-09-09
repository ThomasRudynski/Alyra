// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/math/SafeMath.sol";

contract PullPayment {
    using SafeMath for uint256;
    mapping (address => uint256) public payments;
    uint256 public totalPayments;
    
    function send(address destination, uint256 amount) internal {
        payments[destination] = payments[destination].add(amount);
    }

    function withdrawPayment() public {
        require(payments[msg.sender] != 0);
        totalPayments = totalPayments.sub(payments[msg.sender]);
        payments[msg.sender] = 0;
        msg.sender.transfer(payments[msg.sender]);
    }
}
