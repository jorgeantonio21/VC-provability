import { ethers } from "hardhat";

async function main() {
  let name = "ETHGlobalLisbonSurvey";
  const symbol = "ETHGLO-LIS";

  const ETHGlobalPOAPContract = await ethers.getContractFactory("ETHGlobalPOAPContract");
  const ethGlobalPOAPContract = await ETHGlobalPOAPContract.deploy(name, symbol);

  await ethGlobalPOAPContract.deployed();

  console.log(
    `ETHGlobalPOAPContract contract successfully deployed to ${ethGlobalPOAPContract.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
