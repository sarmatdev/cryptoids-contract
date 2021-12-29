import { ethers } from "hardhat";

async function main() {
  const Cryptoids = await ethers.getContractFactory("Cryptoids");
  const cryptoids = await Cryptoids.deploy("Hello, Hardhat!");

  await cryptoids.deployed();

  console.log("Cryptoids deployed to:", cryptoids.address);
}

main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
