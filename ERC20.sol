// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WeightedVoting is ERC20 {
    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh(uint256 quorum);
    error AlreadyVoted();
    error VotingClosed();
    
    struct Issue {
        address[] voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }
    
    struct SerializedIssue {
        address[] voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }
    
    enum Vote { AGAINST, FOR, ABSTAIN }
    
    Issue[] private issues;
    mapping(address => bool) public hasClaimed;
    uint256 public maxSupply = 1000000;
    uint256 public claimAmount = 100;
    
    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        issues.push();
    }
    
    function claim() public {
        if (hasClaimed[msg.sender]) {
            revert TokensClaimed();
        }
        if (totalSupply() + claimAmount > maxSupply) {
            revert AllTokensClaimed();
        }
        _mint(msg.sender, claimAmount);
        hasClaimed[msg.sender] = true;
    }
    
    function createIssue(string memory _issueDesc, uint256 _quorum) external returns (uint256) {
        if (balanceOf(msg.sender) == 0) {
            revert NoTokensHeld();
        }
        if (_quorum > totalSupply()) {
            revert QuorumTooHigh(_quorum);
        }
        
        Issue storage newIssue = issues.push();
        newIssue.issueDesc = _issueDesc;
        newIssue.quorum = _quorum;
        
        return issues.length - 1;
    }
    
    function getIssue(uint256 _issueId) external view returns (SerializedIssue memory) {
        Issue storage issue = issues[_issueId];
        return SerializedIssue({
            voters: issue.voters,
            issueDesc: issue.issueDesc,
            votesFor: issue.votesFor,
            votesAgainst: issue.votesAgainst,
            votesAbstain: issue.votesAbstain,
            totalVotes: issue.totalVotes,
            quorum: issue.quorum,
            passed: issue.passed,
            closed: issue.closed
        });
    }
    
    function vote(uint256 _issueId, Vote _vote) public {
        if (balanceOf(msg.sender) == 0) {
            revert NoTokensHeld();
        }
        
        Issue storage issue = issues[_issueId];
        
        if (issue.closed) {
            revert VotingClosed();
        }
        
        for (uint i = 0; i < issue.voters.length; i++) {
            if (issue.voters[i] == msg.sender) {
                revert AlreadyVoted();
            }
        }
        
        uint256 voteWeight = balanceOf(msg.sender);
        
        if (_vote == Vote.FOR) {
            issue.votesFor += voteWeight;
        } else if (_vote == Vote.AGAINST) {
            issue.votesAgainst += voteWeight;
        } else {
            issue.votesAbstain += voteWeight;
        }
        
        issue.totalVotes += voteWeight;
        issue.voters.push(msg.sender);
        
        if (issue.totalVotes >= issue.quorum) {
            issue.closed = true;
            if (issue.votesFor > issue.votesAgainst) {
                issue.passed = true;
            }
        }
    }
}