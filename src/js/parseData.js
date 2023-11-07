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
  
    // Call the function from web3SetUp.js
    registerClient(name, userID, info, docCount, stageAcc, docInfo, timestamp, hash, signature);
  });
  