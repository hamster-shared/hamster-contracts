// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../config/Config.sol";
import "./IHamsterPool.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract HamsterPool is IHamsterPool, Initializable {
    using SafeMath for uint256;

    // provider address => staking amount(hamster erc20)
    mapping(address => uint256) hamsterHolderStaking;

    mapping(address => uint256) hamsterHolderWithdrawTime;

    // Total of pledged hammer erc20
    uint256 hamsterTokensAll;

    mapping(address => uint256) distributionStakingMap;

    mapping(address => uint256) withdrawGrtMap;

    //Pledge sum used to calculate distribution proportion
    uint256 distributionTokens;

    //staking account array
    address[] stakingAccount;

    Config private _configContract;

    // hamster coin token
    address token;

    //Unallocated amount
    uint256 unallocatedAmount;

    function initialize(address _configAddress, address _hamsterCoinAddress) public initializer {
        _configContract = Config(_configAddress);
        token = _hamsterCoinAddress;
    }


    //staking hamster erc20
    function staking(address _account,uint256 _tokens) public override {
        require(IERC20(token).balanceOf(_account) >= _tokens,"Insufficient account balance");
        require(IERC20(token).transferFrom(_account,address(this),_tokens),"Pledge failed!");
        hamsterHolderStaking[_account] = hamsterHolderStaking[_account] + _tokens;
        distributionStakingMap[_account] = distributionStakingMap[_account] + _tokens;
        hamsterTokensAll = hamsterTokensAll + _tokens;
        distributionTokens = distributionTokens + _tokens;
        bool exist = false;
        for(uint i=0;i<stakingAccount.length;i++) {
            if(stakingAccount[i] == _account) {
                exist = true;
            }
        }
        if(!exist) {
            stakingAccount.push(_account);
        }
        hamsterHolderWithdrawTime[_account] = block.number;
    }

    //distribution GRT income
    function distributionGrt(address _proxyStakingContract, uint256 _tokens) public override {
        address grtAddress = _configContract.getGrtTokenAddress();
        require(IERC20(grtAddress).transferFrom(_proxyStakingContract,address(this),_tokens),"Failed to allocate income");
        if(stakingAccount.length != 0) {
            uint256 allocatedAmount = unallocatedAmount + _tokens;
            for(uint i=0;i<stakingAccount.length;i++) {
                uint256 amount = distributionStakingMap[stakingAccount[i]];
                withdrawGrtMap[stakingAccount[i]] = withdrawGrtMap[stakingAccount[i]] + amount.mul(allocatedAmount).div(distributionTokens);
                distributionStakingMap[stakingAccount[i]] = 0;
            }
            distributionTokens = 0;
            unallocatedAmount = 0;
        } else {
            unallocatedAmount = unallocatedAmount + _tokens;
        }
    }

    //receive grt income
    function withdrawGrt(address _account) public override {
        uint256 amount = withdrawGrtMap[_account];
        require(amount>0,"Zero income");
        address grtAddress = _configContract.getGrtTokenAddress();
        require(IERC20(grtAddress).balanceOf(address(this)) >= amount,"Insufficient fund pool balance");
        //        require(IERC20(grtAddress).approve(_account,amount),"approve failed");
        //        require(IERC20(grtAddress).transfer(_account,amount),"Failed to collect income");
        require(IERC20(grtAddress).transfer(_account,amount),"Failed to collect income");
        withdrawGrtMap[_account] = 0;
    }

    // Receive staking hamster
    function withdraw(address _account,uint256 _tokens) public override {
        uint256 stakingAmount = hamsterHolderStaking[_account];
        require(stakingAmount > 0, "No pledge amount can be collected");
        require(stakingAmount >= _tokens,"The received amount exceeds the pledged amount");
        uint256 thawingPeriod = hamsterHolderWithdrawTime[_account];
        uint256 configTime = _configContract.getThawingTime();
        require((block.number - thawingPeriod) > configTime,"Pledge cannot be retrieved within the freezing period");
        require(IERC20(token).transfer(_account,_tokens),"transfer failed!");
        if (_tokens == stakingAmount) {
            hamsterHolderStaking[_account] = 0;
            hamsterHolderWithdrawTime[_account] = 0;
        } else {
            hamsterHolderStaking[_account] = hamsterHolderStaking[_account] - _tokens;
        }
    }

    function hamsterBalance() public view override returns(uint256) {
        return IERC20(token).balanceOf(address(this));
    }

    function grtBalance() public view override returns(uint256) {
        address grtAddress = _configContract.getGrtTokenAddress();
        return IERC20(grtAddress).balanceOf(address(this));
    }

    function getPoolAddress() public view override returns(address) {
        return address(this);
    }


    function getAccountGrt(address _account) public view override returns(uint256) {
        return withdrawGrtMap[_account];
    }

    function getStakingBalance(address _account) public view override returns(uint256) {
        return hamsterHolderStaking[_account];
    }

    function getUnallocatedAmount() public view returns(uint256) {
        return unallocatedAmount;
    }
}
