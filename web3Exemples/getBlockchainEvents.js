var  Web3  =  require('web3');
web3  =  new  Web3(new  Web3.providers.HttpProvider('https://mainnet.infura.io/v3/334fe0b193374db486f2de7564dc4343'));

var  addr  =  "0xe16f391e860420e65c659111c9e1601c0f8e2818";

console.log('Events by Address: '  +  addr);

var  abi  = [{"constant":true,"inputs":[],"name":"getgreeting","outputs":[{"name":"","type":"bytes32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_msg","type":"bytes32"}],"name":"greet","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_greeting","type":"bytes32"}],"name":"Event1","type":"event"}]
var  contract  =  new  web3.eth.Contract(abi, '0x38979119752B1891ae9B5cD6986285eA3190AE38');

console.log('-----------------------------------');
console.log('Matching Smart Contract Events');
console.log('-----------------------------------');

contract.getPastEvents('Event1', {
        filter: {_from: addr},
        fromBlock: 0,
        toBlock: 'latest'
}, function(error, events){
        //console.log(events);
    for (i=0; i<events.length; i++) {
        var  eventObj  =  events[i];
        console.log('Address: '  +  eventObj.returnValues._from);
        console.log('Greeting: ' + web3.utils.hexToAscii(eventObj.returnValues._greeting));
    }
});