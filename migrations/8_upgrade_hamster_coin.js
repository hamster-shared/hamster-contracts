const { upgradeProxy } = require('@openzeppelin/truffle-upgrades');

const HamsterCoin = artifacts.require('HamsterCoin');
const HamsterCoinV2 = artifacts.require('HamsterCoinV2');

module.exports = async function (deployer) {
  const existing = await HamsterCoin.deployed();
  const instance = await upgradeProxy(existing.address, HamsterCoinV2,{ deployer });
  console.log("Upgraded", instance.address);
};
