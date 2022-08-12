const { upgradeProxy } = require('@openzeppelin/truffle-upgrades');

const HamsterPool = artifacts.require('HamsterPool');
const HamsterPoolV2 = artifacts.require('HamsterPoolV2');

module.exports = async function (deployer) {
  const existing = await HamsterPool.deployed();
  const instance = await upgradeProxy(existing.address, HamsterPoolV2,{ deployer });
  console.log("Upgraded", instance.address);
};
