const Web3 = require('web3')
const rpcURL = "https://ropsten.infura.io/v3/334fe0b193374db486f2de7564dc4343"
const web3 = new Web3(rpcURL)

web3.eth.getBalance("0x06688FEdB6188Ca3E84765b8984c1dF7236675b1", (err, wei) => { 
   balance = web3.utils.fromWei(wei, 'ether'); // convertir la valeur en ether
   console.log(balance);
});