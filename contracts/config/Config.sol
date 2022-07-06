// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Config {

    //Distribution proportion
    uint allocationProportion;

    //graph staking contract address
    address graphStakingAddress;

    //GRT token contract address
    address grtTokenAddress;

    //Set configuration information
    function setConfigInfo(uint256 _allocationProportion, address _graphStakingAddress, address _grtTokenAddress) public {
        allocationProportion = _allocationProportion;
        graphStakingAddress = _graphStakingAddress;
        grtTokenAddress = _grtTokenAddress;
    }

    //get graph staking address
    function getGraphStakingAddress() public view returns(address) {
        return graphStakingAddress;
    }

    function getGrtTokenAddress() public view returns(address) {
        return grtTokenAddress;
    }

    function getAllocationProportion() public view returns(uint) {
        return allocationProportion;
    }
}
