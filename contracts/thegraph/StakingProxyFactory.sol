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

    //new staking distribution contract
    function createStakingContract(address _indexerWalletAddress) {
        require(stakingAddress[_indexerWalletAddress] != address(0), "This address has been pledged");
        require(_amount >= 100000,"Minimum pledge 100000 GRT");
        StakingDistribution stakingDistribution = new StakingDistribution;
        stakingDistribution.setIndexerAddress(_indexerWalletAddress);
        stakingAddress[_indexerWalletAddress] = stakingDistribution;
    }

    function staking(address _indexerAccount,uint256 _tokens) {
        StakingDistribution proxyContract = StakingDistribution(stakingAddress[_indexerAccount]);
        proxyContract.staking(_tokens);
    }

    function reStaking(address _account,uint256 _tokens) {
        StakingDistribution proxyContract = StakingDistribution(stakingAddress[_account]);
        proxyContract.rePledge(_tokens);
    }

    function withdrawIncome(address _account,address _allocationID, bytes32 _poi) {
        StakingDistribution proxyContract = StakingDistribution(stakingAddress[_account]);
        proxyContract.withdrawIncome(_allocationID,_poi);
    }

    function retrieveStaking(address _account,uint256 _tokens) {
        StakingDistribution proxyContract = StakingDistribution(stakingAddress[_account]);
        proxyContract.retrieveStaking(_tokens);
    }

    function setOperator(address _account,address _operator, bool _allowed) {
        StakingDistribution proxyContract = StakingDistribution(stakingAddress[_account]);
        proxyContract.setOperator(_operator,_allowed);
    }

    function hamsterStaking(address _account,uint256 _tokens) {
        _hamsterPoolContract.staking(_account,_tokens);
    }

    function hamsterIncomeWithdraw(address _account) {
        _hamsterPoolContract.withdraw(_account);
    }

}
