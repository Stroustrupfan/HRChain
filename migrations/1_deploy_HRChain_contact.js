var HRChainData = artifacts.require("../contracts/HRChain.sol");

module.exports = function(deployer) {
  deployer.deploy(HRChainData);
};
