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
    uint256 public hatchCycleMinimum = 5;
    uint256 public hatchCycle = hatchCycleMinimum;
    uint256 public hatchCycleMaximum = 500;

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
    event GooseHatched(uint256 goose, address gooseOwner, uint256 prize);

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
        if(hatchCycle > hatchCycleMaximum) {
            hatchCycle = hatchCycleMinimum;
        }
        // pay the goose owner for their trouble!
        address gooseOwner = ownerOf(hatchedGoose);
        payable(gooseOwner).transfer(prizeBank);
        // tell the world we have a new goose.
        emit GooseHatched(hatchedGoose, gooseOwner, prizeBank);
        // pay the contract owner some rent.
        payable(owner()).transfer(_ownerBank);
        // reset banks.
        prizeBank = 0;
        _ownerBank = 0;
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
     * Set hatch cycle minimum.
     */
    function setHatchCycleMinimum(uint256 _cycle) external onlyOwner {
        hatchCycleMinimum = _cycle;
    }

    /**
     * Set hatch cycle maximum.
     */
    function setHatchCycleMaximum(uint256 _cycle) external onlyOwner {
        hatchCycleMaximum = _cycle;
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
        string memory breed = 'Egg';
        if(items[_tokenId] == itemType.duck) {
            breed = 'Duck';
        }
        if(items[_tokenId] == itemType.goose) {
            breed = 'Goose';
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
                            //svg(_tokenId),
                            'data:image/svg+xml;base64,',
                            Base64.encode(bytes(svg(_tokenId))),
                            //image,
                            '","attributes":',
                            abi.encodePacked(
                                '[{"trait_type":"Breed","value":"',
                                breed,
                                '"},{"trait_type":"Foreground","value":"',
                                foreground(_tokenId),
                                '"},{"trait_type":"Background","value":"',
                                background(_tokenId),
                                '"},{"trait_type":"Generation","value":"',
                                Strings.toString(generations[_tokenId]),
                                '"}]'
                            ),
                            '}'
                        )
                    )
                )
            )
        );
    }

    /**
     * Background color from token id.
     */
    function background(uint256 _tokenId) internal pure returns(string memory) {
        uint red = (_tokenId % 150) + 55;
        uint green = ((_tokenId % 7) * 18) + 79;
        uint blue = ((_tokenId % 3) * 40) + 85;
        return string(abi.encodePacked(
            'rgb(',Strings.toString(red),',',Strings.toString(green),',',Strings.toString(blue),')'
        ));
    }

    /**
     * Foreground color from token id.
     */
    function foreground(uint256 _tokenId) internal view returns(string memory) {
        uint red = (_tokenId % 45) + 175;
        uint green = 255 - ((_tokenId % 5) * 6);
        uint blue = 255;
        if(items[_tokenId] == itemType.duck) {
            red = (_tokenId % 25) + 230;
            green = 255 - ((_tokenId % 5) * 6);
            blue = 66;
        }
        if(items[_tokenId] == itemType.goose) {
            red = ((_tokenId % 8) * 3) + 231;
            green = (_tokenId % 25) + 230;
            blue = 255 - ((_tokenId % 5) * 5);
        }
        return string(abi.encodePacked(
            'rgb(',Strings.toString(red),',',Strings.toString(green),',',Strings.toString(blue),')'
        ));
    }

    /**
     * Make SVG
     */
    function svg(uint256 _tokenId) internal view returns(string memory) {
        return string(abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="350" height="350" viewBox="0 0 350 350">',
            '<rect width="100%" height="100%" fill="',background(_tokenId),'"/>',
            '<circle cx="175" cy="175" r="100" fill="',foreground(_tokenId),'"/>',
            '</svg>'
        ));
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
