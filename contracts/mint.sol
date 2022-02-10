// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract Mint is AccessControl
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
     * Keep track of mints.
     */
    mapping(bytes32 => uint256) public minted;
    mapping(uint256 => uint256) public totalMinted;

    /**
     * Use versioning to erase all minted mappings.
     */
    uint256 public mintVersion = 1;

    /**
     * Available mint types.
     */
    enum mintTypes { publicMint , restrictedMint }

    /**
     * Mint type.
     */
    mintTypes public mintType;

    /**
     * Mint price.
     */
    uint256 public mintPrice;

    /**
     * Max mint.
     */
    uint256 public mintMax;

    /**
     * Max available.
     */
    uint256 public mintMaxAvailable;

    /**
     * Active.
     */
    bool public mintActive;

    /**
     * Constructor.
     */
    constructor()
    {
        // assign contract creator to _signer.
        _signer = _msgSender();
        // give contract creator admin role.
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    /**
     * Minted event
     */
    event Minted(
        address minter,
        uint256 quantity
    );

    /**
     * Mint updated event
     */
    event MintUpdated(
        address target,
        uint256 mintVersion,
        mintTypes mintType,
        uint256 mintPrice,
        uint256 mintMax,
        uint256 mintMaxAvailable,
        bool mintActive
    );

    /**
     * Public mint.
     */
    function mint(uint256 quantity) external payable
    {
        require(mintType == mintTypes.publicMint, 'PUBLIC MINT IS NOT ACTIVE');
        require(mintActive, 'MINT IS NOT ACTIVE');
        require(minted[_getMintedKey(_msgSender())] + quantity <= mintMax, 'EXCEEDS MAX MINT');
        _mint(_msgSender(), quantity, mintPrice);
    }

    /**
     * Restricted mint.
     */
    function mint(bytes memory signature, uint256 assignedQuantity, uint256 quantity) external payable
    {
        require(mintType != mintTypes.publicMint, 'PUBLIC MINT IS ACTIVE');
        require(mintActive, 'MINT IS NOT ACTIVE');
        require(minted[_getMintedKey(_msgSender())] + quantity <= mintMax, 'EXCEEDS MAX MINT');
        require(quantity <= assignedQuantity, 'EXCEEDS ASSIGNED QUANTITY');
        bytes32 messageHash = sha256(abi.encode(_msgSender(), assignedQuantity, mintVersion));
        require(ECDSA.recover(messageHash, signature) == _signer, 'INVALID SIGNATURE');
        _mint(_msgSender(), quantity, mintPrice);
    }

    /**
     * Admin mint.
     */
    function adminMint(address to, uint256 quantity) external onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _mint(to, quantity, 0);
    }

    /**
     * Mint.
     */
    function _mint(address to, uint256 quantity, uint256 price) internal
    {
        require(totalMinted[mintVersion] + quantity <= mintMaxAvailable, 'EXCEEDS SUPPLY');
        require(msg.value == quantity * price, 'INCORRECT VALUE');
        //mintable(target).mint(to, quantity);
        minted[_getMintedKey(to)] += quantity;
        totalMinted[mintVersion] += quantity;
        emit Minted(to, quantity);
    }

    /**
     * Get minted by address.
     */
    function mintedByAddress(address _address) public view returns(uint256)
    {
        return minted[_getMintedKey(_address)];
    }

    /**
    * New mint version.
    * This increments the mint version so that we can effectively
    * remove all previous mints. This will allow us to use this
    * contract to handle different self minting events such as
    * whitelist minting, presale minting, airdrops, etc.
    */
    function newMintVersion() external onlyRole(DEFAULT_ADMIN_ROLE)
    {
        mintVersion++;
        _fireMintUpdatedEvent();
    }

    /**
     * Set public mint type.
     */
    function setPublicMintType() external onlyRole(DEFAULT_ADMIN_ROLE)
    {
        mintType = mintTypes.publicMint;
        _fireMintUpdatedEvent();
    }

    /**
     * Set restricted mint type.
     */
    function setRestrictedMintType() external onlyRole(DEFAULT_ADMIN_ROLE)
    {
        mintType = mintTypes.restrictedMint;
        _fireMintUpdatedEvent();
    }

    /**
     * Set mint price.
     */
    function setMintPrice(uint256 _mintPrice) external onlyRole(DEFAULT_ADMIN_ROLE)
    {
        mintPrice = _mintPrice;
        _fireMintUpdatedEvent();
    }

    /**
     * Set max mint.
     */
    function setMintMax(uint256 _mintMax) external onlyRole(DEFAULT_ADMIN_ROLE)
    {
        mintMax = _mintMax;
        _fireMintUpdatedEvent();
    }

    /**
     * Set max available.
     */
    function setMintMaxAvailable(uint256 _mintMaxAvailable) external onlyRole(DEFAULT_ADMIN_ROLE)
    {
        mintMaxAvailable = _mintMaxAvailable;
        _fireMintUpdatedEvent();
    }

    /**
     * Activate mint.
     */
    function activateMint() external onlyRole(DEFAULT_ADMIN_ROLE)
    {
        mintActive = true;
        _fireMintUpdatedEvent();
    }

    /**
     * Deactivate mint.
     */
    function deactivateMint() external onlyRole(DEFAULT_ADMIN_ROLE)
    {
        mintActive = false;
        _fireMintUpdatedEvent();
    }

    /**
     * Set target.
     */
    function setTarget(address _target) external onlyRole(DEFAULT_ADMIN_ROLE)
    {
        target = _target;
        _fireMintUpdatedEvent();
    }

    /**
     * Update mint.
     */
    function updateMint(
        uint256 _mintPrice,
        uint256 _mintMax,
        uint256 _mintMaxAvailable,
        bool _mintActive,
        address _target
    ) external onlyRole(DEFAULT_ADMIN_ROLE)
    {
        mintVersion++;
        mintPrice = _mintPrice;
        mintMax = _mintMax;
        mintMaxAvailable = _mintMaxAvailable;
        mintActive = _mintActive;
        target = _target;
        _fireMintUpdatedEvent();
    }

    /**
     * Fire MintUpdated event
     */
    function _fireMintUpdatedEvent() internal
    {
        emit MintUpdated(target, mintVersion, mintType, mintPrice, mintMax, mintMaxAvailable, mintActive);
    }

    /**
     * Get key for mint mapping.
     */
    function _getMintedKey(address _address) internal view returns(bytes32)
    {
        return keccak256(abi.encodePacked(mintVersion, _address));
    }

    /**
     * Update signer.
     */
    function updateSigner(address signer) external onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _signer = signer;
    }
}

interface mintable
{
    function mint(address to, uint256 quantity) external;
}
