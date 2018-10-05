var RentalMainContract = artifacts.require("./RentalMainContract.sol");
const web3 = require('web3');

var demoContract;
var _accounts;
var registeredAccount;
var renterDetailsHash = web3.utils.randomHex(32);

contract('RentalMainContract', function (accounts) {

  describe("DESCRIBE: Deploy the Rental Main Contract", function () {

    it("Catched an instance of the demo contract", async () => {
      demoContract = await RentalMainContract.deployed();
      _accounts = accounts;
    })
  });

  describe("DESCRIBE: Register and check for registry of renter", async () => {

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


});

