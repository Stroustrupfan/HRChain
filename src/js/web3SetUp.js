function registerClient(name, userID, info, docCount, stageAcc, docInfo, timestamp, hash, signature) {
    // Check if Web3 has been injected by the browser
    if (typeof window.ethereum !== 'undefined') {
      var Web3 = require('web3');
      var web3 = new Web3(window.ethereum);
      var contractAddress = ""; // replace with your contract address
      var contract = new web3.eth.Contract(abi, contractAddress);
  
      contract.methods.register_client(name, userID, info, docCount, stageAcc, docInfo, timestamp, hash, signature)
        .send({from: '0xYourAccount'}) // replace with your account address
        .on('receipt', function(receipt){
          console.log(receipt);
        })
        .on('confirmation', function(confirmationNumber, receipt){
          console.log('Confirmation number: ', confirmationNumber);
          console.log('Receipt: ', receipt);
        })
        .on('error', function(error, receipt) {
          console.log('Error: ', error);
          console.log('Receipt: ', receipt);
        });
    } else {
      console.log('Web3 is not detected. Please install MetaMask or another web3 provider.');
    }
  }
  