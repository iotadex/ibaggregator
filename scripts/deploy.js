// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const IbAggregatorRouter = await hre.ethers.getContractFactory("IbAggregatorRouter");
  const ibAR = await IbAggregatorRouter.deploy();
  console.log(`deployed IbAggregatorRouter to ${ibAR.address}`);

  const b = await ibAR.addRouter(0x1f, "0x3C71B92D6f54473a6c66010dF5Aa139cD42c34b0");
  console.log(`addRouter : ${b}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
