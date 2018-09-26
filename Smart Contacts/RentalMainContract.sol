pragma solidity ^0.4.16;

contract RentalMainContract{
    
    //Private variables
    address _ownerOfContract;
    address _tokenAddress;
    address _hotWalletAddress;
    uint _commissionFees;
    
    // Events
    event RentOfferPlaced(address indexed caller, bytes32 indexed rentOfferHash);
    event RentOfferModified(address indexed caller, bytes32 indexed rentOfferHash);
    event RegisterRenter(address indexed caller, bool indexed registrationStatus);
    
    //Models
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
    
    bytes32[] currentRentOffersHash;
    
    mapping (bytes32 => uint) private rentOfferIndexes; // address to position 
    mapping(bytes32 => RentalOffer) rentals;
    //Stores info of all the current rentee details of a particular offer
    mapping(bytes32 => RenteeInfo[]) rentalsTaken;
    //Stores all the details of the registered renter;
    mapping(address=> RegisteredRenter) registeredRenter;
   
   
    constructor(address tokenAddress, address hotWalletAddress, uint commissionFees) public{
        _ownerOfContract = msg.sender;
        _tokenAddress = tokenAddress;
        _hotWalletAddress = hotWalletAddress;
        _commissionFees = commissionFees;
    }
    
    
    
    
    function registerRenter(address renterAddress, bytes32 renterDetailsHash) external{
        
        //This is useless i think, just need to ensure that the user cannot register someone else.
        require(renterAddress == msg.sender);
        
        //user allready registered
        if(registeredRenter[renterAddress].addressOfRenter == msg.sender){
            emit RegisterRenter(msg.sender,false);
            revert();
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
                                
        //TO CHECK IF THE OFFER IS PLACED by a registerd renter                        
        require(registeredRenter[msg.sender].addressOfRenter == msg.sender);
        
        //Date validations
        require(startDate > now && now < endDate);
        if(startDate >= endDate ) revert();
        
        bytes32 rentOfferHash = keccak256(abi.encodePacked(msg.sender, offeredQuantity, startDate, endDate,placeDetailsHash, "Sell"));
        
        //If Same order is allready placed then it cannot be placed again
        if(rentals[rentOfferHash].placeDetailsHash == placeDetailsHash) revert();
       
        rentals[rentOfferHash].offeredQuantity = offeredQuantity;
        rentals[rentOfferHash].renterAddress = msg.sender;
        rentals[rentOfferHash].arbitratorAddress = arbitratorAddress;
        rentals[rentOfferHash].arbitratorFee = arbitratorFees;
        rentals[rentOfferHash].placeDetailsHash = placeDetailsHash;
        
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
        require(rentals[rentedOfferHash].renterAddress == msg.sender);
        
        //To check whether the place is already rented
        require(rentalsTaken[rentedOfferHash].length == 0);
        
        bytes32 newRentedOfferHash = keccak256(abi.encodePacked(msg.sender, offeredQuantity, address(0), startDate, endDate,placeDetailsHash, "Modify"));
            
        RentalOffer storage rentOffer = rentals[newRentedOfferHash];
        rentOffer.offeredQuantity = offeredQuantity;
        rentOffer.renterAddress = msg.sender;
        rentOffer.arbitratorAddress = arbitratorAddress;
        rentOffer.arbitratorFee = arbitratorFees;
        rentOffer.placeDetailsHash = newRentedOfferHash;
        currentRentOffersHash[rentOfferIndexes[rentedOfferHash]] = newRentedOfferHash;
        
        emit RentOfferModified(msg.sender,newRentedOfferHash);

    }    
    
    function deleteRentOffer(bytes32 rentedOfferHash) external {
             
        require(rentals[rentedOfferHash].renterAddress == msg.sender);
        //To check whether the place is already rented
        require(rentalsTaken[rentedOfferHash].length == 0);
        
        delete rentals[rentedOfferHash];
        deleteRentOfferHash(rentedOfferHash);
        
    }
     
    function deleteRentOfferHash (bytes32 deleteRentOfferTradeHash) private{
        bytes32 rentedHashAtLastIndex = currentRentOffersHash[currentRentOffersHash.length-1];
        currentRentOffersHash[rentOfferIndexes[deleteRentOfferTradeHash]] = rentedHashAtLastIndex ;
        delete rentOfferIndexes[deleteRentOfferTradeHash];
        currentRentOffersHash.length--;
    }
    
}



/*
Docs:
Role: Renter
When a renter places a listing, the required information should be address, currentDate, offered quantity in eth,
start date, end date, the hash of the place details and the nature of the order i.e. sell or buy

*/