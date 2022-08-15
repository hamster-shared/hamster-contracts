// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IStakingDistribution {

    function setIndexerAddress(address _indexerWalletAddress) external;

    function getProxyAddress() external view returns (address);

    function getStakingAmount() external view returns(uint256);

    function getBalance() external view  returns(uint256);

    function staking(uint256 _stakingAmount) external;

    function rePledge(uint256 _stakingAmount) external;

    function withdrawIncome() external;

    function retrieveStaking(uint256 _tokens) external;

    function setOperator(address _operator, bool _allowed) external;

    function gainIncome() external view returns(uint256);

    function unstake(uint256 _tokens) external;

    function getUnStakingAmount() external view returns(uint256);

    function withdraw() external;
}
