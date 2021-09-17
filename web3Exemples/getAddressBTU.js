var  Web3  =  require('web3');
web3  =  new  Web3(new  Web3.providers.HttpProvider('https://mainnet.infura.io/v3/334fe0b193374db486f2de7564dc4343'));
    
console.log('Contract tokens balance.....');
var  addr  = ('0xd804ab1667e940052614a5acd103dde4d298ce36');
console.log("Address: "  +  addr);
    
var  contractAddr  = ('0xb683d83a532e2cb7dfa5275eed3698436371cc9f');
var  tknAddress  = (addr).substring(2); //Remove "0x"
    
//Balance of function call
var  contractData  = ('0x70a08231000000000000000000000000'  +  tknAddress);
    
web3.eth.call({
	to: contractAddr,
	data: contractData 
}, function(err, result) {
	if (result) {
		var  tokens  =  web3.utils.toBN(result).toString(); 
		    console.log('Tokens : '  +  web3.utils.fromWei(tokens, 'ether')); //Balance
	}
	else {
		console.log(err); // Errors
	}
});