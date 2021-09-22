// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

//Smart Contract Voting
contract Voting is Ownable{

    //Structs
    //Votant
    struct Voter {  
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }

    //Proposition
    struct Proposal { 
        string description;
        uint voteCount;
    }

    //Enums
    //Statut du vote
    enum WorkflowStatus { 
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }

    //uints
    uint private winningProposalId;
    uint private proposalId;
    
    //status
    WorkflowStatus public status;
    
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
    mapping(address => Voter) private whitelist;
    mapping(uint => Proposal) private proposals;

    //Functions
    function whitelistVoter(address _address) public onlyOwner {
        require(status == WorkflowStatus.RegisteringVoters, "Whitelist voters is not started");
        require(whitelist[_address].isRegistered == false, "Address already whitelisted");
        whitelist[_address] = Voter(true,false,0);
    }


    function startProposalRegistration() public onlyOwner {
        require(status != WorkflowStatus.ProposalsRegistrationEnded, "Proposal registration is ended");
        require(status == WorkflowStatus.RegisteringVoters, "Registering voters is not ended");
        status = WorkflowStatus.ProposalsRegistrationStarted;
        emit ProposalsRegistrationStarted();
        emit WorkflowStatusChange(WorkflowStatus.RegisteringVoters, WorkflowStatus.ProposalsRegistrationStarted);
    }

    function addProposal(string memory description) external {
        require(status == WorkflowStatus.ProposalsRegistrationStarted, "Proposal registration is not started");
        require(whitelist[msg.sender].isRegistered == true, "You're not whitelisted");
        proposals[proposalId] = Proposal(description,0);
        proposalId++;
        emit ProposalRegistered(proposalId-1);
    }

    function endProposalRegistration() public onlyOwner {
        require(status = WorkflowStatus.ProposalsRegistrationStarted, "Proposal registration is not started");
        status = WorkflowStatus.ProposalsRegistrationEnded;
        emit ProposalsRegistrationEnded();
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationStarted, WorkflowStatus.ProposalsRegistrationEnded);
    }



    function startVotingSession() public onlyOwner {
        require(status == WorkflowStatus.ProposalsRegistrationEnded, "Proposal registration is not ended");
        status = WorkflowStatus.VotingSessionStarted;
        emit VotingSessionStarted();
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationEnded, WorkflowStatus.VotingSessionStarted);
    }

    function vote(uint proposalIndex) external{
        require(status == WorkflowStatus.VotingSessionStarted, "Voting session is not started");
        require(true == whitelist[msg.sender].isRegistered,"You're not whitelisted");
        require(false == whitelist[msg.sender].hasVoted,"You have already voted");
        whitelist[msg.sender].votedProposalId = proposalIndex;
        whitelist[msg.sender].hasVoted = true;
        proposals[proposalIndex].voteCount++;

        if(proposals[proposalIndex].winningProposalId <= proposals[i].proposalIndex){
            winningProposalId = i;
        }
        emit Voted(msg.sender, proposalIndex);
    }

    function endVotingSession() public onlyOwner {
        require(status == WorkflowStatus.VotingSessionStarted, "Voting session is not started");
        status = WorkflowStatus.VotingSessionEnded;
        emit VotingSessionEnded();
        emit WorkflowStatusChange(WorkflowStatus.VotingSessionStarted, WorkflowStatus.VotingSessionEnded);
    }

    function votesCalculation() public onlyOwner {
        require(status == WorkflowStatus.VotingSessionEnded, "Voting session is not ended");
        status = WorkflowStatus.VotesTallied;
        emit VotesTallied();
        emit WorkflowStatusChange(WorkflowStatus.VotingSessionEnded, WorkflowStatus.VotesTallied);
    }


    function getWinnerInfo() public view returns (string memory description){
        require(status == WorkflowStatus.VotesTallied, "Votes are not tallied");
        return proposals[winningProposalId].description;
    }

}