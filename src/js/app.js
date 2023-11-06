document.getElementById('hrChainForm').addEventListener('submit', function(e) {
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

  // Here you can call the functions of your smart contract using web3.js
  // For example:
  // var contract = new web3.eth.Contract(abi, contractAddress);
  // contract.methods.register_client(name, userID, info, docCount, stageAcc, docInfo, timestamp, hash, signature).send({from: '0xYourAccount'});
});
