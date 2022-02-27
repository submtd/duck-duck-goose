const hre = require("hardhat");

async function main() {
    const [deployer] = await hre.ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());
    const DuckDuckGoose = await hre.ethers.getContractFactory("DuckDuckGoose");
    const gasToUse = await hre.ethers.provider.estimateGas(DuckDuckGoose.getDeployTransaction());
    console.log("Estimated gas:", gasToUse.toString());
    const duckduckgoose = await DuckDuckGoose.deploy();
    await duckduckgoose.deployed();
    console.log("Transaction created:", duckduckgoose.deployTransaction.hash);
    console.log("Contract deployed to:", duckduckgoose.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
