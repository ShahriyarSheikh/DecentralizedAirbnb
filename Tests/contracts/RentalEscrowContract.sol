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
    uint private _fixedSecurityDeposit;
    
    bool private _locked = false;
    bool private _hasRenteeReleasedEscrow;
    bool private _hasRenterCollectedFunds;
    bool private _hasRenterRaisedDispute;
    bool private _hasRenteeRaisedDispute;
    bool private _hasArbitratorAgreedWithRenter;
    bool private _hasArbitratorAgreedWithRentee;
    
    /* Events */
    event RecievedFromRentee(address indexed caller, address indexed renterAddress, uint indexed valueReceived);
    event EscrowReleasedFromRentee(address indexed caller);
    event EscrowReleasedFromRenter(address indexed caller);
    event EscrowAmountCollectedByRenter(address indexed caller);
    event RenteeHasRaisedDispute(address indexed caller);
    event RenterHasRaisedDispute(address indexed caller);
    event ArbitratorHasAgreedWithRenter(address indexed caller, address indexed renterAddress);
    event ArbitratorHasAgreedWithRentee(address indexed caller, address indexed renteeAddress);
    
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
                uint offeredAmount,
                uint fixedSecurityDeposit) public {
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
        _fixedSecurityDeposit = fixedSecurityDeposit;
    }
    
    modifier onlyArbitrator(){
        require(msg.sender == _arbitratorAddress,"Only arbitrator can perform these functions");
        _;
    }
    
    /* Escrow Functions */
    //Need to audit this, not sure if it works
    function depositForRentee() external payable {
        require(_lockedRenteeDeposit == 0,"Amount already given by rentee");
        require(_renteeAddress == msg.sender,"Given account cannot perform this action");
        require(_offeredAmount + _fixedSecurityDeposit == msg.value, "Expected an amount of offered quantiy, but does not match the amount sent");
        _lockedSecurityDeposit = msg.value - (msg.value - _fixedSecurityDeposit);
        _lockedRenteeDeposit = msg.value - _lockedSecurityDeposit;
        emit RecievedFromRentee(msg.sender, _renterAddress, msg.value);
    }
    
    function releaseEscrowFundsByRentee() external {
        require(_renteeAddress == msg.sender,"Given account cannot perform this action");
        require(block.timestamp > _renteesGivenEndDate,"Rent has not ended yet");

        _hasRenteeReleasedEscrow = true;
        
        emit EscrowReleasedFromRentee(_renteeAddress);
    }
    
    function collectEscrowFundsByRenter() external {
        require(_renterAddress == msg.sender,"Given account cannot perform this action");
        //Check end time 
        require(block.timestamp > _renteesGivenEndDate,"Cannot collect funds until rent time has ended");
        //Check if the rentee is satisfied with the outcome
        require(_hasRenteeReleasedEscrow,"Rentee has not released the escrow yet");
        
        lock();
        _renterAddress.transfer(_lockedRenteeDeposit);
        _renteeAddress.transfer(_lockedSecurityDeposit);
        _lockedRenteeDeposit = 0;
        _lockedSecurityDeposit = 0;
        _hasRenterCollectedFunds = true;
        unlock();
        
        emit EscrowReleasedFromRenter(_renterAddress);
    }
    
    function raiseDisputeByRenter() external {
        require(_hasRenterCollectedFunds,"Cannot raise dispute once escrow has ended");
        
        require(_hasRenteeRaisedDispute,"Rentee has already raised dispute");
        _hasRenterRaisedDispute = true;
        emit RenterHasRaisedDispute(msg.sender);
    }
    
    function raiseDisputeByRentee() external {
        //Meaning that after rent has completed, you cannot raise a dispute
        require(block.timestamp < _renteesGivenEndDate,"Rent has ended, cannot raise dispute now");
        require(_hasRenteeReleasedEscrow,"Cannot raise dispute after releasing escrow");
        require(_hasRenterCollectedFunds,"Cannot raise dispute after renter has collected the funds");
        require(_hasRenterRaisedDispute,"Renter has already raised dispute");
        
        _hasRenteeRaisedDispute = true;
        
        emit RenteeHasRaisedDispute(msg.sender);
        
    }
    
    /* Arbitrator Functions */
    //Releases the funds given by the rentee to the renter
    function signForRenter() onlyArbitrator external payable {
        require(!(_hasArbitratorAgreedWithRenter),"Arbitrator has already signed for renter");
        require(!(_hasArbitratorAgreedWithRentee),"Arbitrator has already agreed with rentee");
        require(address(this).balance >= _arbitratorFees,"Arbitrator fee is insufficient");
        
        
        
        //Calculations for Renter
        lock();
        _arbitratorAddress.transfer(address(this).balance - (address(this).balance - _arbitratorFees));
        _renterAddress.transfer(address(this).balance);
        _hasArbitratorAgreedWithRenter = true;
        unlock();
        
        emit ArbitratorHasAgreedWithRenter(msg.sender,_renterAddress);
    }
    //Releases the Security deposit submitted by the rentee
    function signForRentee() onlyArbitrator external payable {
        require(!(_hasArbitratorAgreedWithRenter),"Arbitrator has already signed for renter");
        require(!(_hasArbitratorAgreedWithRentee),"Arbitrator has already agreed with rentee");
        require(address(this).balance >= _arbitratorFees,"Arbitrator fee is insufficient");
        
        //Calculations for rentee
        lock();
        _arbitratorAddress.transfer(address(this).balance - (address(this).balance - _arbitratorFees));
        _renteeAddress.transfer(address(this).balance);
        _hasArbitratorAgreedWithRentee = true;
        unlock();
        
        emit ArbitratorHasAgreedWithRentee(msg.sender,_renterAddress);
        
    }
    
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