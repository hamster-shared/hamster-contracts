const HamsterCoin = artifacts.require("HamsterCoin")
const Config = artifacts.require("Config")
const HamsterPool = artifacts.require("HamsterPool")
const StakingProxyFactory = artifacts.require("StakingProxyFactory")


module.exports = function(deployer) {
  deployer.deploy(HamsterCoin,100000000000);
  deployer.deploy(Config);
  deployer.deploy(HamsterPool).then( pool =>{
    pool._init(Config.address, HamsterCoin.address)
  })
  deployer.deploy(StakingProxyFactory).then(factory => {
    factory._init(Config.address, HamsterPool.address)
  });

};
