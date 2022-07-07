// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./StakingDistribution.sol";
import "../lib/SafeMath.sol";
import "./IHamsterPool.sol";

contract StakingProxyFactory {
    using SafeMath for uint256;

    // indexer address => staking contract address
    mapping(address => address) stakingAddress;

    IHamsterPool  private _hamsterPoolContract;

    address private configAddress;

    address private hamsterPoolAddress;


    function _init(address _configAddress,address _hamsterPoolAddress) public {
        configAddress = _configAddress;
        hamsterPoolAddress = _hamsterPoolAddress;
    }

    //new staking distribution contract
    function createStakingContract(address _indexerWalletAddress) public {
        require(stakingAddress[_indexerWalletAddress] != address(0), "This address has been pledged");
        StakingDistribution stakingDistribution = new StakingDistribution(_indexerWalletAddress);
        stakingAddress[_indexerWalletAddress] = stakingDistribution.getProxyAddress();
        stakingDistribution._init(configAddress,hamsterPoolAddress);
    }

}
