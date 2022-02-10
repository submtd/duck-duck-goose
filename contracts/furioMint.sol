// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract furioMint is AccessControl
{
    /**
     * Signer.
     */
    address private _signer;

    /**
     * Target contract address.
     */
    address public target;

   /**
    * Active.
    */
    bool public active;

    /**
     * Keep track of mints.
     */
    mapping(bytes32 => uint256) private _minted;

    /**
     * Use versioning to erase all minted mappings.
     */
    uint256 private _mintVersion = 1;

    /**
     * Version type.
     */
    bytes32 public mintType;

    /**
     * Version price.
     */
    uint256 public mintPrice;

    /**
     * Constructor.
     */
    constructor()
    {
        // assign contract creator to _signer.
        _signer = _msgSender();
    }

    /**
     * Mint event
     */
    event Minted(address minter, uint256 quantity);

    /**
    * Update mint.
    * This increments the mint version so that we can effectively
    * remove all previous mints. This will allow us to use this
    * contract to handle different self minting events such as
    * whitelist minting, presale minting, airdrops, etc.
    */
    function newMintVersion(bytes32 _mintType, uint256 _mintPrice) external onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _mintVersion++;
        mintType = _mintType;
        mintPrice = _mintPrice;
    }

    /**
     * Get key for mint mapping.
     */
    function getMintedKey(address _address) internal view returns(bytes32)
    {
        return keccak256(abi.encodePacked(_mintVersion, _address));
    }

    /**
     * Public mint.
     */
    function mint(uint256 quantity) external payable
    {
        require(mintType == 'public', 'PUBLIC MINT IS NOT ACTIVE');
        _mint(_msgSender(), quantity, mintPrice);
    }

    /**
     * Restricted mint.
     */
    function mint(bytes memory signature, uint256 quantity) external payable
    {
        require(mintType != 'public', 'PUBLIC MINT IS ACTIVE');
        bytes32 messageHash = sha256(abi.encode(_msgSender(), quantity, _mintVersion));
        require(ECDSA.recover(messageHash, signature) == _signer, 'INVALID SIGNATURE');
        _mint(_msgSender(), quantity, mintPrice);
    }

    /**
     * Mint
     */
    function _mint(address to, uint256 quantity, uint256 price) internal
    {
        require(msg.value == quantity * price, 'INCORRECT VALUE');
        mintable(target).mint(to, quantity);
        _minted[getMintedKey(to)] += quantity;
        emit Minted(to, quantity);
    }
}

interface mintable
{
    function mint(address to, uint256 quantity) external;
}
