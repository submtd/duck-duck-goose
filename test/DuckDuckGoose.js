const { expect } = require("chai");
const { ethers } = require("hardhat");

const hatchCycleMinimum = 5;
const hatchCycleMaximum = 500;
const goosePrizePercentage = 90;
const price = '1000000000000000000';
const name = 'Duck, Duck, Goose!';
const symbol = '$DDG';

describe("DuckDuckGoose", function () {
    // RUN THIS BEFORE EACH TEST
    beforeEach(async function () {
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
        const Egg = await hre.ethers.getContractFactory("Egg");
        const egg = await Egg.deploy();
        const Duck = await hre.ethers.getContractFactory("Duck");
        const duck = await Duck.deploy();
        const Goose = await hre.ethers.getContractFactory("Goose");
        const goose = await Goose.deploy();
        const NFT = await ethers.getContractFactory("DuckDuckGoose", {
            libraries: {
                Egg: egg.address,
                Duck: duck.address,
                Goose: goose.address,
            },
        });
        nft = await NFT.deploy();
    });
    // TESTS
    describe("Deployment", function () {
        it("Has an address", async function () {
            expect(nft.address).to.not.equal(0);
        });
        it("Has zero eggs", async function () {
            expect(await nft.eggs()).to.equal(0);
        });
        it("Has zero ducks", async function () {
            expect(await nft.ducks()).to.equal(0);
        });
        it("Has zero geese", async function () {
            expect(await nft.geese()).to.equal(0);
        });
        it("Has the correct hatch cycle minimum", async function () {
            expect(await nft.hatchCycleMinimum()).to.equal(hatchCycleMinimum);
        });
        it("Has the correct hatch cycle", async function () {
            expect(await nft.hatchCycle()).to.equal(hatchCycleMinimum);
        });
        it("Has the correct hatch cycle maximum", async function () {
            expect(await nft.hatchCycleMaximum()).to.equal(hatchCycleMaximum);
        });
        it("Has generation of 1", async function () {
            expect(await nft.generation()).to.equal(1);
        });
        it("Has correct goose prize percentage", async function () {
            expect(await nft.goosePrizePercentage()).to.equal(goosePrizePercentage);
        });
        it("Has the correct price", async function () {
            expect(await nft.price()).to.equal(price);
        });
        it("Has prize bank of 0", async function () {
            expect(await nft.prizeBank()).to.equal(0);
        });
        it("Has the right name", async function () {
            expect(await nft.name()).to.equal(name);
        });
        it("Has the right symbol", async function () {
            expect(await nft.symbol()).to.equal(symbol);
        });
        it("Has total supply of 0", async function () {
            expect(await nft.totalSupply()).to.equal(0);
        });
    });
    describe("Minting", function () {
        it("Can mint an NFT", async function () {
            await expect(nft.mint(1, { value: price })).to.not.be.reverted;
        });
        it("Can mint an nft from non owner account", async function () {
            await expect(nft.connect(addr1).mint(1, { value: price })).to.not.be.reverted;
        });
        it("Updates total supply after minting", async function () {
            await nft.mint(1, { value: price });
            expect(await nft.totalSupply()).to.equal(1);
        });
        it("Returns the correct token of owner by index", async function () {
            await nft.mint(1, { value: price });
            expect(await nft.tokenOfOwnerByIndex(owner.address, 0)).to.equal(1);
            await nft.connect(addr1).mint(1, { value: price });
            expect(await nft.tokenOfOwnerByIndex(addr1.address, 0)).to.equal(2);
        });
        it("Can mint multiple NFTs", async function () {
            await expect(nft.mint(10, { value: BigInt(price) * BigInt('10') })).to.not.be.reverted;
        });
        it("Reverts without enough value", async function () {
            await expect(nft.mint(2, { value: price })).to.be.revertedWith('Value is too low');
        });
    });
    describe("Hatching", function () {
        it("Can hatch eggs", async function () {
            for(i = 1; i <= hatchCycleMinimum; i ++) {
                await nft.mint(1, { value: price });
            }
            expect(await nft.eggs()).to.equal(0);
            expect(await nft.ducks()).to.equal(hatchCycleMinimum - 1);
            expect(await nft.geese()).to.equal(1);
        });
        it("Emits goose hatched event", async function () {
            for(i = 1; i < hatchCycleMinimum; i++) {
                await nft.mint(1, { value: price });
            }
            await expect(nft.mint(1, { value: price })).to.emit(nft, "GooseHatched");
        });
        it("Increments the hatch cycle after hatching", async function () {
            for(i = 1; i <= hatchCycleMinimum; i++) {
                await nft.mint(1, { value: price });
            }
            expect(await nft.hatchCycle()).to.equal(hatchCycleMinimum + 1);
        });
        it("Can have the hatch cycle updated", async function () {
            await expect(nft.setHatchCycle(1)).to.not.be.reverted;
            expect(await nft.hatchCycle()).to.equal(1);
        });
        it("Can have the hatch cycle minimum updated", async function () {
            await expect(nft.setHatchCycleMinimum(1)).to.not.be.reverted;
            expect(await nft.hatchCycleMinimum()).to.equal(1);
        });
        it("Can have the hatch cycle maximum updated", async function () {
            await expect(nft.setHatchCycleMaximum(1)).to.not.be.reverted;
            expect(await nft.hatchCycleMaximum()).to.equal(1);
        });
        it("Can have the price updated", async function () {
            await expect(nft.setPrice(9999)).to.not.be.reverted;
            expect(await nft.price()).to.equal(9999);
        });
        it("Can have the prize percentage updated", async function () {
            await expect(nft.setGoosePrizePercentage(50)).to.not.be.reverted;
            expect(await nft.goosePrizePercentage()).to.equal(50);
        });
        it("Cannot be updated by non admin account", async function () {
            await expect(nft.connect(addr1).setHatchCycle(1)).to.be.reverted;
            await expect(nft.connect(addr1).setHatchCycleMinimum(1)).to.be.reverted;
            await expect(nft.connect(addr1).setHatchCycleMaximum(1)).to.be.reverted;
            await expect(nft.connect(addr1).setPrice(1)).to.be.reverted;
            await expect(nft.connect(addr1).setGoosePrizePercentage(1)).to.be.reverted;
        });
        it("Resets hatch cycle after max is reached", async function () {
            await nft.setHatchCycle(1);
            await nft.setHatchCycleMinimum(1);
            await nft.setHatchCycleMaximum(2);
            // this should allow 1 mint, then hatch cycle goes to 2, then 2 more mints and hatch
            // cycle goes back down to 1.
            expect(await nft.hatchCycle()).to.equal(1);
            await nft.mint(1, { value: price });
            expect(await nft.hatchCycle()).to.equal(2);
            await nft.mint(1, { value: price });
            await nft.mint(1, { value: price });
            expect(await nft.hatchCycle()).to.equal(1);
        });
        it("Can mint a lot of eggs", async function () {
            for(i = 1; i <= 1000; i++) {
                await nft.mint(1, { value: price });
            }
            expect(await nft.totalSupply()).to.equal(1000);
        });
    });
});
