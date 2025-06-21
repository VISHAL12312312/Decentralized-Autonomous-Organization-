// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DAO {
    address public owner;
    uint256 public proposalCount;

    struct Proposal {
        string description;
        uint256 votes;
        uint256 deadline;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => bool) public voters;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyVoter() {
        require(voters[msg.sender], "Not a registered voter");
        _;
    }

    function registerVoter(address _voter) public onlyOwner {
        voters[_voter] = true;
    }

    function createProposal(string calldata _description, uint256 _durationInMinutes) public onlyVoter {
        proposalCount++;
        proposals[proposalCount] = Proposal({
            description: _description,
            votes: 0,
            deadline: block.timestamp + (_durationInMinutes * 1 minutes),
            executed: false
        });
    }

    function voteOnProposal(uint256 _proposalId) public onlyVoter {
        require(block.timestamp < proposals[_proposalId].deadline, "Voting closed");
        require(!hasVoted[_proposalId][msg.sender], "Already voted");

        proposals[_proposalId].votes++;
        hasVoted[_proposalId][msg.sender] = true;
    }

    function executeProposal(uint256 _proposalId) public onlyOwner {
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp >= proposal.deadline, "Voting not ended");
        require(!proposal.executed, "Already executed");

        // This is a mock execution
        proposal.executed = true;
    }
}
