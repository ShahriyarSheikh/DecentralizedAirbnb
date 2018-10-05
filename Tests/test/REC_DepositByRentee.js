var RentalEscrowContract = artifacts.require("./RentalEscrowContract.sol");

contract('RentalEscrowContract', function (accounts) {

  describe("DESCRIBE: Deploy the Rental Escrow Contract", function () {

    it("Catched an instance of the demo contract", async () => {
      demoContract = await RentalEscrowContract.deployed();
      _accounts = accounts;
    })
  });


});

