// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract MockMintable is AccessControl
{
    /**
     * Keep track of mints.
     */
    mapping(address => uint256) public minted;

    /**
     * Constructor.
     */
    constructor()
    {
        // give contract creator admin role.
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    /**
     * Mint.
     */
    function mint(address to, uint256 quantity) external
    {
        // increment minted
        minted[to] += quantity;
    }
}
