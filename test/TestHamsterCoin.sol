pragma solidity ^0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/token/HamsterCoin.sol";

contract TestMetaCoin {

  function testInitialBalanceUsingDeployedContract() public {
    HamsterCoin meta = HamsterCoin(DeployedAddresses.HamsterCoin());

    uint expected = 666666;

    Assert.equal(meta.balanceOf(tx.origin), expected, "Owner should have 666666 MetaCoin initially");
  }


}
