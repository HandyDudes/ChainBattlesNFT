// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// Deployment script per the RTW3 tutorial, added the hre requirement for hardhat

const hre = require("hardhat");

const main = async () => {
  try {
    const nftContractFactory = await hre.ethers.getContractFactory(
      "ChainBattles"
    );
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();

    console.log("Contract deployed to:", nftContract.address);
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};
  
main();
