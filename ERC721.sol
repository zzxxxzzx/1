// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

error HaikuNotUnique();
error NotYourHaiku(uint256 tokenId);
error NoHaikusShared();

contract HaikuNFT is ERC721 {
    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }
    
    Haiku[] public haikus;
    mapping(address => uint256[]) public sharedHaikus;
    mapping(string => bool) private lineUsed;
    uint256 public counter = 1;
    
    constructor() ERC721("HaikuNFT", "HAIKU") {}
    
    function mintHaiku(string memory _line1, string memory _line2, string memory _line3) external {
        if(lineUsed[_line1] || lineUsed[_line2] || lineUsed[_line3]) {
            revert HaikuNotUnique();
        }
        
        lineUsed[_line1] = true;
        lineUsed[_line2] = true;
        lineUsed[_line3] = true;
        
        haikus.push(Haiku(msg.sender, _line1, _line2, _line3));
        _safeMint(msg.sender, counter);
        counter++;
    }
    
    function shareHaiku(address _to, uint256 _haikuId) public {
        if(ownerOf(_haikuId) != msg.sender) {
            revert NotYourHaiku(_haikuId);
        }
        sharedHaikus[_to].push(_haikuId);
    }
    
    function getMySharedHaikus() public view returns (Haiku[] memory) {
        if(sharedHaikus[msg.sender].length == 0) {
            revert NoHaikusShared();
        }
        
        Haiku[] memory shared = new Haiku[](sharedHaikus[msg.sender].length);
        for(uint i = 0; i < sharedHaikus[msg.sender].length; i++) {
            uint256 haikuId = sharedHaikus[msg.sender][i];
            shared[i] = haikus[haikuId - 1];
        }
        return shared;
    }
}