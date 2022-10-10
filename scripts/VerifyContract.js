const hre = require("hardhat");

async function main() {
await hre.run("verify:verify", {
    address: "0x61cE6D5623b1786A5E1e2ac3c5DEea2dfea12ED0",
    constructorArguments: [
        "0xc85bFa8A78e29d4448929859352C9eBD706ADE88"
    ],
  });
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });