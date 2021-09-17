var  Web3  =  require('web3');  
web3  =  new  Web3(new  Web3.providers.HttpProvider('https://mainnet.infura.io/v3/334fe0b193374db486f2de7564dc4343'));

console.log('Calling Contract.....');

var  abi  =  ABI-JSON-INTERFACE;
var  addr  =  "CONTRACT-ADDRESS";

var  Contract  =  new  web3.eth.Contract(abi, addr);

// FUNCTION must the name of the function you want to call. 
Contract.methods.FUNCTION().call().then(console.log);