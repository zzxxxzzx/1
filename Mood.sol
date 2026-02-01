// 今天心情

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract Mood {
    string public mood;
    function setMood(string memory _mood) external {
        mood = _mood;
    }

    function getMood() external view returns (string memory) {
        return mood;
    }
}
