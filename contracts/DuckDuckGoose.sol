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
    string goose = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAWgAAAFoCAYAAAB65WHVAAAAAXNSR0IArs4c6QAAFjZJREFUeF7t3bGSI8cVRFGsIZffzG+mS2MUpKcgJRHInEWi6shGPry62X23hWFE//j96/H18D8EEEAAgTkCPwh6rhMLIYAAAn8SIGgXAgIIIDBKgKBHi7EWAgggQNCuAQQQQGCUAEGPFmMtBBBAgKBdAwgggMAoAYIeLcZaCCCAAEG7BhBAAIFRAgQ9Woy1EEAAAYJ2DSCAAAKjBAh6tBhrIYAAAgTtGkAAAQRGCRD0aDHWQgABBAjaNYAAAgiMEiDo0WKshQACCBC0awABBBAYJUDQo8VYCwEEECBo1wACCCAwSoCgR4uxFgIIIEDQh18D//px+AE/7Hi/ewPohzX23nUJ+r38v/3bCfrbET/1BQT9FK7rP0zQh18CBL1VMEFv9bG+DUGvNxTuR9AhwHKcoMtADx9H0IcXTNBbBRP0Vh/r2xD0ekPhfgQdAizHCboM9PBxBH14wQS9VTBBb/Wxvg1BrzcU7kfQIcBynKDLQA8fR9CHF0zQWwUT9FYf69sQ9HpD4X4EHQIsxwm6DPTwcQR9eMEEvVUwQW/1sb4NQa83FO5H0CHAcpygy0APH0fQhxdM0FsFE/RWH+vbEPR6Q+F+BB0CLMcJugz08HEEfXjBBL1VMEFv9bG+DUGvNxTuR9AhwHKcoMtADx9H0IcXTNBbBRP0Vh/r2xD0ekPhfgQdAizHCboM9PBxBH14wQS9VTBBb/Wxvg1BrzcU7kfQIcBynKDLQA8fR9BjBbeF+vXlJXhLFf/40X1JJOEvtdvfhaD7TKOJBB3hmw8T9HxFUwsS9FQdjwdBjxVSXoegy0APH0fQYwUT9Fgh5XUIugz08HEEPVYwQY8VUl6HoMtADx9H0GMFE/RYIeV1CLoM9PBxBD1WMEGPFVJeh6DLQA8fR9BjBRP0WCHldQi6DPTwcQQ9VjBBjxVSXoegy0APH0fQYwUT9Fgh5XUIugz08HEEPVYwQY8VUl6HoMtADx9H0GMFE/RYIeV1CLoM9PBxBD1WMEGPFVJeh6DLQA8fR9BjBRP0WCHldQi6DPTwcQQ9VjBBjxVSXoegy0APH0fQYwUT9Fgh5XUIugz08HEEPVYwQY8VUl6HoMtADx9H0GMFE/RYIeV1CLoM9PBxBD1WMEGPFVJeh6DLQA8fR9BjBRP0WCHldQi6DPTwcQQdFkyoIUDxiADhR/jmwwQdVkTQIUDxiABBR/jmwwQdVkTQIUDxiABBR/jmwwQdVkTQIUDxiABBR/jmwwQdVkTQIUDxiABBR/jmwwQdVkTQIUDxiABBR/jmwwQdVkTQIUDxiABBR/jmwwQdVkTQIUDxiABBR/jmwwQdVkTQIUDxiABBR/jmwwQdVkTQIUDxiABBR/jmwwQdVkTQIUDxiABBR/jmwwQdVkTQIUDxiABBR/jmwwQdVkTQIUDxiABBR/jmwwQdVkTQIUDxiABBR/jmwwQdVkTQIUDxiABBR/jmwwQdVkTQIUDxiABBR/jmwwQdVkTQIUDxiABBR/jmwwQdVkTQIUDxiABBR/jmwwQdVkTQIUDxiABBR/jmwwQdVkTQIUDxiABBR/jmw/OCbgtwvZGvr6/qiu0buL1f9bCPx8N5M6K/dy+/bBnpB0GPXQRtARJWVnC7j2ybv6bb/RJ0u6FsHkFn/OrpthDaN3B7vzZA582IEnTGr50m6DbRcF5bgISVFdLuI9vGE3Sb3/o8gh5rqC0Egs4KbveRbUPQbX7r8wh6rKG2EAg6K7jdR7YNQbf5rc8j6LGG2kIg6Kzgdh/ZNgTd5rc+j6DHGmoLgaCzgtt9ZNsQdJvf+jyCHmuoLQSCzgpu95FtQ9BtfuvzCHqsobYQCDoruN1Htg1Bt/mtzyPosYbaQiDorOB2H9k2BN3mtz6PoMcaaguBoLOC231k2xB0m9/6PIIea6gtBILOCm73kW1D0G1+6/MIeqyhthAIOiu43Ue2DUG3+a3PI+ixhtpCIOis4HYf2TYE3ea3Po+gxxpqC4Ggs4LbfWTbEHSb3/o8gh5rqC0Egs4KbveRbUPQbX7r8wh6rKG2EAg6K7jdR7YNQbf5rc8j6LGG2kIg6Kzgdh/ZNgTd5rc+j6DHGmoLgaCzgtt9ZNsQdJvf+rzrBP3br91KfinPawuBoLO+231k2xB0+x2l62+QIejwjiHoEGA57h+kDOi6sAg667eebhfiCTqr6LYnytvOS9DZ/dFOe4IOiXqCDgGW456gM6AEnfFrpwk6JErQIcBynKAzoASd8WunCTokStAhwHKcoDOgBJ3xa6cJOiRK0CHAcpygM6AEnfFrpwk6JErQIcBynKAzoASd8WunCTokStAhwHKcoDOgBJ3xa6cJOiRK0CHAcpygM6AEnfFrpwk6JErQIcBynKAzoASd8WunCTokStAhwHKcoDOgBJ3xa6cJOiRK0CHAcpygM6AEnfFrpwk6JErQIcBynKAzoASd8WunCTokStAhwHKcoDOgBJ3xa6cJOiRK0CHAcpygM6AEnfFrpwk6JErQIcBynKAzoASd8WunCTokStAhwHKcoDOgBJ3xa6cJOiRK0CHAcpygM6AEnfFrpwk6JErQIcBynKAzoASd8Wun64JuvwGlfeD1N6q0z2teRsAbVTJ+6z5Y/weJoLPr79F+gg7XES8TIOgMKEFn/Ag640fQIb/1OEFnDRF0xo+gM34EHfJbjxN01hBBZ/wIOuNH0CG/9ThBZw0RdMaPoDN+BB3yW48TdNYQQWf8CDrjR9Ahv/U4QWcNEXTGj6AzfgQd8luPE3TWEEFn/Ag640fQIb/1OEFnDRF0xo+gM34EHfJbjxN01hBBZ/wIOuNH0CG/9ThBZw0RdMaPoDN+BB3yW48TdNYQQWf8CDrjR9Ahv/U4QWcNEXTGj6AzfgQd8luPE3TWEEFn/Ag640fQIb/1OEFnDRF0xo+gM34EHfJbjxN01hBBZ/wIOuNH0CG/9ThBZw0RdMaPoDN+BB3yW48TdNYQQWf8CDrjR9Ahv/U4QWcNEXTGj6AzfgQd8luPE3TWEEFn/OYF3X6HYIZL+jYC7VeatYXffknuer/r/NrvOCTo9SvSfm8lQNBvxf+XLyfosI/2/6XxBB0WIh4RIOgIXz1M0CFSgg4Bik8RIOipOh4EHfZB0CFA8SkCBD1VB0GndRB0SlB+iQBBL7XxIOi0DoJOCcovESDopTYIOm6DoGOEBgwRIOihMh4EHbdB0DFCA4YIEPRQGQSdl0HQOUMTdggQ9E4Xf2ziv+II+yDoEKD4FAGCnqqDoNM6CDolKL9EgKCX2vAEHbdB0DFCA4YIEPRQGX7iyMsg6JyhCTsECHqnC79BF7og6AJEI2YIEPRMFX8u4o+EYR8EHQIUnyJA0FN1EHRaB0GnBOWXCBD0UhueoOM2CDpGaMAQAYIeKsNPHHkZBJ0zNGGHAEHvdOE36EIXBF2AaMQMAYKeqcIfCRtVtAXd2MmMewi038CzLuh7mv2ek7bf6XjdOwm/pxZTTyVA0Kc2+z3nIujv4WoqAn9LgKBdGM8QIOhnaPksAiEBgg4BXhYn6MsKd9z3EiDo9/L/tG8n6E9rzL4fTYCgP7q+n748Qf905L7wZgIEfXP7z5+doJ9nJoHAywQI+mV0VwYJ+sraHfpdBAj6XeQ/83sJ+jN7s/WHEiDoDy3uTWsT9JvA+9o7CRD0nb2/emqCfpWcHAIvECDoF6BdHCHoi8t39J9PgKB/PvNP/kaC/uT27P5xBAj64yp768IE/Vb8vvw2AgR9W+PZeQk64yeNwFMECPopXNd/mKCvvwQA+JkECPpn0v787yLoz+/QCT6IAEF/UFkDqxL0QAlWuIcAQd/TdeOkBN2gaAYC/5AAQf9DUD72J4HrBN3uvf2Ow/YN3D6veVsE2u8k3DqdbdoE5t9J2D4wQbeJmvcMAYJ+hpbPEnR4DXiCDgFeFifoywoPj0vQIUCCDgFeFifoywoPj0vQIUCCDgFeFifoywoPj0vQIUCCDgFeFifoywoPj0vQIUCCDgFeFifoywoPj0vQIUCCDgFeFifoywoPj0vQIUCCDgFeFifoywoPj0vQIUCCDgFeFifoywoPj0vQIUCCDgFeFifoywoPj0vQIUCCDgFeFifoywoPj0vQIUCCDgFeFifoywoPj0vQIUCCDgFeFifoywoPj0vQIUCCDgFeFifoywoPj0vQIUCCDgFeFifoywoPj0vQIUCCDgFeFifoywoPj0vQIUCCDgFeFifoywoPj0vQIUCCDgFeFifoywoPj0vQIUCCDgFeFifoywoPj3udoENef4m3X6HV3s+8LQJfX19bC12+Tfslr22cBB0SJegQ4GVxgt4qnKC3+qhvQ9B1pEcPJOitegl6q4/6NgRdR3r0QILeqpegt/qob0PQdaRHDyTorXoJequP+jYEXUd69ECC3qqXoLf6qG9D0HWkRw8k6K16CXqrj/o2BF1HevRAgt6ql6C3+qhvQ9B1pEcPJOitegl6q4/6NgRdR3r0QILeqpegt/qob0PQdaRHDyTorXoJequP+jYEXUd69ECC3qqXoLf6qG9D0HWkRw8k6K16CXqrj/o2BF1HevRAgt6ql6C3+qhvQ9B1pEcPJOitegl6q4/6NgRdR3r0QILeqpegt/qob0PQdaRHDyTorXoJequP+jYEXUd69ECC3qqXoLf6qG9D0HWkRw8k6K16CXqrj/o2BF1HevRAgt6ql6C3+pjfpi18Qsgqb9/A+ji7j/b14p2E2fVSTxN0HWk0sH3DEXRUx2O9j/Z+BJ1dL/U0QdeRRgPbNxxBR3UQdIbv8eP3r4f3ygcQCTqA9w1Rgv4GqMHI9T7a+3mCDi6W74gS9HdQfX1m+4bzBP16F38k1/to70fQ2fVSTxN0HWk0sH3DEXRUB0Fn+PzEEfJ7EHRKsJsn6C7PdNp6H+39PEGnV0w5T9BloOG49g3nCTorZL2P9n4EnV0v9TRB15FGA9s3HEFHdfiJI8PnJ46Qn584UoDlPEGXgYbj1vto7+cJOrxg2nFP0G2i2bz2DecJ+uw+2tcLQWfXSz1N0HWk0cD2DUfQUR1+4sjw+Ykj5OcnjhRgOU/QZaDhuPU+2vt5gg4vmHbcE3SbaDavfcN5gj67j/b1QtDZ9VJPE3QdaTSwfcMRdFSHnzgyfH7iCPn5iSMFWM4TdBloOG69j/Z+nqDDC6Yd9wTdJprNa99wnqDP7qN9vRB0dr3U0wRdRxoNbN9wBB3V4SeODJ+fOEJ+fuJIAZbzBF0GGo5b76O9nyfo8IJpxz1Bt4lm89o3nCfos/toXy8EnV0v9TRB15FODWzfwFOH+wnLrP8D1+6XoH/CRfXMVxD0M7Q+77PtG/jzCGQbE3TGzyuvMn5+gw75rccJOmuIoDN+BJ3xI+iQ33qcoLOGCDrjR9AZP4IO+a3HCTpriKAzfgSd8SPokN96nKCzhgg640fQGT+CDvmtxwk6a4igM34EnfEj6JDfepygs4YIOuNH0Bk/gg75rccJOmuIoDN+BJ3xI+iQ33qcoLOGCDrjR9AZP4IO+a3HCTpriKAzfgSd8SPokN96nKCzhgg640fQGT+CDvmtxwk6a4igM34EnfEj6JDfepygs4YIOuNH0Bk/gg75rccJOmuIoDN+BJ3xI+iQ33qcoLOGCDrjR9AZP4IO+a3HCTpriKAzfgSd8SPokN96nKCzhgg640fQGT+CDvmtxwk6a4igM34EnfEj6JDfepygs4YIOuNH0Bm/etortOpIDTyIQPsfzPY7BNuoCbpNNJxH0CFA8aMJEPTR9e4fjqD3O7Lh+wgQ9PvY++bHw2/argIE/gcBgnZ5vJWAJ+i34vfl4wQIeryg09cj6NMbdr6EAEEn9GRjAgQdIzTgYAIEfXC5n3A0gv6Eluz4LgIE/S7yvvdPAgTtQkDgvxMgaFfHWwkQ9Fvx+/JxAgQ9XtDp6xH06Q07X0KAoBN6sjEBgo4RGnAwAYI+uNxPOBpBf0JLdnwXAYJ+F3nf64+ErgEE/g8BgnaJvJWAJ+i34vfl4wQIeryg09cj6NMbdr6EAEEn9GRjAgQdIzTgYAIEfXC5n3A0gv6Eluz4LgIE/S7yvtcfCV0DCPgj4X8Q8EaVsVvCE/RYIdaZIuAJeqoOy6QE2sJP95FHICGw/g7B5Gx/l/UE3SY6No+gxwqxTkSAoCN8wmsECHqtEfskBAg6oSc7R4Cg5yqxUECAoAN4onsECHqvExu9ToCgX2cnOUiAoAdLsdLLBAj6ZXSCiwQIerEVO71KgKBfJSc3SYCgJ2ux1IsECPpFcGKbBAh6sxdbvUaAoF/jJjVKgKBHi7HWSwQI+iVsQqsECHq1GXu9QoCgX6EmM0uAoGersdgLBAj6BWgiuwQIercbmz1PgKCfZyYxTICgh8ux2tMECPppZALLBAh6uR27PUuAoJ8l5vPTBAh6uh7LPUmAoJ8E5uPbBAh6ux/bPUeAoJ/j5dPjBAh6vCDrPUWAoJ/C5cPrBAh6vSH7PUOAoJ+h5bPzBAh6viILPkGAoJ+A5aP3EWgL/7dfuwx/Kc9rCwG/bt+nT/NOwtMbLp+PYDKg+GX8bksT9G2Nh+clmAwgfhm/29IEfVvj4XkJJgOIX8bvtjRB39Z4eF6CyQDil/G7LU3QtzUenpdgMoD4ZfxuSxP0bY2H5yWYDCB+Gb/b0gR9W+PheQkmA4hfxu+2NEHf1nh4XoLJAOKX8bstTdC3NR6el2AygPhl/G5LE/RtjYfnJZgMIH4Zv9vSBH1b4+F5CSYDiF/G77Y0Qd/WeHhegskA4pfxuy1N0Lc1Hp6XYDKA+GX8bksT9G2Nh+clmAwgfhm/29IEfVvj4XkJJgOIX8bvtjRB39Z4eF6CyQDil/G7LU3QtzUenpdgMoD4ZfxuSxP0bY2H5yWYDCB+Gb/b0gR9W+PheQkmA4hfxu+2NEEf3vi6ENbxt99x2H4H42382u+IXOdH0OsNhfsRdAaQoLf4EXTWh/QYAYLOCiHoLX4EnfUhPUaAoLNCCHqLH0FnfUiPESDorBCC3uJH0Fkf0mMECDorhKC3+BF01of0GAGCzgoh6C1+BJ31IT1GgKCzQgh6ix9BZ31IjxEg6KwQgt7iR9BZH9JjBAg6K4Sgt/gRdNaH9BgBgs4KIegtfgSd9SE9RoCgs0IIeosfQWd9SI8RIOisEILe4kfQWR/SYwQIOiuEoLf4EXTWh/QYAYLOCiHoLX4EnfUhPUaAoLNCCHqLH0FnfUiPESDorBCC3uJH0Fkf0mMECDorhKC3+BF01of0GAGCzgoh6C1+BJ31IT1GgKCzQgh6ix9BZ31II4AAAgiUCHgnYQmkMQgggECbAEG3iZqHAAIIlAgQdAmkMQgggECbAEG3iZqHAAIIlAgQdAmkMQgggECbAEG3iZqHAAIIlAgQdAmkMQgggECbAEG3iZqHAAIIlAgQdAmkMQgggECbAEG3iZqHAAIIlAgQdAmkMQgggECbAEG3iZqHAAIIlAgQdAmkMQgggECbAEG3iZqHAAIIlAgQdAmkMQgggECbAEG3iZqHAAIIlAgQdAmkMQgggECbAEG3iZqHAAIIlAgQdAmkMQgggECbwL8Bt6sEVBsFciYAAAAASUVORK5CYII=';

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
    uint256 public price = 1000000000000000;

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
        uint256 foundGoose = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, blockhash(block.number - 1)))) % _tokenIdTracker.current();
        uint256 prize = address(this).balance / 10000 * goosePrizePercentage;
        payable(ownerOf(foundGoose)).transfer(prize);
        payable(owner()).transfer(address(this).balance);
        geese[foundGoose] = true;
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
        require(_tokenId < _tokenIdTracker.current(), 'Token does not exist');
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
