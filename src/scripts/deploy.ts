import { ethers } from "hardhat";

async function main() {
  const verifierContract = "ETHGlobalPOAPContract";
  const verifierName = "ETHGlobalLisbonSurvey";
  const verifierSymbol = "ETHGLO-LIS";
  const ERC20Verifier = await ethers.getContractFactory(verifierContract);
  const erc20Verifier = await ERC20Verifier.deploy(
    verifierName,
    verifierSymbol
  );

  await erc20Verifier.deployed();
  console.log(verifierName, " tx hash:", erc20Verifier.address);
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
