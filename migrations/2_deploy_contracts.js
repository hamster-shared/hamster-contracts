const HamsterCoin = artifacts.require("HamsterCoin")
const GrtCoin = artifacts.require("GrtToken")
const Config = artifacts.require("Config")
const HamsterPool = artifacts.require("HamsterPool")
const StakingProxyFactory = artifacts.require("StakingProxyFactory")
const Staking = artifacts.require("Staking")

module.exports = function(deployer) {
  deployer.deploy(HamsterCoin);
  deployer.deploy(GrtCoin);
  deployer.deploy(Config);
  deployer.deploy(Staking,GrtCoin.address);
  deployer.deploy(HamsterPool).then( pool =>{
    pool._init(Config.address, HamsterCoin.address)
  })
  deployer.deploy(StakingProxyFactory).then(factory => {
    factory._init(Config.address, HamsterPool.address)
  });

};
