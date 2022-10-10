const { expect } = require("chai");
const { ethers } = require("hardhat");

async function mineNBlocks(n) {
  for (let index = 0; index < n; index++) {
    await ethers.provider.send('evm_mine');
  }
}

const timeLatest = async () => {
  const block = await hre.ethers.provider.getBlock('latest');
  return ethers.BigNumber.from(block.timestamp);
};

const setBlocktime = async (time) => {
  await hre.ethers.provider.send('evm_setNextBlockTimestamp', [time]);
  await hre.ethers.provider.send("evm_mine")
};

describe("Origen",  function ()  {

  
  let NFT
  let nFT
  let Token
  let token




  // let [_,per1,per2,per3] = [1,1,1,1]

  it("Should deploy all smart contracts", async function () {

    [_,per1,per2,per3,per4] = await ethers.getSigners()


    NFT = await ethers.getContractFactory("NFT")
    nFT =await NFT.deploy()
    await nFT.deployed()

    Token = await ethers.getContractFactory("GCoin")
    token =await Token.deploy()
    await token.deployed()

    await nFT.setTokenAddress(token.address)
    
    //Vesting_founder
    
    //step 1

    //admin
    await nFT.createPackage("minipackage/" , 10); // 1
    //package = 1


    await nFT.createPackage("Superpackage/", 10); // 2
    await nFT.createPackage("Ultimatepackage/", 10); // 3

    let data = await nFT.package(1)
    console.log(data)
    
    //user call

    await token.approve(nFT.address , '100000000000000000000000000000000000000000')
    
    await nFT.createToken(1);
  

    await nFT.createToken(2);
    await nFT.createToken(3);
    await nFT.createToken(1);
    await nFT.createToken(3);

    console.log("URI" , (await nFT.tokenURI(1)))
    console.log("URI" , (await nFT.tokenURI(2)))
    console.log("URI" , (await nFT.tokenURI(3)))
    console.log("URI" , (await nFT.tokenURI(4)))
    console.log("URI" , (await nFT.tokenURI(5)))

    await nFT.disablePackage(1);

    data = await nFT.package(1)
    console.log(data)
    

    await nFT.enablePackage(1);

    await nFT.createToken(1);

    console.log("URI" , (await nFT.tokenURI(6)))




   
  });
 
 
  

});