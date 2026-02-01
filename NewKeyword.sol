// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";

error ContactNotFound(uint id);

contract AddressBook is Ownable {
    struct Contact {
        uint id;
        string firstName;
        string lastName;
        uint[] phoneNumbers;
    }
    
    Contact[] private contacts;
    uint private nextId = 1;
    
    constructor(address initialOwner) Ownable(initialOwner) {}
    
    function addContact(
        string calldata _firstName,
        string calldata _lastName,
        uint[] calldata _phoneNumbers
    ) external onlyOwner {
        contacts.push(Contact({
            id: nextId,
            firstName: _firstName,
            lastName: _lastName,
            phoneNumbers: _phoneNumbers
        }));
        nextId++;
    }
    
    function deleteContact(uint _id) external onlyOwner {
        for (uint i = 0; i < contacts.length; i++) {
            if (contacts[i].id == _id) {
                contacts[i] = contacts[contacts.length - 1];
                contacts.pop();
                return;
            }
        }
        revert ContactNotFound(_id);
    }
    
    function getContact(uint _id) external view returns (Contact memory) {
        for (uint i = 0; i < contacts.length; i++) {
            if (contacts[i].id == _id) {
                return contacts[i];
            }
        }
        revert ContactNotFound(_id);
    }
    
    function getAllContacts() external view returns (Contact[] memory) {
        return contacts;
    }
}

contract AddressBookFactory {
    function deploy() external returns (address) {
        AddressBook newAddressBook = new AddressBook(msg.sender);
        return address(newAddressBook);
    }
}