pragma solidity ^0.8.0;
import "../lib/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../config/Config.sol";
import "./IHamsterPool.sol";
contract HamsterPool is IHamsterPool{
    using SafeMath for uint256;

    // provider address => staking amount(hamster erc20)
    mapping(address => uint256) hamsterHolderStaking;

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



    //staking hamster erc20
    function staking(address _account,uint256 _tokens) {
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
            stakingAccount.push(stakingAccount);
        }
    }

    //distribution GRT income
    function distributionGrt(address _proxyStakingContract, uint256 _tokens) {
        address grtAddress = _configContract.getGrtTokenAddress();
        require(IERC20(grtAddress).transferFrom(_proxyStakingContract,address(this),_tokens),"Failed to allocate income");
        if(stakingAccount.length != 0) {
            for(uint i=0;i<stakingAccount.length;i++) {
                uint256 amount = distributionStakingMap[stakingAccount[i]];
                withdrawGrtMap[stakingAccount[i]] = withdrawGrtMap[stakingAccount[i]] + amount.mul(_tokens).div(distributionTokens);
                distributionStakingMap[stakingAccount[i]] = 0;
            }
            distributionTokens = 0;
        }
    }
    // Receive income
    function withdraw(address _account) {
        uint256 amount = withdrawGrtMap[_account];
        require(amount>0,"Zero income");
        address grtAddress = _configContract.getGrtTokenAddress();
        require(IERC20(grtAddress).balanceOf(address(this) >= amount),"Insufficient fund pool balance");
        require(IERC20(grtAddress).transferFrom(address(this),_account,amount),"Failed to collect income");
        withdrawGrtMap[_account] = 0;
    }

    function hamsterBalance() public view override returns(uint256){
        return IERC20(token).balanceOf(address(this));
    }

    function grtBalance() public view override returns(uint256) {
        address grtAddress = _configContract.getGrtTokenAddress();
        return IERC20(grtAddress).balanceOf(address(this));
    }
}
