const HamsterCoin = artifacts.require("HamsterCoin")

module.exports = function(deployer) {
  deployer.deploy(HamsterCoin);
};
