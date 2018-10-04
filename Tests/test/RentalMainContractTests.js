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
      console.log("Registered Account: " +  _accounts[0]);
    });

    it("Should check a registered renter",async() =>{
        assert.equal((await demoContract.isUserARegisteredRenter(_accounts[0])).valueOf(),true,"Account 1 registerd")
        assert.equal((await demoContract.isUserARegisteredRenter(_accounts[1])).valueOf(),false,"Account 2 unregisterd")
        assert.equal((await demoContract.isUserARegisteredRenter(_accounts[2])).valueOf(),false,"Account 3 unregisterd")
    });

    it("should place a rent offer",async()=>{
      await demoContract.placeRentOffer(web3.utils.toWei("1",'ether'), 1539043200, 1539993600,_accounts[0], renterDetailsHash,web3.utils.toWei("0.0001",'ether'));
    })


    // it("Creates a valid token", async ()=> {
            
    //   return RentalMainContract.deployed().then(async(instance) =>{
    //     if(_temp == 1)  
    //      await instance.placeRentOffer(100000, 1539043200, 1539993600,_accounts[0], renterDetailsHash,100);
          
    //       //assert.equal(totalSupply, actualTotalSupply.toNumber() , "Total supply incorrect");
    //   });
    // });

  //   let result = await instance.placeRentOffer.call(100000000, 1539043200, 1539993600,accounts[0], renterDetailsHash,100000);

  }); 

  });

// var MetaCoin = artifacts.require("./MetaCoin.sol");

// contract('MetaCoin', function(accounts) {
//   it("should put 10000 MetaCoin in the first account", function() {
//     return MetaCoin.deployed().then(function(instance) {
//       return instance.getBalance.call(accounts[0]);
//     }).then(function(balance) {
//       assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
//     });
//   });
//   it("should call a function that depends on a linked library", function() {
//     var meta;
//     var metaCoinBalance;
//     var metaCoinEthBalance;

//     return MetaCoin.deployed().then(function(instance) {
//       meta = instance;
//       return meta.getBalance.call(accounts[0]);
//     }).then(function(outCoinBalance) {
//       metaCoinBalance = outCoinBalance.toNumber();
//       return meta.getBalanceInEth.call(accounts[0]);
//     }).then(function(outCoinBalanceEth) {
//       metaCoinEthBalance = outCoinBalanceEth.toNumber();
//     }).then(function() {
//       assert.equal(metaCoinEthBalance, 2 * metaCoinBalance, "Library function returned unexpected function, linkage may be broken");
//     });
//   });
//   it("should send coin correctly", function() {
//     var meta;

//     // Get initial balances of first and second account.
//     var account_one = accounts[0];
//     var account_two = accounts[1];

//     var account_one_starting_balance;
//     var account_two_starting_balance;
//     var account_one_ending_balance;
//     var account_two_ending_balance;

//     var amount = 10;

//     return MetaCoin.deployed().then(function(instance) {
//       meta = instance;
//       return meta.getBalance.call(account_one);
//     }).then(function(balance) {
//       account_one_starting_balance = balance.toNumber();
//       return meta.getBalance.call(account_two);
//     }).then(function(balance) {
//       account_two_starting_balance = balance.toNumber();
//       return meta.sendCoin(account_two, amount, {from: account_one});
//     }).then(function() {
//       return meta.getBalance.call(account_one);
//     }).then(function(balance) {
//       account_one_ending_balance = balance.toNumber();
//       return meta.getBalance.call(account_two);
//     }).then(function(balance) {
//       account_two_ending_balance = balance.toNumber();

//       assert.equal(account_one_ending_balance, account_one_starting_balance - amount, "Amount wasn't correctly taken from the sender");
//       assert.equal(account_two_ending_balance, account_two_starting_balance + amount, "Amount wasn't correctly sent to the receiver");
//     });
//   });
// });
