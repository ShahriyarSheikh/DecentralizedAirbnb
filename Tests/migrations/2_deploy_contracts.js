// var ConvertLib = artifacts.require("./ConvertLib.sol");
// var MetaCoin = artifacts.require("./MetaCoin.sol");
var SystemDateTime = artifacts.require("./SystemDateTime.sol");
var RentalEscrowContract = artifacts.require("./RentalEscrowContract.sol");
var RentalMainContract = artifacts.require("./RentalMainContract.sol");

module.exports = function(deployer) {
  // deployer.deploy(ConvertLib);
  // deployer.link(ConvertLib, MetaCoin);
  // deployer.deploy(MetaCoin);

  deployer.deploy(SystemDateTime);
  //deployer.deploy(RentalEscrowContract);
  deployer.link(SystemDateTime,RentalMainContract);
  deployer.deploy(RentalMainContract);
};
