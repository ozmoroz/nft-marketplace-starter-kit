const SafeMath = artifacts.require("SafeMath");
const Counters = artifacts.require("Counters");
const KryptoBird = artifacts.require("KryptoBird");

module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.deploy(Counters);
  deployer.link(Counters, KryptoBird);
  deployer.deploy(KryptoBird);
};
