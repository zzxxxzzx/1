// 经典问候

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HelloWorld {
    string public greeting = "gm from Base!";
    function setGreeting(string memory _g) external { greeting = _g; }
}