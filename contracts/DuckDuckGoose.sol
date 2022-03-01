// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract DuckDuckGoose is Ownable, ERC721 {
    /**
     * Item types.
     * @dev all items start out as an egg, then become either a duck or a goose.
     */
    enum itemType {
        egg,
        duck,
        goose
    }

    /**
     * Items.
     * @dev this contains all minted items and what type they are.
     */
    mapping(uint256 => itemType) public items;

    /**
     * Egg image.
     * @dev Base64 encoded image of an egg.
     */
    string public egg = 'data:image/png;base64,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';

    /**
     * Duck image.
     * @dev Base64 encoded image of a duck.
     */
    string public duck = 'data:image/png;base64,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';

    /**
     * Goose image.
     * @dev Base64 encoded image of a goose.
     */
    string public goose = 'data:image/png;base64,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';

    /**
     * Egg count.
     * @dev how many eggs are there currently?
     */
    uint256 public eggs = 0;

    /**
     * Duck count.
     * @dev how many ducks are there currently?
     */
    uint256 public ducks = 0;

    /**
     * Goose count.
     * @dev how many geese are there currently?
     */
    uint256 public geese = 0;

    /**
     * Hatch cycle.
     * @dev every XX mints, all eggs will hatch and one of those will
     * be a goose while the others are ducks.
     */
    uint256 public hatchCycle = 1;

    /**
     * Generation.
     * @dev the current egg generation.
     */
    uint256 public generation = 1;

    /**
     * Generations.
     * @dev keep track of which items belong to which generation.
     */
    mapping(uint256 => uint256) public generations;

    /**
     * Goose prize percentage.
     * @dev when a goose is hatched, the owner recieves this
     * percent of the value of all mints duing that
     * hatch cycle.
     */
    uint256 public goosePrizePercentage = 90;

    /**
     * Price.
     * @dev this is how much each NFT costs to mint.
     */
    uint256 public price = 1000000000000000;

    /**
     * Prize bank.
     * @dev this is how much prize money the next goose will win.
     */
    uint256 public prizeBank = 0;

    /**
     * Owner bank.
     * @dev this amount goes to the contract owner when a goose is hatched.
     */
    uint256 private _ownerBank = 0;

    /**
     * Token id tracker.
     * @dev how many tokens have been minted.
     */
    uint256 private _tokenIdTracker;

    /**
     * Constructor.
     */
    constructor() ERC721('Duck, Duck, Goose!', '$DDG') {}

    /**
     * Goose hatched event.
     * @dev this fires when a goose hatches.
     */
    event GooseHatched(uint256 goose);

    /**
     * Mint.
     * @dev mint an egg.
     */
    function mint(uint256 quantity) external payable {
        // check that enough value has been sent.
        require(msg.value >= quantity * price, 'Value is too low');
        for(uint256 i = 0; i < quantity; i++) {
            // calculate prize amount for THIS mint... can't use msg.value because
            // the hatch cycle might trigger before `quantity` is minted.
            uint256 prize = msg.value / quantity / 100 * goosePrizePercentage;
            prizeBank += prize;
            // put the difference in the owner bank.
            _ownerBank += msg.value / quantity - prize;
            // increment the token id tracker.
            _tokenIdTracker++;
            // mint the egg.
            _safeMint(msg.sender, _tokenIdTracker);
            // add the egg to the items mapping.
            items[_tokenIdTracker] = itemType.egg;
            generations[_tokenIdTracker] = generation;
            // increment the egg counter.
            eggs++;
            // check to see if it's time to hatch.
            if(eggs % hatchCycle == 0) {
                hatch();
            }
        }
    }

    /**
     * Hatch.
     * @dev hatch all the eggs and see what comes out.
     */
    function hatch() internal {
        // find the start of the eggs.
        uint256 eggStart = _tokenIdTracker - eggs + 1;
        // pick a random egg to become a goose.
        uint256 hatchedGoose = eggStart + (uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % eggs);
        // loop through eggs and open them up!
        for(uint256 i = eggStart; i <= _tokenIdTracker; i ++) {
            if(i == hatchedGoose) {
                items[i] = itemType.goose;
                geese++;
            } else {
                items[i] = itemType.duck;
                ducks++;
            }
        }
        // reset eggs to zero.
        eggs = 0;
        // increment generation.
        generation++;
        // increment hatch cycle.
        hatchCycle++;
        // pay the goose owner for their trouble!
        payable(ownerOf(hatchedGoose)).transfer(prizeBank);
        // pay the owner some rent.
        payable(owner()).transfer(_ownerBank);
        // reset banks.
        prizeBank = 0;
        _ownerBank = 0;
        // tell the world we have a new goose.
        emit GooseHatched(hatchedGoose);
    }

    /**
     * Total supply.
     * @dev how many items have been minted.
     */
    function totalSupply() public view returns (uint256) {
        return _tokenIdTracker;
    }

    /**
     * Token of owner by index.
     * @dev doing this instead of the openzeppelin way because it saves gas.
     */
    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns(uint256) {
        require(index < ERC721.balanceOf(owner), 'Owner index out of bounds');
        uint256 count = 0;
        for(uint256 i = 1; i <= _tokenIdTracker; i++) {
            if(ownerOf(i) == owner) {
                if(count == index) {
                    return i;
                }
                count++;
            }
        }
        return 0;
    }

    /**
     * Set price.
     */
    function setPrice(uint256 _price) external onlyOwner {
        price = _price;
    }

    /**
     * Set hatch cycle.
     */
    function setHatchCycle(uint256 _cycle) external onlyOwner {
        hatchCycle = _cycle;
    }

    /**
     * Set goose prize percentage.
     */
    function setGoosePrizePercentage(uint256 _percentage) external onlyOwner {
        goosePrizePercentage = _percentage;
    }

    /**
     * Contract URI.
     */
    function contractURI() public pure returns (string memory) {
        return string(
            abi.encodePacked(
                'data:application/json;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"Duck, Duck, Goose!","description":"Play the classic game of Duck, Duck, Goose on the blockchain. Hatch a goose and win a prize!"}'
                        )
                    )
                )
            )
        );
    }

    /**
     * Token URI.
     */
    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        require(_tokenId > 0 && _tokenId <= _tokenIdTracker, 'Token does not exist');
        string memory breed = 'egg';
        string memory image = egg;
        if(items[_tokenId] == itemType.duck) {
            breed = 'duck';
            image = duck;
        }
        if(items[_tokenId] == itemType.goose) {
            breed = 'goose';
            image = goose;
        }
        return string(
            abi.encodePacked(
                'data:application/json;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"Duck, Duck, Goose! #',
                            Strings.toString(_tokenId),
                            '","description":"Play the classic game of Duck, Duck, Goose on the blockchain. Hatch a goose and win a prize!","fee_recipient":"',
                            addressToString(owner()),
                            '","seller_fee_basis_points":"1000","image":"',
                            image,
                            '","attributes":[{"trait_type":"Breed","value":"',
                            breed,
                            '"},{"trait_type":"Generation","value":"',
                            Strings.toString(generations[_tokenId]),
                            '"}]}'
                        )
                    )
                )
            )
        );
    }

    /**
     * Convert address to string.
     */
    function addressToString(address _address) internal pure returns(string memory) {
        bytes32 _bytes = bytes32(uint256(uint160(address(_address))));
        bytes memory HEX = "0123456789abcdef";
        bytes memory _string = new bytes(42);
        _string[0] = '0';
        _string[1] = 'x';
        for(uint i = 0; i < 20; i++) {
            _string[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
            _string[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
        }
        return string(_string);
    }
}
