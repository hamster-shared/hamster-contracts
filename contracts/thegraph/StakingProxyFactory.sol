// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./StakingDistribution.sol";
import "../lib/SafeMath.sol";

contract StakingProxyFactory {
    using SafeMath for uint256;

    // indexer address => staking contract address
    mapping(address => address) stakingAddress;

    //new staking distribution contract
    function createStakingContract(address _indexerWalletAddress) public {
        require(stakingAddress[_indexerWalletAddress] != address(0), "This address has been pledged");
        StakingDistribution stakingDistribution = new StakingDistribution(_indexerWalletAddress);
        stakingAddress[_indexerWalletAddress] = stakingDistribution.getProxyAddress();
    }

}
