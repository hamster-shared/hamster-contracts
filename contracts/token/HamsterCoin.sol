// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract HamsterCoin is ERC20 {
    constructor() ERC20("HamsterCoin","Hamster") {
        _mint(msg.sender,666666);
    }
}
