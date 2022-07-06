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

    function staking(address _indexerAccount,uint256 _tokens) public {
        require(_tokens >= 100000,"Minimum pledge 100000 GRT");
        StakingDistribution proxyContract = StakingDistribution(stakingAddress[_indexerAccount]);
        proxyContract.staking(_tokens);
    }

    function reStaking(address _account,uint256 _tokens) public {
        StakingDistribution proxyContract = StakingDistribution(stakingAddress[_account]);
        proxyContract.rePledge(_tokens);
    }

    function withdrawIncome(address _account,address _allocationID, bytes32 _poi) public {
        StakingDistribution proxyContract = StakingDistribution(stakingAddress[_account]);
        proxyContract.withdrawIncome(_allocationID,_poi);
    }

    function retrieveStaking(address _account,uint256 _tokens) public {
        StakingDistribution proxyContract = StakingDistribution(stakingAddress[_account]);
        proxyContract.retrieveStaking(_tokens);
    }

    function setOperator(address _account,address _operator, bool _allowed) public {
        StakingDistribution proxyContract = StakingDistribution(stakingAddress[_account]);
        proxyContract.setOperator(_operator,_allowed);
    }

    function hamsterStaking(address _account,uint256 _tokens) public {
        _hamsterPoolContract.staking(_account,_tokens);
    }

    function hamsterIncomeWithdraw(address _account) public {
        _hamsterPoolContract.withdraw(_account);
    }

}
