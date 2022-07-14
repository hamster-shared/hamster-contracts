const {sendAndAwait} = require("truffle/build/7941.bundled");

const GrtToken = artifacts.require("GrtToken")
const Staking = artifacts.require("Staking")

module.exports = async function (deployer) {
  //mock
  await deployer.deploy(GrtToken);
  console.log('grtTokenAddress', GrtToken.address)
  await deployer.deploy(Staking, GrtToken.address);
  console.log('stakingAddress', Staking.address)
};
