// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";


contract Voting is Ownable{

    //uints
    uint winningProposalId;

    //Structs
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }

    struct Proposal {
        string description;
        uint voteCount;
    }

    //Enums
    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }
    
    //Events
    event VoterRegistered(address voterAddress);
    event ProposalsRegistrationStarted();
    event ProposalsRegistrationEnded();
    event ProposalRegistered(uint proposalId);
    event VotingSessionStarted();
    event VotingSessionEnded();
    event Voted (address voter, uint proposalId);
    event VotesTallied();
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);

    //Mappings
    mapping(address => bool) whitelist;

    //Modifiers
    modifier ownerStartProposalRegistration(){
        require(msg.sender == owner(), "Only contract owner can start proposal registration");
        _;
    }

    modifier ownerEndProposalRegistration(){
        require(msg.sender == owner(), "Only contract owner can end proposal registration");
        _;
    }

    //Functions
    function startProposalRegistration() public ownerStartProposalRegistration {
        emit ProposalsRegistrationStarted();
    }

    function endProposalRegistration() public ownerEndProposalRegistration {
        emit ProposalsRegistrationEnded();
    }

    function addProposal(string description) external {
        require(true == whitelist(msg.sender), "You're not whitelisted");
        Proposal memory proposal = Proposal(description,0);
        emit ProposalRegistered(proposalId);
    }
}