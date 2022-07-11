// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";

contract GrtToken is ERC20PresetMinterPauser{
    uint256 private _INITIAL_SUPPLY = 300000000 ether;
    constructor() ERC20PresetMinterPauser("GRTMock", "Grt") {
        _mint(msg.sender, _INITIAL_SUPPLY);
    }
}
