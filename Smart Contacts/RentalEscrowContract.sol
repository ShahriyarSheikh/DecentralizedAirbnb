pragma solidity ^0.4.24;

contract RentalEscrowContract {
    
    /* Private variables */
    uint private _fixedSecurityDeposit = 2 ether;
    address private _ownerOfEscrowContract;
    bytes32 private _rentOfferHash;
    address private _renterAddress; 
    address private _renteeAddress; 
    address private _arbitratorAddress; 
    uint _arbitratorFees;
    uint _startDateOfRent;
    uint _endDateOfRent;
    uint _renteesGivenStartDate;
    uint _renteesGivenEndDate;
    uint _offeredAmount;
    
    /* Events */
    event RecievedFromRentee(address indexed caller, address indexed renterAddress, uint indexed valueReceived);
    
    /* Constructor */
    constructor(bytes32 rentOfferHash, 
                address renterAddress, 
                address renteeAddress, 
                address arbitratorAddress, 
                uint arbitratorFees,
                uint startDateOfRent,
                uint endDateOfRent,
                uint renteesGivenStartDate,
                uint renteesGivenEndDate,
                uint offeredAmount) public {
        _ownerOfEscrowContract = tx.origin;
        _rentOfferHash = rentOfferHash;
        _renterAddress = renterAddress;
        _renteeAddress = renteeAddress;
        _arbitratorAddress = arbitratorAddress;
        _arbitratorFees = arbitratorFees;
        _startDateOfRent = startDateOfRent;
        _endDateOfRent = endDateOfRent;
        _renteesGivenStartDate = renteesGivenStartDate;
        _renteesGivenEndDate = renteesGivenEndDate;
        _offeredAmount = offeredAmount;
    }
    
    /* Escrow Functions */

    function depositForRentee() external payable {
       
        emit RecievedFromRentee(msg.sender, _renterAddress, msg.value);
    }
    
}