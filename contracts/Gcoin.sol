// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract GCoin is ERC20, Ownable {
    
    uint256 initialSuppply = 10000000 *10**18;

    constructor() ERC20("GCoin", "GC") {
 
        _mint( msg.sender , initialSuppply);
        
        
    }
    
}