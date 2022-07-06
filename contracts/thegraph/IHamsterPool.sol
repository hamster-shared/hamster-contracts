// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IHamsterPool {

    function staking(address _account,uint256 _tokens) external;

    function distributionGrt(address _proxyStakingContract, uint256 _tokens) external;

    function withdraw(address _account) external;

    function hamsterBalance() external view returns(uint256);

    function grtBalance() external view returns(uint256);
}
