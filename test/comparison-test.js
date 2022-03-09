var chai = require('chai');
chai.use(require('chai-string'));

const { expect } = require("chai");
const { ethers } = require("hardhat");
const { expectEvent, expectRevert } = require('@openzeppelin/test-helpers');
const { hexStripZeros } = require('ethers/lib/utils');

describe("Evaluating gas utilization:", function () {

  let NiftyRegistry, builderShopOriginal;

  let registry, builderShop;

  let owner, addr1, addr2, addr3;

  beforeEach(async function () {

    // need both to deploy buildshop
    NiftyRegistry = await ethers.getContractFactory("NiftyRegistry");
    MasterBuilder = await ethers.getContractFactory("NiftyBuilderMaster");

    // buildershop original (code as recieved)
    BuilderShopOriginal = await ethers.getContractFactory("BuilderShop_0");

    // buildershop after optimization 
    BuilderShopOptimized = await ethers.getContractFactory("BuilderShop_1");

    [owner, addr1, addr2, addr3] = await ethers.getSigners();


    // deploying contracts
    registry = await NiftyRegistry.deploy([owner.address], [owner.address]);
    masterBuilder = await MasterBuilder.deploy();
    builderShopOriginal = await BuilderShopOriginal.deploy(registry.address, masterBuilder.address);
    builderShopOptimized = await BuilderShopOptimized.deploy(registry.address, masterBuilder.address);

  });

  it("Test 1: Registry address returns as expected", async function () {

    let value = await builderShopOriginal.niftyRegistryContract();

    console.log("Address of buildershop contract: ", value);
    expect(value).to.equal(registry.address);

  });

  it("Comparing gas usage of giftNifty function", async function () {

    let name = "name";
    let symbol = "SYMBOL";
    let num_nifties = 100;
    let token_base_uri = "token_base_uri";
    let creator_name = "god";


    let original = await builderShopOriginal.createNewBuilderInstance(name, symbol, num_nifties, token_base_uri, creator_name, registry.address, masterBuilder.address);
    let origVars = await original.wait();


    // call giftnifty from original contract to get gas estimate
    const builderInstance = await ethers.getContractAt("NiftyBuilderInstance_0", origVars.events[0].args[0]);
    let giftOutput = await builderInstance.giftNiftyOriginal(builderInstance.address, 1);
    expect(builderInstance.address).to.equal(giftOutput.to);

    let count = await builderInstance.totalSupply();
    console.log("Tokens minted with original contract: ", parseInt(count));
    await builderInstance.giftNiftyOriginal(builderInstance.address, 1); // calling twice so we can get a range in our gas estimate


    // call giftnifty from optimized contract to compare
    let optimized = await builderShopOptimized.createNewBuilderInstance(name, symbol, num_nifties, token_base_uri, creator_name, registry.address, masterBuilder.address);
    let optVars = await optimized.wait();

    const optInstance = await ethers.getContractAt("NiftyBuilderInstance_1", optVars.events[0].args[0]);
    let gifty;
    gifty = await optInstance.giftNiftyOptimized(optInstance.address, 1, 1);
    expect(optInstance.address).to.equal(gifty.to);

    console.log("Tokens minted with optimized contract: ", parseInt(await optInstance.totalSupply()))
    await optInstance.giftNiftyOptimized(optInstance.address, 1, 1); // calling twice so we can get a range in our gas estimate

  });

});