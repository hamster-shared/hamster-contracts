// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IHamsterPoolV2 {

    function staking(address _account,uint256 _tokens) external;

    function distributionGrt(address _proxyStakingContract, uint256 _tokens) external;

    function withdraw(address _account,uint256 _tokens) external;

    function hamsterBalance() external view returns(uint256);

    function grtBalance() external view returns(uint256);

    function getPoolAddress() external view  returns(address);

    function withdrawGrt(address _account) external;

    function getAccountGrt(address _account) external view  returns(uint256);

    function getStakingBalance(address _account) external view returns(uint256);

    function getUnallocatedAmount() external view returns(uint256);
}
