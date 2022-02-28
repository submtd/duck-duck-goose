// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract DuckDuckGoose is Ownable, ERC721 {
    using Counters for Counters.Counter;

    /**
     * Duck.
     */
    string duck = 'data:image/png;base64,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';

    /**
     * Goose.
     */
    string goose = 'data:image/png;base64,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';

    /**
     * Geese.
     */
    mapping(uint256 => bool) public geese;

    /**
     * Goose percentage * 100.
     */
    uint256 public goosePercentage = 100;

    /**
     * Goose prize percentage * 100.
     */
    uint256 public goosePrizePercentage = 9000;

    /**
     * Price.
     */
    uint256 public price = 2500000000000000;

    /**
     * Prize bank.
     */
    uint256 public prizeBank = 0;

    /**
     * Owner bank.
     */
    uint256 private _ownerBank = 0;

    /**
     * Token id tracker.
     */
    Counters.Counter private _tokenIdTracker;

    /**
     * Constructor.
     */
    constructor() ERC721('Duck, Duck, Goose!', '$DDG') {}

    /**
     * Goose found event.
     */
    event GooseFound(uint256 goose);

    /**
     * Mint.
     */
    function mint(uint256 quantity) external payable {
        require(msg.value >= quantity * price, 'Value is too low');
        for(uint256 i = 0; i < quantity; i++) {
            uint256 prize = msg.value / quantity / 10000 * goosePrizePercentage;
            prizeBank += prize;
            _ownerBank += msg.value / quantity - prize;
            _tokenIdTracker.increment();
            _safeMint(msg.sender, _tokenIdTracker.current());
            if(_tokenIdTracker.current() % (10000 / goosePercentage) == 0) {
                findGoose();
            }
        }
    }

    /**
     * Find goose.
     */
    function findGoose() internal {
        uint256 foundGoose = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % _tokenIdTracker.current();
        payable(ownerOf(foundGoose)).transfer(prizeBank);
        payable(owner()).transfer(_ownerBank);
        geese[foundGoose] = true;
        prizeBank = 0;
        emit GooseFound(foundGoose);
    }

    /**
     * Total supply.
     */
    function totalSupply() public view returns (uint256) {
        return _tokenIdTracker.current();
    }

    /**
     * Token of owner by index.
     */
    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns(uint256) {
        require(index < ERC721.balanceOf(owner), 'Owner index out of bounds');
        uint256 count = 0;
        for(uint256 i = 1; i <= _tokenIdTracker.current(); i++) {
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
     * Set goose percentage.
     */
    function setGoosePercentage(uint256 _percentage) external onlyOwner {
        goosePercentage = _percentage;
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
                            '{"name":"Duck, Duck, Goose!","description":"Play the classic game of Duck, Duck, Goose on the blockchain. Mint a goose and you might win a prize!"}'
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
        require(_tokenId > 0 && _tokenId <= _tokenIdTracker.current(), 'Token does not exist');
        string memory image = duck;
        if(geese[_tokenId]) {
            image = goose;
        }
        return string(
            abi.encodePacked(
                'data:application/json;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"Duck Duck Goose #',
                            Strings.toString(_tokenId),
                            '","description":"Play the classic game of Duck, Duck, Goose on the blockchain. Mint a goose and you might win a prize!","fee_recipient":"',
                            addressToString(owner()),
                            '","seller_fee_basis_points":"1000","image":"',
                            image,
                            '","attributes":[{"trait_type":"Ticket","value":"',
                            Strings.toString(_tokenId),
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
    function addressToString(address _address) public pure returns(string memory) {
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
