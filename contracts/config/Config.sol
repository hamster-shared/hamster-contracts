// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract Config is Initializable {

    //Distribution proportion
    uint allocationProportion;

    //graph staking contract address
    address graphStakingAddress;

    //GRT token contract address
    address grtTokenAddress;

    //Retrieve the thawing time of hammer coin
    uint256 thawingTime;

    function initialize() public initializer {
    }

    //Set configuration information
    function setConfigInfo(uint256 _allocationProportion, address _graphStakingAddress, address _grtTokenAddress, uint256 _thawingTime) public {
        allocationProportion = _allocationProportion;
        graphStakingAddress = _graphStakingAddress;
        grtTokenAddress = _grtTokenAddress;
        thawingTime = _thawingTime;
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

    function getThawingTime() public view returns(uint256) {
        return thawingTime;
    }
}
