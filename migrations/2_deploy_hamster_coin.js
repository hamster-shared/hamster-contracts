const HamsterCoin = artifacts.require("HamsterCoin")

const { deployProxy } = require('@openzeppelin/truffle-upgrades')

module.exports = async function (deployer) {
  const hamsterCoinInstance = await deployProxy(HamsterCoin, { deployer });
  console.log('hamsterCoinAddress', hamsterCoinInstance.address);

  //mock
  // const grtToken = await deployer.deploy(GrtToken);
  // console.log('grtTokenAddress',grtToken.address)
  // const staking = await deployer.deploy(Staking, grtToken.address);
  // console.log('stakingAddress',staking.address)
};
