// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BasicMath {
    
    function adder(uint _a, uint _b) public pure returns (uint sum, bool error) {
        // Check for overflow
        unchecked {
            sum = _a + _b;
            if (sum < _a) {
                return (0, true);  // Overflow occurred
            }
        }
        return (sum, false);
    }
    
    function subtractor(uint _a, uint _b) public pure returns (uint difference, bool error) {
        // Check for underflow
        if (_b > _a) {
            return (0, true);  // Underflow would occur
        }
        difference = _a - _b;
        return (difference, false);
    }
}