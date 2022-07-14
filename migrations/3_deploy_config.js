const Config = artifacts.require("Config")

const { deployProxy } = require('@openzeppelin/truffle-upgrades')

module.exports = async function (deployer) {
  const configInstance = await deployProxy(Config, { deployer });
  console.log('configAddress', configInstance.address);
};
