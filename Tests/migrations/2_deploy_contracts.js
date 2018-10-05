// var ConvertLib = artifacts.require("./ConvertLib.sol");
// var MetaCoin = artifacts.require("./MetaCoin.sol");
var SystemDateTime = artifacts.require("./SystemDateTime.sol");
var RentalEscrowContract = artifacts.require("./RentalEscrowContract.sol");
var RentalMainContract = artifacts.require("./RentalMainContract.sol");
const web3 = require('web3')
const getDate = require('../test/helper')

var escrow = {rentOfferHash:"0xda522c276b001588cb7b0fff06ae827ecd0008b8cfe54674658d68c6cd25ae5e",
                        renterAddress:"0xf6871affc2e505552a9dc3c8d87fb5230c5986c9",
                        renteeAddress:"0x081416fcb85dc19b090431cc5795a7578508c221",
                        arbitratorAddress:"0xf6871affc2e505552a9dc3c8d87fb5230c5986c9",
                        arbitratorFees:web3.utils.toWei("0.00001","ether"),
                        startDateOfRent:getDate("Oct 01,2019"),
                        endDateOfRent:getDate("Oct 30,2019"),
                        renteesGivenStartDate:getDate("Oct 05,2019"),
                        renteesGivenEndDate:getDate("Oct 07,2019"),
                        offeredAmount:web3.utils.toWei("1","ether"),
                        fixedSecurityDeposit:web3.utils.toWei("0.001","ether")}

module.exports = function(deployer) {
  deployer.deploy(SystemDateTime);
  deployer.deploy(RentalEscrowContract,escrow.rentOfferHash,escrow.renterAddress,escrow.renteeAddress,escrow.arbitratorAddress,escrow.arbitratorFees,
                  escrow.startDateOfRent,escrow.endDateOfRent,escrow.renteesGivenStartDate,escrow.renteesGivenEndDate,escrow.offeredAmount,escrow.fixedSecurityDeposit);
  deployer.link(SystemDateTime,RentalMainContract);
  deployer.deploy(RentalMainContract);
};
