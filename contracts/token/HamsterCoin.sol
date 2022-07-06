// contracts/HamsterCoin.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";

contract HamsterCoin is ERC20PresetMinterPauser {
    constructor(uint256 initialSupply) ERC20PresetMinterPauser("HamsterCoin", "Hamster") {
        _mint(msg.sender, initialSupply);
    }

    event TransferToHamster(address indexed from, address indexed to, uint256 value,string polkadotAddress);

    /**
   * @dev Destroys `amount` tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function burn(uint256 amount,string memory polkadotAddress) public virtual {
        _burn(_msgSender(), amount);
        emit TransferToHamster(_msgSender(), address(0), amount, polkadotAddress);
    }
}