// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./StakingDistributionProxy.sol";
import "../lib/SafeMath.sol";
import "./IStakingProxyFactory.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract StakingProxyFactory is IStakingProxyFactory,Initializable{
    using SafeMath for uint256;

    // indexer address => staking contract address
    mapping(address => address) stakingAddress;


    address private configAddress;

    address private hamsterPoolAddress;


    function initialize(address _configAddress,address _hamsterPoolAddress) public initializer {
        configAddress = _configAddress;
        hamsterPoolAddress = _hamsterPoolAddress;
    }

    //new staking distribution contract
    function createStakingContract(address _indexerWalletAddress) public override{
        require(stakingAddress[_indexerWalletAddress] == address(0), "This address has been pledged");
        StakingDistributionProxy stakingDistribution = new StakingDistributionProxy(_indexerWalletAddress);
        stakingAddress[_indexerWalletAddress] = stakingDistribution.getProxyAddress();
        stakingDistribution._init(configAddress,hamsterPoolAddress);
    }

    function getStakingAddress(address _indexerWalletAddress) public view override returns (address) {
        return stakingAddress[_indexerWalletAddress];
    }

}
