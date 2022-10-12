// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const { ethers } = require("hardhat");
const hre = require("hardhat");
const { json } = require("hardhat/internal/core/params/argumentTypes");
const fs = require("fs");
const fse = require('fs-extra');

// This is a script for deploying your contracts. You can adapt it to deploy
// yours, or create new ones.

async function main() {
  // This is just a convenience check
  // if (network.name === "hardhat") {
  //   console.warn(
  //     "You are trying to deploy a contract to the Hardhat Network, which" +
  //       "gets automatically created and destroyed every time. Use the Hardhat" +
  //       " option '--network localhost'"
  //   );
  // }

  // ethers is avaialble in the global scope
  
  const [deployer,per1,per2] = await ethers.getSigners();
  console.log(
    "Deploying the contracts with the account:",
    await deployer.getAddress()
  );
  const _ = await deployer.getAddress()
  console.log("Account balance:", (await deployer.getBalance()).toString());


  NFT = await ethers.getContractFactory("NFT")
  nFT =await NFT.deploy()
  await nFT.deployed()

  Token = await ethers.getContractFactory("GCoin")
  token =await Token.deploy()
  await token.deployed()

  let tx  = await nFT.setTokenAddress(token.address)
  await tx.wait()

  tx = await nFT.createPackage("minipackage/" , 10); // 1
  await tx.wait()

  
  tx = await token.approve(nFT.address , 10)
  await tx.wait()


  tx = await nFT.createToken(1);
  await tx.wait()

  

  console.log("NFT" , nFT.address)
  console.log("Gcoin" , token.address)
  
  
  


  // We also save the contract's artifacts and address in the frontend directory
 // saveFrontendFiles(crowdSale,trapDart,vestingt,vestingd,vestingf,nFT);
}
//,nftPreSale,nftPubSale,nft

function saveFrontendFiles(nFT,token) {
  
  const contractsDir = "../frontend/src/contract";

  if (!fs.existsSync(contractsDir)) {
    fs.mkdirSync(contractsDir);
  }

let config = `
 export const token_addr = "${token.address}"
 export const nFT_addr = "${nFT.address}"
`

   let data = JSON.stringify(config)
    fs.writeFileSync(
    contractsDir + '/addresses.js', JSON.parse(data)

  );
  saveFrontendFilesV1(contractsDir , `../dashboard/src/contract`)
  saveFrontendFilesV1(contractsDir , `../trapdart-api/package`)

}




function saveFrontendFilesV1(srcDir , destDir) { 

fse.copySync(srcDir, destDir, {
  overwrite: true
}, (err) => {
  if (err) {
    console.error(err);
  } else {
    console.log("success!");
  }
});

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });


// npx hardhat run scripts\deploy.js --network rinkeby