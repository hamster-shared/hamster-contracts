// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../config/Config.sol";
import "./IStaking.sol";
import "./IHamsterPool.sol";

contract StakingDistribution {
    using SafeMath for uint256;
    // indexer wallet address
    address indexerWalletAddress;
    //staking amount
    uint256 stakingAmount;

    //the graph staking address
    address graphStakingAddress;

    Config private _configContract;

    IHamsterPool private _hamsterPoolContract;


    function _init(address _configContractAddress,address _hamsterPoolAddress) public {
        _configContract = Config(_configContractAddress);
        _hamsterPoolContract = IHamsterPool(_hamsterPoolAddress);
    }

    //construction?
    constructor (address _indexerWalletAddress) payable {
        indexerWalletAddress = _indexerWalletAddress;
    }


    //save indexer staking address
    function setIndexerAddress(address _indexerWalletAddress) public {
        indexerWalletAddress = _indexerWalletAddress;
    }

    //set staking amount
    function setStakingAmount(uint256 _stakingAmount) public {
        stakingAmount = _stakingAmount;
    }

    // get proxy staking address
    function getProxyAddress() public view returns (address) {
        return address(this);
    }

    function getStakingAmount() public view returns(uint256) {
        return stakingAmount;
    }

    // get proxy contract address balance
    function getBalance() public view  returns(uint256) {
        address grtAddress = _configContract.getGrtTokenAddress();
        return IERC20(grtAddress).balanceOf(address(this));
    }

    //Deposit GRT to this contract address and staking
    function staking(uint256 _stakingAmount) public {
        require(_stakingAmount > 0,"!tokens");
        address grtAddress = _configContract.getGrtTokenAddress();
        require(IERC20(grtAddress).balanceOf(indexerWalletAddress) >= _stakingAmount,"Insufficient account balance");
        bool approve = IERC20(grtAddress).approve(_configContract.getGraphStakingAddress(),_stakingAmount);
        require(approve == true,"approve failed");
        //Transfer the GRT of indexer wallet to the address of this contract
        require(IERC20(grtAddress).transferFrom(indexerWalletAddress,address(this),_stakingAmount),"staking: indexer transfer failed");
        IERC20(grtAddress).approve(_configContract.getGraphStakingAddress(),_stakingAmount);
        IStaking graphStaking = IStaking(_configContract.getGraphStakingAddress());
        graphStaking.stake(_stakingAmount);
        stakingAmount = _stakingAmount;
        graphStaking.setOperator(indexerWalletAddress,true);
        graphStaking.setRewardsDestination(address(this));
    }

    function rePledge(uint256 _stakingAmount) public {
        require(_stakingAmount > 0,"!tokens");
        address grtAddress = _configContract.getGrtTokenAddress();
        require(IERC20(grtAddress).balanceOf(indexerWalletAddress) >= _stakingAmount,"Insufficient account balance");
        bool approve = IERC20(grtAddress).approve(_configContract.getGraphStakingAddress(),_stakingAmount);
        require(approve == true,"approve failed");
        //Transfer the GRT of indexer wallet to the address of this contract
        require(IERC20(grtAddress).transferFrom(indexerWalletAddress,address(this),_stakingAmount),"staking: indexer transfer failed");
        IERC20(grtAddress).approve(_configContract.getGraphStakingAddress());

        IStaking graphStaking = IStaking(_configContract.getGraphStakingAddress());
        graphStaking.stake(_stakingAmount);
        stakingAmount = stakingAmount + _stakingAmount;
    }



    //Receive income
    function withdrawIncome(address _allocationID, bytes32 _poi) public {
        IStaking graphStaking = IStaking(_configContract.getGraphStakingAddress());
        // close allocation
        // graphStaking.closeAllocation(_allocationID,_poi);
        address grtAddress = _configContract.getGrtTokenAddress();
        uint256 amounts = IERC20(grtAddress).balanceOf(address(this)) - stakingAmount;
        require(amounts > 0,"No income to receive");
        uint256 proportion = _configContract.getAllocationProportion();
        uint256 poolAmount = amounts.mul(proportion).div(100);
        require(IERC20(grtAddress).transferFrom(address(this),indexerWalletAddress,(amounts - poolAmount)));
        //transfer to hamster pool
        _hamsterPoolContract.distributionGrt(address(this),poolAmount);
    }

    //Withdrawal of pledge
    function retrieveStaking(uint256 _tokens) public {
        require(_tokens <= stakingAmount,"withdraw amount > staking amount");
        uint256 tokens = IERC20(_configContract.getGrtTokenAddress()).balanceOf(address(this));
        require(tokens >=_tokens,"withdraw staking failed");
        IStaking graphStaking = IStaking(_configContract.getGraphStakingAddress());
        graphStaking.unstake(_tokens);
        graphStaking.withdraw();
        require(IERC20(_configContract.getGrtTokenAddress()).transferFrom(address(this),indexerWalletAddress,_tokens),"withdraw transfer indexer failed");
        stakingAmount = stakingAmount - _tokens;
    }

    //set operator
    function setOperator(address _operator, bool _allowed) public {
        IStaking graphStaking = IStaking(_configContract.getGraphStakingAddress());
        graphStaking.setOperator(_operator,_allowed);
    }

    function setRewardsDestination() public {
        IStaking graphStaking = IStaking(_configContract.getGraphStakingAddress());
        graphStaking.setRewardsDestination(address(this));
    }
}
