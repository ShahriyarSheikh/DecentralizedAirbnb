pragma solidity ^0.4.24;

contract RentalEscrowContract {
    
    /* Variables */
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
    uint private _lockedSecurityDeposit;
    uint private _lockedRenteeDeposit;
    uint private _fixedSecurityDeposit = 2 ether;
    
    bool private _locked = false;
    bool private _hasRenteeReleasedEscrow = false;
    bool private _hasRenterCollectedFunds = false;
    
    /* Events */
    event RecievedFromRentee(address indexed caller, address indexed renterAddress, uint indexed valueReceived);
    event EscrowReleasedFromRentee(address indexed caller);
    event EscrowAmountCollectedByRenter(address indexed caller);
    event RenteeHasRaisedDispute(address indexed caller);
    
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
    //Need to audit this, not sure if it works
    function depositForRentee() external payable {
        require(_renteeAddress == msg.sender,"Given account cannot perform this action");
        require(_offeredAmount + _fixedSecurityDeposit == msg.value, "Expected an amount of offered quantiy, but does not match the amount sent");
        _lockedSecurityDeposit = msg.value - (msg.value - _fixedSecurityDeposit);
        _lockedRenteeDeposit = msg.value - _lockedSecurityDeposit;
        emit RecievedFromRentee(msg.sender, _renterAddress, msg.value);
    }
    
    function releaseEscrowFundsByRentee() external {
        require(_renteeAddress == msg.sender,"Given account cannot perform this action");
        require(now > _renteesGivenEndDate,"Rent has not ended yet");
        lock();
        _renteeAddress.transfer(_lockedSecurityDeposit);
        _lockedSecurityDeposit = 0;
        _hasRenteeReleasedEscrow = true;
        unlock();
        
        emit EscrowReleasedFromRentee(_renteeAddress);
    }
    
    function collectEscrowFundsByRenter()external {
        require(_renterAddress == msg.sender,"Given account cannot perform this action");
        require(_hasRenteeReleasedEscrow,"Rentee needs to release the escrow first");
        lock();
        _renterAddress.transfer(_lockedRenteeDeposit);
        _lockedRenteeDeposit = 0;
        _hasRenterCollectedFunds = true;
        unlock();
        
        emit EscrowReleasedFromRentee(_renterAddress);
    }
    
    function raiseDisputeByRenter() external {
        require(block.timestamp < _renteesGivenEndDate,"Rent has ended, cannot raise dispute now");
        require(_hasRenteeReleasedEscrow,"Cannot raise dispute once collected security deposit");
        require(_hasRenterCollectedFunds,"Cannot raise dispute once escrow has ended");
        
        emit RenteeHasRaisedDispute(msg.sender);
    }
    
    function raiseDisputeByRentee() external {
        require(block.timestamp < _renteesGivenEndDate,"Rent has ended, cannot raise dispute now");
    }
    
    /* Arbitrator Functions */
    //Releases the funds given by the rentee to the renter
    function signForRenter() external pure {}
    //Releases the Security deposit submitted by the rentee
    function signForRentee() external pure {}
    
    
    /* Helper Functions */
    
    function lock() private{
        if(!_locked)
            _locked = true;
        else
            revert();
    }
    
    function unlock() private{
        _locked = false;
    }
    
    
}