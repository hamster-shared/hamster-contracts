const HamsterCoin = artifacts.require("HamsterCoin")
const GrtToken = artifacts.require("GrtToken")
const Config = artifacts.require("Config")
const HamsterPool = artifacts.require("HamsterPool")
const StakingProxyFactory = artifacts.require("StakingProxyFactory")
const Staking = artifacts.require("Staking")

const { deployProxy } = require('@openzeppelin/truffle-upgrades')

module.exports = async function (deployer) {
  const hamsterCoinInstance = await deployProxy(HamsterCoin, { deployer });
  console.log('hamsterCoinAddress', hamsterCoinInstance.address);

  const configInstance = await deployProxy(Config, { deployer });
  console.log('configAddress', configInstance.address);

  const hamsterPoolInstance = await deployProxy(HamsterPool, [configInstance.address,hamsterCoinInstance.address], { deployer });
  console.log('hamsterPoolAddress', hamsterPoolInstance.address);

  const stakingProxyFactoryInstance = await deployProxy(StakingProxyFactory, [configInstance.address,hamsterPoolInstance.address], { deployer });
  console.log('stakingProxyFactoryAddress', stakingProxyFactoryInstance.address);

  //mock
  const grtToken = await deployer.deploy(GrtToken);
  console.log('grtTokenAddress',grtToken.address)
  const staking = await deployer.deploy(Staking, grtToken.address);
  console.log('stakingAddress',staking.address)
};
