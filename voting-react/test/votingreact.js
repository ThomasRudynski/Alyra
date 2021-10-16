const VotingReact = artifacts.require("./Voting.sol");

contract("Voting", accounts => {
  let voting;

  beforeEach('setup contract for each test', async function() {
    voting = await VotingReact.new('0xF24eC99E0dBcBb1AEA6BEc735E52869A1858f9f4');
  })

  it("...has an owner", async () => {
    assert.equal(await voting.owner(),'0xF24eC99E0dBcBb1AEA6BEc735E52869A1858f9f4' , "Voting React has not owner");
  });

  it("...starting status is 0", async () => {
    assert.equal(await voting.status(),'0' , "Starting status is not 0");
  });

  it("...status after starting proposal registration is 1", async () => {
    await voting.startProposalRegistration();
    assert.equal(await voting.status(),'1' , "Status is not 1");
  });

  it("...status after ending proposal registration is 2", async () => {
    await voting.startProposalRegistration();
    await voting.endProposalRegistration();
    assert.equal(await voting.status(),'2' , "Status is not 2");
  });

  it("...status after starting voting session is 3", async () => {
    await voting.startProposalRegistration();
    await voting.endProposalRegistration();
    await voting.startVotingSession();
    assert.equal(await voting.status(),'3' , "Status is not 3");
  });

  it("...status after ending voting session is 4", async () => {
    await voting.startProposalRegistration();
    await voting.endProposalRegistration();
    await voting.startVotingSession();
    await voting.endVotingSession();
    assert.equal(await voting.status(),'4' , "Status is not 4");
  });

  it("...status after tailing vote is 5", async () => {
    await voting.startProposalRegistration();
    await voting.endProposalRegistration();
    await voting.startVotingSession();
    await voting.endVotingSession();
    await voting.votesCalculation();
    assert.equal(await voting.status(),'5' , "Status is not 5");
  });

  it("...winner should be proposal 2", async () => {
    voting.whitelistVoter('0xF24eC99E0dBcBb1AEA6BEc735E52869A1858f9f4');
    voting.whitelistVoter('0x261C90A862C384992bf82e4EAf76A97A0BB61001');
    await voting.startProposalRegistration();
    voting.addProposal('Proposal 1',{from: '0xF24eC99E0dBcBb1AEA6BEc735E52869A1858f9f4'});
    voting.addProposal('Proposal 2',{from: '0xF24eC99E0dBcBb1AEA6BEc735E52869A1858f9f4'});
    await voting.endProposalRegistration();

    await voting.startVotingSession();
    voting.vote(1,{from: '0xF24eC99E0dBcBb1AEA6BEc735E52869A1858f9f4'});
    voting.vote(1,{from: '0x261C90A862C384992bf82e4EAf76A97A0BB61001'});
    await voting.endVotingSession();
    await voting.votesCalculation();

    assert.equal(await voting.getWinnerInfo(),'Proposal 2' , "Winner is not Proposal 2");
  });

});
