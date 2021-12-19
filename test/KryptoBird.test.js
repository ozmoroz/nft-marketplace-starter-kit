/* global artifacts, contract */

const { assert, expect } = require("chai");

require("chai")
  .use(require("chai-as-promised"))
  .should();

const KryptoBird = artifacts.require("./KryptoBird");

contract("KryptoBird", (accounts) => {
  describe("deployment", () => {
    let contract;

    beforeEach(async () => {
      contract = await KryptoBird.deployed();
    });

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
});
