// contracts/HamsterCoin.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/presets/ERC20PresetMinterPauserUpgradeable.sol";

contract HamsterCoin is ERC20PresetMinterPauserUpgradeable {

    event TransferToHamster(address indexed from, address indexed to, uint256 value,string polkadotAddress);

    function initialize() public initializer {
        ERC20PresetMinterPauserUpgradeable.initialize("HamsterCoin", "Hamster");
    }

    /**
   * @dev Destroys `amount` tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function burn(uint256 amount,string memory polkadotAddress) public virtual {
        _burn(_msgSender(), amount);
        emit TransferToHamster(_msgSender(), address(0), amount, polkadotAddress);
    }

    /**
    * @dev Returns the decimals places of the token.
     */
    function decimals() public view virtual override returns (uint8) {
        return 12;
    }
}