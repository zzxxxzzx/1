// 每日幸运数字

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LuckyNumber {  
    uint public number;
    function roll() external { number = uint(keccak256(abi.encode(block.timestamp, msg.sender))) % 1000; }
}