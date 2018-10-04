var RentalMainContract = artifacts.require("./RentalMainContract.sol");
const web3 = require('web3');

var renterDetailsHash = web3.utils.randomHex(32);
var demoContract;
var _accounts;
var registeredAccount;
var _temp;
var rentOfferHash;

var offer = { offeredAmount: '', startDate: 0, endDate: 0, arbitratorAddress: '', rentalDetailsHash: '', arbitratorFees: '' };
var listOfOffers = new Array();

contract('RentalMainContract', function (accounts) {

  describe("DESCRIBE: Deploy the Rental Main Contract", function () {

    it("Catched an instance of the demo contract", async () => {
      demoContract = await RentalMainContract.deployed();
      _accounts = accounts;
    })
  });

  describe("DESCRIBE: Check for registry of renter", async () => {

    it("Should register a renter", async () => {
      await demoContract.registerRenter(_accounts[0], renterDetailsHash);
      console.log("    Successfully registered account: " + _accounts[0]);
      registeredAccount = _accounts[0];


    });

    it("Should check a registered renter", async () => {
      assert.equal((await demoContract.isUserARegisteredRenter(registeredAccount)).valueOf(), true, "Account 1 should be registerd")
      assert.equal((await demoContract.isUserARegisteredRenter(_accounts[1])).valueOf(), false, "Account 2 should be unregisterd")
      assert.equal((await demoContract.isUserARegisteredRenter(_accounts[2])).valueOf(), false, "Account 3 should be unregisterd")
    });



  });

  describe("DESCRIBE: Placing a rent offer by a registered renter", async () => {
   
    it("should place a rent offer", async () => {
      offer.offeredAmount = web3.utils.toWei("1", 'ether');
      offer.startDate = getDate('Oct 06,2018');
      offer.endDate = getDate('Oct 15,2018');
      offer.rentalDetailsHash = renterDetailsHash;
      offer.arbitratorAddress = _accounts[1];
      offer.arbitratorFees = web3.utils.toWei("0.0001", 'ether');
      var res = await demoContract.placeRentOffer(offer.offeredAmount, offer.startDate, offer.endDate, offer.arbitratorAddress, offer.rentalDetailsHash, offer.arbitratorFees);
      rentOfferHash = res.logs[0].args.rentOfferHash;
      listOfOffers.push(offer);

    });
  });

  describe("Modify an existing rent offer", async () => {
    it("should modify an existing rent offer", async () => {
      
      console.log("Going to modify the offer: " + rentOfferHash)
      console.log(demoContract);
      var response = await demoContract.modifyRentOffer(rentOfferHash, offer.startDate, offer.endDate, offer.arbitratorAddress, offer.rentalDetailsHash, offer.arbitratorFees);
      rentOfferHash = res.logs[0].args.rentOfferHash;
      console.log(rentOfferHash);
    })
  });

});

//'Aug 08, 2012'
function getDate(dateFormat) {
  return (new Date(dateFormat).getTime() / 1000)
}
