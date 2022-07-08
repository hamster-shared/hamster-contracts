pragma solidity ^0.8.0;
import "../thegraph/IStaking.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Staking is IStaking{

    address grtToken;

    mapping(address => uint256) stakingInfo;

    event Log(string);
    event Log(uint256);
    event Log(address);

    constructor (address _grtAddress) {
        grtToken = _grtAddress;
    }

    function stake(uint256 _tokens) external override {
        emit Log("staking before");
        uint256 amount = IERC20(grtToken).balanceOf(address(this));
        emit Log(amount);
        IERC20(grtToken).transferFrom(msg.sender,address(this),_tokens);
        stakingInfo[msg.sender] = stakingInfo[msg.sender] + _tokens;
        emit Log("staking after");
        uint256 amountBack = IERC20(grtToken).balanceOf(address(this));
        emit Log(amountBack);
    }

    function withdraw() external override  {
        uint256 withdrawToken = stakingInfo[msg.sender];
        IERC20(grtToken).transfer(msg.sender,withdrawToken);
        stakingInfo[msg.sender] = 0;
    }

    function unstake(uint256 _tokens) external override  {
        emit Log("unstake:");
        emit Log(_tokens);
    }


    function setOperator(address _operator, bool _allowed) external override {
        emit Log("set operate:");
        emit Log(_operator);
    }

    function setRewardsDestination(address _destination) external override {
        emit Log("set rewards address:");
        emit Log(_destination);
    }
}
