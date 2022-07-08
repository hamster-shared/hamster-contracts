// SPDX-License-Identifier: GPL-2.0-or-later

pragma solidity ^0.8.0;
pragma abicoder v2;

import "./IStakingData.sol";

interface IStaking is IStakingData {
    // -- Allocation Data --

    /**
     * @dev Possible states an allocation can be
     * States:
     * - Null = indexer == address(0)
     * - Active = not Null && tokens > 0
     * - Closed = Active && closedAtEpoch != 0
     * - Finalized = Closed && closedAtEpoch + channelDisputeEpochs > now()
     * - Claimed = not Null && tokens == 0
     */
    enum AllocationState {
        Null,
        Active,
        Closed,
        Finalized,
        Claimed
    }

    // -- Operation --

    function setOperator(address _operator, bool _allowed) external;


    // -- Staking --

    function stake(uint256 _tokens) external;

    function setRewardsDestination(address _destination) external;
    function unstake(uint256 _tokens) external;

    function withdraw() external;

}
