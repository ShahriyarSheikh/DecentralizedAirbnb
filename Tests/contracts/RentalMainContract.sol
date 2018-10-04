pragma solidity ^0.4.24;

import "./RentalEscrowContract.sol";

library SystemDateTime{
    
    function isDateInRange(uint currentDate, uint startDate, uint endDate) public pure returns (bool){
      if(currentDate >= startDate && currentDate <= endDate ) {
          return true ; 
      }
      else
      return false;
      
  }
  
    function isDateSubsetInRange(uint startDate, uint endDate, uint absoluteStartDate, uint absoluteEndDate) public pure returns (bool){
      require (absoluteStartDate < absoluteEndDate);
      
      if(absoluteStartDate < startDate && endDate < absoluteEndDate )
        return true ; 
      else
        return false;
      
  }
}

contract RentalMainContract{
    
    /* Private Variables */
    address private _ownerOfContract;
    uint private _fixedSecurityDeposit = .01 ether;
    
    /* Events */
    event RentOfferPlaced(address indexed caller, bytes32 indexed rentOfferHash);
    event RentOfferModified(address indexed caller, bytes32 indexed rentOfferHash);
    event RegisterRenter(address indexed caller, bool indexed registrationStatus);
    event ArbitratorAdded(address indexed caller, address indexed _arbitratorAddress);
    event ArbitratorDeleted(address indexed caller, address indexed _arbitratorAddressDeleted);
    event EscrowContractCreatedForTrade(address indexed renterAddress, address indexed renteeAddress, 
                                        address escrowAddress, bytes32 indexed tradeHash);
    
    /* Models */
    struct RentalOffer{
        uint offeredQuantity;
        address renterAddress;
        address arbitratorAddress;
        uint arbitratorFee;
        uint startDate;
        uint endDate;
        bytes32 placeDetailsHash;
    }
    
    struct RenteeInfo{
        address addressOfRentee;
        uint startTimeOfRent;
        uint endTimeOfRent;
    }
    
    struct RegisteredRenter{
        address addressOfRenter;
        bytes32 renterDetails;
    }
    
    /* List of */
    bytes32[] currentRentOffersHash;
    address[] arbitrators;
    address[] escrowContracts;
    
    /* Mapping */
    // address to position 
    mapping (bytes32 => uint) private rentOfferIndexes; 
    // Stores individual rent offers w.r.t hash
    mapping(bytes32 => RentalOffer) rentals;
    //Stores info of all the current rentee details of a particular offer
    mapping(bytes32 => RenteeInfo[]) rentalsTaken;
    //Stores all the details of the registered renter;
    mapping(address=> RegisteredRenter) registeredRenter;
    
    mapping (address =>uint) private arbitratorAddressIndexes;
    
    mapping (bytes32 => address) private escrowAddressWithRespectToTradeHash;
    
    /* Modifiers */
    modifier OnlyOwner(){
        require(_ownerOfContract == msg.sender);
        _;
    }
   
    /* Constructor */
    constructor() public{
        _ownerOfContract = msg.sender;
    }
    
    /* Arbitrator Functions */
    function addArbitrator(address _arbitratorAddress) external {
        require(msg.sender == _ownerOfContract);
        arbitrators.push(_arbitratorAddress);
        arbitratorAddressIndexes[_arbitratorAddress] = arbitrators.length-1;
        emit ArbitratorAdded(msg.sender, _arbitratorAddress);
    }
    function deleteArbitrator(address _arbitratorAddress) external {
        require(msg.sender == _ownerOfContract);
        address arbitratorAddressAtLastIndex = arbitrators[arbitrators.length-1];
        arbitrators[arbitratorAddressIndexes[_arbitratorAddress]] = arbitratorAddressAtLastIndex;
        delete arbitratorAddressIndexes[_arbitratorAddress];
        arbitrators.length--;
        emit ArbitratorDeleted(msg.sender, _arbitratorAddress);
    }
    
    /* Renter functions */
    
    function registerRenter(address renterAddress, bytes32 renterDetailsHash) external{
        
        //This is useless i think, just need to ensure that the user cannot register someone else.
        require(renterAddress == msg.sender,"Current user cannot register someone else");
        
        //user allready registered
        if(registeredRenter[msg.sender].addressOfRenter == msg.sender){
            //emit RegisterRenter(msg.sender,false);
            revert("User Already Registered");
        }else{
            registeredRenter[renterAddress].addressOfRenter = msg.sender;
            registeredRenter[renterAddress].renterDetails = renterDetailsHash;
            emit RegisterRenter(msg.sender,true);
        }
        
    }
    
    function placeRentOffer(uint offeredQuantity, 
                            uint startDate, 
                            uint endDate,
                            address arbitratorAddress, 
                            bytes32 placeDetailsHash,
                            uint arbitratorFees) external {
                                
        //To check if the offer is placed by a registerd renter                        
        require(registeredRenter[msg.sender].addressOfRenter == msg.sender,"Not a registered renter");
        
        //Date validations
        require(startDate > block.timestamp && block.timestamp < endDate,"Invalid date entry");
        require(startDate < endDate,"Starting date cannot be greater than ending date");
        
        bytes32 rentOfferHash = keccak256(abi.encodePacked(msg.sender, offeredQuantity, startDate, endDate,placeDetailsHash, "Sell"));
        
        //If Same order is allready placed then it cannot be placed again
        require(rentals[rentOfferHash].placeDetailsHash != placeDetailsHash,"Same rent offer cannot be placed twice");
       
        rentals[rentOfferHash].offeredQuantity = offeredQuantity;
        rentals[rentOfferHash].renterAddress = msg.sender;
        rentals[rentOfferHash].arbitratorAddress = arbitratorAddress;
        rentals[rentOfferHash].arbitratorFee = arbitratorFees;
        rentals[rentOfferHash].placeDetailsHash = placeDetailsHash;
        rentals[rentOfferHash].startDate = startDate;
        rentals[rentOfferHash].endDate = endDate;
        
        //An array that keep tracks of the current rent offers by hash
        currentRentOffersHash.push(rentOfferHash);
        
        // storing the position of Address from currentRentOffersTradeHash
        rentOfferIndexes[rentOfferHash] = currentRentOffersHash.length - 1 ;  
        
        emit RentOfferPlaced(msg.sender, rentOfferHash);
    }
    

    function modifyRentOffer(bytes32 rentedOfferHash,
                             uint offeredQuantity, 
                             uint startDate, 
                             uint endDate,
                             address arbitratorAddress, 
                             bytes32 placeDetailsHash,
                             uint arbitratorFees) external {
        
        //To check that the owner is modifying the offer    
        require(rentals[rentedOfferHash].renterAddress == msg.sender,"Only owner can modify the rent offer.");
        
        //To check whether the place is already rented
        require(rentalsTaken[rentedOfferHash[0]].length == 0,"Cannot be modified due to it already being rented");
        
        bytes32 newRentedOfferHash = keccak256(abi.encodePacked(msg.sender, offeredQuantity, startDate, endDate,placeDetailsHash, "Modify"));
            
        RentalOffer storage rentOffer = rentals[newRentedOfferHash];
        rentOffer.offeredQuantity = offeredQuantity;
        rentOffer.renterAddress = msg.sender;
        rentOffer.arbitratorAddress = arbitratorAddress;
        rentOffer.arbitratorFee = arbitratorFees;
        rentOffer.placeDetailsHash = placeDetailsHash;
        currentRentOffersHash[rentOfferIndexes[rentedOfferHash]] = newRentedOfferHash;
        
        emit RentOfferModified(msg.sender,newRentedOfferHash);

    }    
    
    function deleteRentOffer(bytes32 rentedOfferHash) external {
        
        //To check whether any hash exists
        require(rentals[rentedOfferHash].renterAddress != address(0),"No such hash exists");
        
        require(rentals[rentedOfferHash].renterAddress == msg.sender,"Only owner can delete the rent offer");
        //To check whether the place is already rented
        require(rentalsTaken[rentedOfferHash].length == 0,"Rented place exists, cannot delete until rent is completed.");
        
        delete rentals[rentedOfferHash];
        deleteRentOfferHash(rentedOfferHash);
        
    }
     
    function deleteRentOfferHash (bytes32 deleteRentOfferTradeHash) private{
        bytes32 rentedHashAtLastIndex = currentRentOffersHash[currentRentOffersHash.length-1];
        currentRentOffersHash[rentOfferIndexes[deleteRentOfferTradeHash]] = rentedHashAtLastIndex ;
        delete rentOfferIndexes[deleteRentOfferTradeHash];
        currentRentOffersHash.length--;
    }
    
    /* Renter Helper functions */
    
    function isUserARegisteredRenter(address userAddress) external view returns(bool){
        if(registeredRenter[userAddress].addressOfRenter != address(0))
            return true;
        return false;
    }
    
    /* Rentee functions */
    
    function takeRentOffer(bytes32 rentOfferHash, uint renteesGivenStartDate, uint renteesGivenEndDate) external{
        
        //Checks whether the renter address is present in the rentals
        require(rentals[rentOfferHash].renterAddress != address(0),"Offer does not exist i.e. renter address empty");
        
        //Checks the current time which should be in between absolute start and absolute end date
        require (block.timestamp < rentals[rentOfferHash].endDate,"Absolute end date has now passed");
        
        //Checks for proper time given by rentee
        require (renteesGivenStartDate > now && now < renteesGivenEndDate,"Dates given by rentee are invalid.");
        
        //Checks the start date and the end date is in range
        if(!(SystemDateTime.isDateSubsetInRange(renteesGivenStartDate,renteesGivenEndDate,rentals[rentOfferHash].startDate,rentals[rentOfferHash].endDate))) revert("Range is not available in the rent");
        
        //Checks whether that same range exists in the rentals that were taken (Very important)
        if(isDateRangeTakenInOffer(rentOfferHash,renteesGivenStartDate,renteesGivenEndDate)) revert("Date range is taken in offer");
        
        makeEntryInRentalsTaken(rentOfferHash,renteesGivenStartDate,renteesGivenEndDate);
        
        //Start Escrow Here
        createEscrowContract(rentOfferHash,
                            rentals[rentOfferHash].renterAddress,
                            msg.sender,
                            rentals[rentOfferHash].arbitratorAddress,
                            rentals[rentOfferHash].arbitratorFee,
                            rentals[rentOfferHash].startDate,
                            rentals[rentOfferHash].endDate,
                            renteesGivenStartDate,
                            renteesGivenEndDate,
                            rentals[rentOfferHash].offeredQuantity);
        
    } 
    
    /* Helper Functions */
    
    function createEscrowContract (bytes32 rentOfferHash, 
                                   address renterAddress, 
                                   address renteeAddress, 
                                   address arbitratorAddress, 
                                   uint arbitratorFees,
                                   uint startDateOfRent,
                                   uint endDateOfRent,
                                   uint renteesGivenStartDate,
                                   uint renteesGivenEndDate,
                                   uint offeredAmount) private {
                                       
        //Add reusability of escrow addresses here
        
        address escrowAddress = new RentalEscrowContract(rentOfferHash, renterAddress, renteeAddress, 
                                                arbitratorAddress, arbitratorFees, startDateOfRent, 
                                                endDateOfRent, renteesGivenStartDate,renteesGivenEndDate,
                                                offeredAmount,_fixedSecurityDeposit);
        //Should i send escrow amount (needed eth + security deposit) from here or ...                                        
        
        escrowContracts.push(escrowAddress);
        escrowAddressWithRespectToTradeHash[rentOfferHash] = escrowAddress;
        emit EscrowContractCreatedForTrade(renterAddress, renteeAddress, escrowAddress, rentOfferHash);
    }
    
    function setSecurityDeposit(uint securityDeposit) OnlyOwner external {
        _fixedSecurityDeposit = securityDeposit;
    }
    
    function isDateRangeTakenInOffer(bytes32 rentOfferHash,uint startDate, uint endDate) private view returns (bool){
        RenteeInfo[] storage renteeInfo = rentalsTaken[rentOfferHash];
        for(uint i=0;i < renteeInfo.length; i++){
            if(!((startDate <= renteeInfo[i].startTimeOfRent && endDate <= renteeInfo[i].startTimeOfRent) || 
            (startDate >= renteeInfo[i].endTimeOfRent && endDate >= renteeInfo[i].endTimeOfRent)))
                return true;
        }
        return false;
    }
    
    function makeEntryInRentalsTaken(bytes32 rentOfferHash,uint startDate, uint endDate) private{
        RenteeInfo[] storage renteeInfo = rentalsTaken[rentOfferHash];
        renteeInfo.push(RenteeInfo(msg.sender,startDate,endDate));
    } 
    
}



/*
Docs:
Role: Renter
When a renter places a listing, the required information should be address, currentDate, offered quantity in eth,
start date, end date, the hash of the place details and the nature of the order i.e. sell or buy

*/