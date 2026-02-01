// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

abstract contract Employee {
    function idNumber() public virtual returns (uint);
    function managerId() public virtual returns (uint);
}

contract SalesPerson is Employee {
    function hourlyRate() external pure returns (uint) {
        return 20;
    }
    function idNumber() public pure override returns (uint) {
        return 55555;
    }
    function managerId() public pure override returns (uint) {
        return 1;
    }
}

contract EngineeringManager is Employee {
    function annualSalary() external pure returns (uint) {
        return 200000;
    }
    function managerId() public pure override returns (uint) {
        return 11111;
    }
    function idNumber() public pure override returns (uint) {
        return 5;
    }
}

contract InheritanceSubmission {
    SalesPerson private _salesPerson;
    EngineeringManager private _engineeringManager;

    constructor() {
        _salesPerson = new SalesPerson();
        _engineeringManager = new EngineeringManager();
    }

    function salesPerson() external view returns (address) {
        return address(_salesPerson);
    }

    function engineeringManager() external view returns (address) {
        return address(_engineeringManager);
    }
}