const { expect } = require("chai");
const { ethers } = require("hardhat");
const EthCrypto = require("eth-crypto");

describe("Mint", function () {

    // PRIVATE KEYS FOR CREATING SIGNATURES
    let ownerPrivateKey = '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80';
    let addr1PrivateKey = '0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d';

    // RUN THIS BEFORE EACH TEST
    beforeEach(async function () {
        Mint = await ethers.getContractFactory("Mint");
        mint = await Mint.deploy();
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
    });

    describe("Functionality", function () {
        it("Has the correct mint version after deployment", async function () {
            expect(await mint.mintVersion()).to.equal(1);
        });
        it("Can increment the mint version", async function () {
            await mint.newMintVersion();
            expect(await mint.mintVersion()).to.equal(2);
            await mint.newMintVersion();
            expect(await mint.mintVersion()).to.equal(3);
        });
        it("Can emit MintUpdated event when incrementing the mint version", async function () {
            await expect(mint.newMintVersion()).to.emit(mint, "MintUpdated");
        });
        it("Cannot increment the mint version from non admin account", async function () {
            await expect(mint.connect(addr1).newMintVersion()).to.be.reverted;
        });
        it("Can update the mint type", async function () {
            await mint.setMintType(0);
            expect(await mint.mintType()).to.equal(0);
            await mint.setMintType(1);
            expect(await mint.mintType()).to.equal(1);
        });
        it("Can emit MintUpdated event when updating the mint type", async function () {
            await expect(mint.setMintType(0)).to.emit(mint, "MintUpdated");
        });
        it("Can update the target address", async function () {
            await mint.setTarget(owner.address);
            expect(await mint.target()).to.equal(owner.address);
            await mint.setTarget(addr1.address);
            expect(await mint.target()).to.equal(addr1.address);
        });
        it("Can emit MintUpdated event when updating the target address", async function () {
            await expect(mint.setTarget(owner.address)).to.emit(mint, "MintUpdated");
        });
        it("Cannot update the target address from non admin account", async function () {
            await expect(mint.connect(addr1).setTarget(addr1.address)).to.be.reverted;
            await expect(mint.connect(addr1).setTarget(owner.address)).to.be.reverted;
        });
    });
});
