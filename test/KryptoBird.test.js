/* global artifacts, contract */

const { assert, expect } = require("chai");

require("chai")
  .use(require("chai-as-promised"))
  .should();

const KryptoBird = artifacts.require("./KryptoBird");

contract("KryptoBird", (accounts) => {
  let contract;

  beforeEach(async () => {
    contract = await KryptoBird.deployed();
  });

  describe("deployment", () => {
    it("deploy successfully", () => {
      const address = contract.address;
      assert.notEqual(address, "");
      assert.notEqual(address, undefined);
      assert.notEqual(address, 0x0);
    });

    it("name and symbol match", async () => {
      expect(await contract.name()).to.equal("KryptoBird");
      expect(await contract.symbol()).to.equal("KBIRDZ");
    });
  });

  describe("Minting", async () => {
    it("create a new token", async () => {
      const mintResult = await contract.mint("https...1");
      expect((await contract.totalSupply()).toNumber()).to.equal(1);
      // Verify firing "Transfer" event.
      // Transfer event fires from address 0 to accounts[0] which is msg.sender
      const args = mintResult.logs[0].args;
      expect(Number(args[0])).to.equal(0);
      expect(args[1]).to.equal(accounts[0]);

      // Contact minting should be rejected if it already exists
      await contract.mint("https...1").should.be.rejected;
    });
  });
});
