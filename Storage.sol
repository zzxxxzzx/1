// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

error TooManyShares(uint256 totalShares);

contract EmployeeStorage {
    uint16 private shares;
    uint24 private salary;
    string public name;
    uint256 public idNumber;
    
    constructor(uint16 _shares, string memory _name, uint24 _salary, uint256 _idNumber) {
        shares = _shares;
        name = _name;
        salary = _salary;
        idNumber = _idNumber;
    }
    
    function viewSalary() public view returns (uint24) {
        return salary;
    }
    
    function viewShares() public view returns (uint16) {
        return shares;
    }
    
    function grantShares(uint16 _newShares) public {
        if (_newShares > 5000) {
            revert("Too many shares");
        }
        
        uint16 newTotal = shares + _newShares;
        if (newTotal > 5000) {
            revert TooManyShares(newTotal);
        }
        
        shares = newTotal;
    }
    
    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload (_slot)
        }
    }
    
    function debugResetShares() public {
        shares = 1000;
    }
}