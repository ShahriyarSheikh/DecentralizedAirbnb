var RentalEscrowContract = artifacts.require("./RentalEscrowContract.sol");
var MockContract;

contract('RentalEscrowContract', function (accounts) {

  describe("DESCRIBE: Deploy the Rental Escrow Contract", function () {

    it("Catched an instance of the demo contract", async () => {
        MockContract = await RentalEscrowContract.deployed();
        _accounts = accounts;
    })

    it("Should deposit some amount in the escrow",async() =>{
        var response = await MockContract.depositForRentee({value: web3.toWei("1.1", 'ether')});
        console.log(response);
    });
    


  });


});

