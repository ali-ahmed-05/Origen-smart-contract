// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface ICrowdSale {
    function isNFTbuy(address account) external view returns(bool);
    function _currentRound() external view returns(uint256);
}