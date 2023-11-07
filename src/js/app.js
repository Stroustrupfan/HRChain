document.getElementById('hrChainForm').addEventListener('submit', function (e) {
  e.preventDefault();

  var name = document.getElementById('name').value;
  var userID = document.getElementById('userID').value;
  var info = document.getElementById('info').value;
  var docCount = document.getElementById('docCount').value;
  var stageAcc = document.getElementById('stageAcc').value;
  var docInfo = document.getElementById('docInfo').value;
  var timestamp = document.getElementById('timestamp').value;
  var hash = document.getElementById('hash').value;
  var signature = document.getElementById('signature').value;

  // Check if Web3 has been injected by the browser
  if (typeof window.ethereum !== 'undefined') {
    var Web3 = require('web3');
    var web3 = new Web3(window.ethereum);
    const contractJson = require('../build/contracts/HR_Chain.json');

    const abi = contractJson.abi;
    var contractAddress = "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4"; // replace with your contract address
    var contract = new web3.eth.Contract(abi, contractAddress);

    contract.methods.register_client(name, userID, info, docCount, stageAcc, docInfo, timestamp, hash, signature)
      .send({ from: '0xYourAccount' }) // replace with your account address
      .on('receipt', function (receipt) {
        console.log(receipt);
      })
      .on('confirmation', function (confirmationNumber, receipt) {
        console.log('Confirmation number: ', confirmationNumber);
        console.log('Receipt: ', receipt);
      })
      .on('error', function (error, receipt) {
        console.log('Error: ', error);
        console.log('Receipt: ', receipt);
      });
  } else {
    console.log('Web3 is not detected. Please install MetaMask or another web3 provider.');
  }
});
