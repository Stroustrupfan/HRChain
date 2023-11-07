document.getElementById('hrChainForm').addEventListener('submit', function (event) {
  event.preventDefault();  // Prevent the form from being submitted

  // Fill in the form fields
  document.getElementById('name').value = 'Test Name';
  document.getElementById('userID').value = Math.floor(Math.random() * 9999) + 1;  // Random number between 1 and 9999
  document.getElementById('info').value = 'Test Info';
  document.getElementById('docCount').value = Math.floor(Math.random() * 9999);  // Random number between 0 and 9999
  document.getElementById('stageAcc').value = Math.floor(Math.random() * 9999);  // Random number between 0 and 9999
  document.getElementById('docInfo').value = 'Test Document Info';
  document.getElementById('timestamp').value = Date.now();
  document.getElementById('hash').value = '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef';  // Example hash
  document.getElementById('signature').value = 'Test Signature';

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
    var contractJson = require('../HR_Chain.json');

    var abi = contractJson.abi;
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