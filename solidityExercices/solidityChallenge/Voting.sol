// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

//Smart Contract Voting
contract Voting is Ownable{

    //uints
    uint winningProposalId;
    uint proposalId;
    uint voterNumber;
    uint proposalNumber;
    

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
    mapping(address => Voter) whitelist;
    mapping(uint => Proposal) proposals;

    //Modifiers
     modifier ownerWhitelist(){
        require(msg.sender == owner(), "Only contract owner can whitelist");   
        _;
     }

    modifier ownerStartProposalRegistration(){
        require(msg.sender == owner(), "Only contract owner can start proposal registration");
        _;
    }

    modifier ownerEndProposalRegistration(){
        require(msg.sender == owner(), "Only contract owner can end proposal registration");
        _;
    }

    modifier ownerStartVotingSession(){
        require(msg.sender == owner(), "Only contract owner can start voting session");
        _;
    }

    modifier ownerEndVotingSession(){
        require(msg.sender == owner(), "Only contract owner can end voting session");
        _;
    }

    modifier ownerCalculateVotes(){
        require(msg.sender == owner(), "Only contract owner can calculate votes");
        _;
    }


    //Functions
    function whitelistVoter(address _address) public ownerWhitelist {
        require(whitelist[_address].isRegistered == false, "Address already whitelisted");
        Voter memory voter;
        voter.isRegistered = true;
        voter.hasVoted = false;
        whitelist[_address] = voter;
    }


    function startProposalRegistration() public ownerStartProposalRegistration {
        emit ProposalsRegistrationStarted();
        emit WorkflowStatusChange(WorkflowStatus.RegisteringVoters, WorkflowStatus.ProposalsRegistrationStarted);
    }

    function addProposal(string memory description) external {
        require(whitelist[msg.sender].isRegistered == true, "You're not whitelisted");
        Proposal memory proposal = Proposal(description,0);
        proposals[proposalId] = proposal;
        emit ProposalRegistered(proposalId);
        proposalId++;
    }

    function endProposalRegistration() public ownerEndProposalRegistration {
        emit ProposalsRegistrationEnded();
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationStarted, WorkflowStatus.ProposalsRegistrationEnded);
    }



    function startVotingSession() public ownerStartVotingSession {
        emit VotingSessionStarted();
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationEnded, WorkflowStatus.VotingSessionStarted);
    }

    function vote(uint proposalIndex) external{
        require(true == whitelist[msg.sender].isRegistered,"You're not whitelisted");
        require(false == whitelist[msg.sender].hasVoted,"You have already voted");
        whitelist[msg.sender].votedProposalId = proposalIndex;
        proposals[proposalIndex].voteCount++;
        emit Voted(msg.sender, proposalIndex);
        voterNumber++;
    }

    function endVotingSession() public ownerEndVotingSession {
        emit VotingSessionEnded();
        emit WorkflowStatusChange(WorkflowStatus.VotingSessionStarted, WorkflowStatus.VotingSessionEnded);
    }



    function votesCalculation() public ownerCalculateVotes {
        uint winnerCount;
        for (uint i=0; i < proposalId; i++){
            if(winnerCount <= proposals[proposalId].voteCount){
                winnerCount = proposals[proposalId].voteCount;
                winningProposalId = proposalId;
            }
        }
        emit VotesTallied();
        emit WorkflowStatusChange(WorkflowStatus.VotingSessionEnded, WorkflowStatus.VotesTallied);
    }


    function getWinnerInfo() public view returns (string memory details){
        return proposals[winningProposalId].description;
    }

}