var RentalEscrowContract = artifacts.require("./RentalEscrowContract.sol");
var MockContract;

contract('RentalEscrowContract', function (accounts) {

  describe("DESCRIBE: Deploy the Rental Escrow Contract", function () {

    it("Catched an instance of the demo contract", async () => {
        MockContract = await RentalEscrowContract.deployed();
        _accounts = accounts;
    })

});

describe("DESCRIBE: Should collect escrow funds from the renter side", function () {

    

});



});
