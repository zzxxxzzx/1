// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

error NotApproved(string albumName);

contract FavoriteRecords {
    mapping(string => bool) public approvedRecords;
    mapping(address => mapping(string => bool)) public userFavorites;
    string[] private approvedRecordsList;
    
    constructor() {
        approvedRecordsList = [
            "Thriller",
            "Back in Black",
            "The Bodyguard",
            "The Dark Side of the Moon",
            "Their Greatest Hits (1971-1975)",
            "Hotel California",
            "Come On Over",
            "Rumours",
            "Saturday Night Fever"
        ];
        
        for(uint i = 0; i < approvedRecordsList.length; i++) {
            approvedRecords[approvedRecordsList[i]] = true;
        }
    }
    
    function getApprovedRecords() public view returns (string[] memory) {
        return approvedRecordsList;
    }
    
    function addRecord(string memory _albumName) public {
        if(!approvedRecords[_albumName]) {
            revert NotApproved(_albumName);
        }
        userFavorites[msg.sender][_albumName] = true;
    }
    
    function getUserFavorites(address _user) public view returns (string[] memory) {
        uint count = 0;
        for(uint i = 0; i < approvedRecordsList.length; i++) {
            if(userFavorites[_user][approvedRecordsList[i]]) {
                count++;
            }
        }
        
        string[] memory favorites = new string[](count);
        uint index = 0;
        for(uint i = 0; i < approvedRecordsList.length; i++) {
            if(userFavorites[_user][approvedRecordsList[i]]) {
                favorites[index] = approvedRecordsList[i];
                index++;
            }
        }
        
        return favorites;
    }
    
    function resetUserFavorites() public {
        for(uint i = 0; i < approvedRecordsList.length; i++) {
            delete userFavorites[msg.sender][approvedRecordsList[i]];
        }
    }
}