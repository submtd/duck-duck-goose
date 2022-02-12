// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FurioToken is ERC20
{
    constructor() ERC20('Furio', 'FURIO') {}
}
