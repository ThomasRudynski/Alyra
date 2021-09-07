// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";


contract Voting is Ownable{

    //uints
    uint winningProposalId;
    uint proposalId;
    uint voterNumber;
    uint proposalNumber;
    

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
    mapping(address => Voter) whitelist;
    mapping(uint => Proposal) proposals;

    //Modifiers
     modifier ownerWhitelist(){
        require(msg.sender == owner(), "Only contract owner can whitelist");   
        _;
    }

    modifier ownerStartWhitelist(){
        require(msg.sender == owner(), "Only contract owner can start whitelist registration");
        _;
    }

    modifier ownerEndWhitelist(){
        require(msg.sender == owner(), "Only contract owner can end whitelist registration");
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

    function startWhitelistRegistration() public ownerStartWhitelist {
        emit WorkflowStatusChange(0, RegisteringVoters);
    }

    function whitelist(address _address) public ownerWhitelist {
        require(false = whitelist[_address].isRegistered, "Address already whitelisted");
        whitelist[_address] = Voter(true,false,-1);
    }


    function startProposalRegistration() public ownerStartProposalRegistration {
        emit ProposalsRegistrationStarted();
        emit WorkflowStatusChange(RegisteringVoters, ProposalsRegistrationStarted);
    }

    function addProposal(string description) external {
        require(true == whitelist(msg.sender).isRegistered, "You're not whitelisted");
        Proposal memory proposal = Proposal(description,0);
        proposals[proposalId] = proposal;
        emit ProposalRegistered(proposalId);
        proposalId++;
    }

    function endProposalRegistration() public ownerEndProposalRegistration {
        emit ProposalsRegistrationEnded();
        emit WorkflowStatusChange(ProposalsRegistrationStarted, ProposalsRegistrationEnded);
    }



    function startVotingSession() public ownerStartVotingSession {
        emit VotingSessionStarted();
        emit WorkflowStatusChange(ProposalsRegistrationEnded, VotingSessionStarted);
    }

    function vote(uint proposalIndex) external{
        require(true == whitelist(msg.sender).isRegistered,"You're not whitelisted");
        require(false == whitelist(msg.sender).hasVoted,"You have already voted");
        require(proposals[uint] != 0,"This proposal does not exist");
        whitelist(msg.sender).votedProposalId = proposalIndex;
        proposals[proposalIndex].voteCount++;
        emit Voted(msg.sender, proposalIndex);
        voterNumber++;
    }

    function endVotingSession() public ownerEndVotingSession {
        emit VotingSessionEnded();
        emit WorkflowStatusChange(VotingSessionStarted, VotingSessionEnded);
    }



    function votesCalculation() public ownerCalculateVotes {
        for (uint i=0; i < proposalId; i++){
            if(winnerCount <= proposals[proposalId].voteCount){
                winnerCount = proposals[proposalId].voteCount;
                winningProposalId = proposalId;
            }
        }
        emit VotesTallied();
        emit WorkflowStatusChange(VotingSessionEnded, VotesTallied);
    }


    function getWinnerInfo() public view returns (string details){
        return proposals[winningProposalId].description;
    }

}