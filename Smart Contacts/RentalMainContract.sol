pragma solidity ^0.4.16;

contract RentalMainContract{
    
    event RentOfferPlaced(address indexed caller, bytes32 indexed rentOfferHash);
    
    address _ownerOfContract;
    address _tokenAddress;
    address _hotWalletAddress;
    uint _commissionFees;
    
    bytes32[] currentRentOffersHash;
    
    mapping (bytes32 => uint) private rentOfferIndexes; // address to position 
    mapping(bytes32 => RentalOffer) rentals;
    
    struct RentalOffer{
        uint offeredQuantityInETH;
        address renterAddress;
        address renteeAddress;
        address arbitratorAddress;
        uint arbitratorFee;
        uint startDate;
        uint endDate;
        bytes32 placeDetailsHash;
    }
    
    constructor(address tokenAddress, address hotWalletAddress, uint commissionFees) public{
        _ownerOfContract = msg.sender;
        _tokenAddress = tokenAddress;
        _hotWalletAddress = hotWalletAddress;
        _commissionFees = commissionFees;
    }
    
    function placeRentOffer(uint offeredQuantityInETH, 
                            address renteeAddress, 
                            uint startDate, 
                            uint endDate,
                            address arbitratorAddress, 
                            bytes32 placeDetailsHash,
                            uint arbitratorFees) external {
                                
        bytes32 rentOfferHash = keccak256(abi.encodePacked(msg.sender, now, offeredQuantityInETH, renteeAddress, startDate, endDate,placeDetailsHash, "Sell"));
        
        if(rentals[rentOfferHash].renterAddress != address(0)) revert();
        
        //Proper date validations
        if(rentals[rentOfferHash].startDate < now) revert();
        
        RentalOffer storage offer = rentals[rentOfferHash];
       
        offer.offeredQuantityInETH = offeredQuantityInETH;
        offer.renterAddress = msg.sender;
        offer.arbitratorAddress = arbitratorAddress;
        offer.arbitratorFee = arbitratorFees;
        currentRentOffersHash.push(rentOfferHash);
        rentOfferIndexes[rentOfferHash] = currentRentOffersHash.length - 1 ; // storing the position of Address from currentRentOffersTradeHash 
        emit RentOfferPlaced(msg.sender, rentOfferHash);
    }

    function modifyRentOffer(bytes32 rentedOfferHash,
                            uint offeredQuantityInETH, 
                            uint startDate, 
                            uint endDate,
                            address arbitratorAddress, 
                            bytes32 placeDetailsHash,
                             uint arbitratorFees) external {
            
        require(rentals[rentedOfferHash].renterAddress == msg.sender);
        require(rentals[rentedOfferHash].renteeAddress == address(0));
        if(rentals[rentedOfferHash].renterAddress != address(0)) revert();
            
        bytes32 newRentedOfferHash = keccak256(abi.encodePacked(msg.sender, now, offeredQuantityInETH, address(0), startDate, endDate,placeDetailsHash, "Modify"));
            
        RentalOffer storage rentOffer = rentals[newRentedOfferHash];
        
        rentOffer.offeredQuantityInETH = offeredQuantityInETH;
        rentOffer.renterAddress = msg.sender;
        rentOffer.arbitratorAddress = arbitratorAddress;
        rentOffer.arbitratorFee = arbitratorFees;
        currentRentOffersHash[rentOfferIndexes[rentedOfferHash]] = newRentedOfferHash;

    }    
    
    function deleteRentOffer(bytes32 rentedOfferHash) external {
             
        require(rentals[rentedOfferHash].renterAddress == msg.sender);
        require(rentals[rentedOfferHash].renteeAddress == address(0));
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