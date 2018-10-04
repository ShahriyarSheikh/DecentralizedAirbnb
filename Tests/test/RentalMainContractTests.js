var RentalMainContract = artifacts.require("./RentalMainContract.sol");
const web3 = require('web3');

var renterDetailsHash = web3.utils.randomHex(32);
var demoContract;
var _accounts;
var _temp;

contract('RentalMainContract',function(accounts){

  describe("Deploy the Rental Main Contract",function(){

    it("Catched an instance of the demo contract",async() =>{
      demoContract = await RentalMainContract.deployed();
      _accounts = accounts;
    })
  });

  describe("Check for registry of renter",async() =>{

    it("Should register a renter",async()=>{
      await demoContract.registerRenter(_accounts[0],renterDetailsHash);
      console.log("    Successfully registered account: " +  _accounts[0]);
    });

    it("Should check a registered renter",async() =>{
        assert.equal((await demoContract.isUserARegisteredRenter(_accounts[0])).valueOf(),true,"Account 1 should be registerd")
        assert.equal((await demoContract.isUserARegisteredRenter(_accounts[1])).valueOf(),false,"Account 2 should be unregisterd")
        assert.equal((await demoContract.isUserARegisteredRenter(_accounts[2])).valueOf(),false,"Account 3 should be unregisterd")
      });

   

  }); 

  describe("Placing a rent offer by a registered renter",async()=>{
    it("should place a rent offer",async()=>{
      var startDate = getDate('Oct 06,2018');
      var endDate = getDate('Oct 15,2018');
      await demoContract.placeRentOffer(web3.utils.toWei("1",'ether'), startDate, endDate,_accounts[0], renterDetailsHash,web3.utils.toWei("0.0001",'ether'));
    })
  });

  });

//'Aug 08, 2012'
  function getDate(dateFormat){
    return (new Date(dateFormat).getTime() /1000)
  }
