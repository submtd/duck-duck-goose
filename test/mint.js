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

    describe("Security", function () {
        it("Can update the target address", async function () {
            await mint.updateTarget(owner.address);
            expect(await mint.target()).to.equal(owner.address);
        });
    });
});
