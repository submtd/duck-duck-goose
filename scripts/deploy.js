const hre = require("hardhat");

async function main() {
    const [deployer] = await hre.ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());
    // EGG
    //const Egg = await hre.ethers.getContractFactory("Egg");
    //const eggGas = await hre.ethers.provider.estimateGas(Egg.getDeployTransaction(arguments));
    //console.log("Estimated gas to deploy Egg:", eggGas.toString());
    //const egg = await Egg.deploy();
    //await egg.deployed();
    //console.log("Egg transaction created:", egg.deployTransaction.hash);
    //console.log("Egg contract deployed to:", egg.address);
    // DUCK
    //const Duck = await hre.ethers.getContractFactory("Duck");
    //const duckGas = await hre.ethers.provider.estimateGas(Duck.getDeployTransaction(arguments));
    //console.log("Estimated gas to deploy Duck:", duckGas.toString());
    //const duck = await Duck.deploy();
    //await duck.deployed();
    //console.log("Duck transaction created:", duck.deployTransaction.hash);
    //console.log("Duck contract deployed to:", duck.address);
    // GOOSE
    //const Goose = await hre.ethers.getContractFactory("Goose");
    //const gooseGas = await hre.ethers.provider.estimateGas(Goose.getDeployTransaction(arguments));
    //console.log("Estimated gas to deploy Goose:", gooseGas.toString());
    //const goose = await Goose.deploy();
    //await goose.deployed();
    //console.log("Goose transaction created:", goose.deployTransaction.hash);
    //console.log("Goose contract deployed to:", goose.address);
    // DUCK-DUCK-GOOSE
    const DuckDuckGoose = await hre.ethers.getContractFactory("DuckDuckGoose", {
        libraries: {
            Egg: '0xe4c28Fb84d5F7A3F5BEA18F46217C163f3a474Ba',
            Duck: '0x484C97901EF48428b8C7F2F1563948b0f60c1a22',
            Goose: '0xbA201632EaEEc4528Ef4e201CBf785F636cF9115',
        },
    });
    const gasToUse = await hre.ethers.provider.estimateGas(DuckDuckGoose.getDeployTransaction());
    console.log("Estimated gas to deploy DuckDuckGoose:", gasToUse.toString());
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
