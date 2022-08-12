const { upgradeProxy } = require('@openzeppelin/truffle-upgrades');

const StakingProxyFactory = artifacts.require('StakingProxyFactory');
const StakingProxyFactoryV2 = artifacts.require('StakingProxyFactory');

module.exports = async function (deployer) {
  const existing = await StakingProxyFactory.deployed();
  const instance = await upgradeProxy(existing.address, StakingProxyFactoryV2,{ deployer });
  console.log("Upgraded", instance.address);
};
