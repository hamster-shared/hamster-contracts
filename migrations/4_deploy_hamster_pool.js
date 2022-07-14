const HamsterCoin = artifacts.require("HamsterCoin")
const Config = artifacts.require("Config")
const HamsterPool = artifacts.require("HamsterPool")

const { deployProxy } = require('@openzeppelin/truffle-upgrades')

module.exports = async function (deployer) {
  const configInstance = await Config.deployed()
  console.log("configAddress",configInstance.address)
  const hamsterCoinInstance = await HamsterCoin.deployed()
  console.log("hamsterCoinAddress",hamsterCoinInstance.address)

  const hamsterPoolInstance = await deployProxy(HamsterPool, [configInstance.address,hamsterCoinInstance.address], { deployer });
  console.log('hamsterPoolAddress', hamsterPoolInstance.address);
};
