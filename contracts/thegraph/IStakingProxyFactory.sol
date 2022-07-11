// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IStakingProxyFactory {

    function createStakingContract(address _indexerWalletAddress) external;

    function getStakingAddress(address _indexerWalletAddress) external view returns (address);
}
