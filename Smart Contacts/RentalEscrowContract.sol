pragma solidity ^0.4.24;

contract RentalEscrowContract {
    
    uint private _fixedSecurityDeposit = 2 ether;
    
    constructor(bytes32 _tradeHash, 
                address _sellerAddress, 
                address _buyerAddress, 
                address _arbitratorAddress, 
                uint _arbitratorFees,
                uint startDateOfRent,
                uint endDateOfRent,
                uint renteesGivenStartDate,
                uint renteesGivenEndDate,
                uint _offeredAmount) public {
        
    }
    
}