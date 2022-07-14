const Config = artifacts.require("Config")
const HamsterPool = artifacts.require("HamsterPool")
const StakingProxyFactory = artifacts.require("StakingProxyFactory")


const { deployProxy } = require('@openzeppelin/truffle-upgrades')

module.exports = async function (deployer) {
  const configInstance = await Config.deployed()
  console.log("configAddress",configInstance.address)
  const hamsterPoolInstance = await HamsterPool.deployed()
  console.log("hamsterPoolAddress",hamsterPoolInstance.address)

  const stakingProxyFactoryInstance = await deployProxy(StakingProxyFactory, [configInstance.address,hamsterPoolInstance.address], { deployer });
  console.log('stakingProxyFactoryAddress', stakingProxyFactoryInstance.address);


};
