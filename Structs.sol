// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

error BadCarIndex(uint index);

contract GarageManager {
    
    struct Car {
        string make;
        string model;
        string color;
        uint numberOfDoors;
    }
    
    mapping(address => Car[]) public garage;
    
    function addCar(
        string calldata _make,
        string calldata _model,
        string calldata _color,
        uint _numberOfDoors
    ) public {
        Car memory newCar = Car({
            make: _make,
            model: _model,
            color: _color,
            numberOfDoors: _numberOfDoors
        });
        garage[msg.sender].push(newCar);
    }
    
    function getMyCars() public view returns (Car[] memory) {
        return garage[msg.sender];
    }
    
    function getUserCars(address _user) public view returns (Car[] memory) {
        return garage[_user];
    }
    
    function updateCar(
        uint _index,
        string calldata _make,
        string calldata _model,
        string calldata _color,
        uint _numberOfDoors
    ) public {
        if (_index >= garage[msg.sender].length) {
            revert BadCarIndex(_index);
        }
        
        garage[msg.sender][_index] = Car({
            make: _make,
            model: _model,
            color: _color,
            numberOfDoors: _numberOfDoors
        });
    }
    
    function resetMyGarage() public {
        delete garage[msg.sender];
    }
}