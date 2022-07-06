pragma solidity ^0.8.0;

contract Config {

    //Distribution proportion
    uint allocationProportion;

    //graph staking contract address
    address graphStakingAddress;

    //GRT token contract address
    address grtTokenAddress;

    address rewardsContractAddress;

    //Set configuration information
    function setConfigInfo(uint256 _allocationProportion, address _graphStakingAddress, address _grtTokenAddress, address _rewardsContractAddress) {
        allocationProportion = _allocationProportion;
        graphStakingAddress = _graphStakingAddress;
        grtTokenAddress = _graphStakingAddress;
        rewardsContractAddress = _rewardsContractAddress;
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

    function getRewardsAddress() public view returns(address) {
        return rewardsContractAddress;
    }
}
