pragma solidity ^0.4.16;

contract RentalMainContract{
    
    event RentOfferPlaced(address indexed caller, bytes32 indexed tradeHash);
    
    address _ownerOfContract;
    address _tokenAddress;
    address _hotWalletAddress;
    uint _commissionFees;
    
    bytes32[] currentRentOffersTradeHash;
    
    
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
    
    constructor(address tokenAddress, address hotWalletAddress, uint commissionFees) public {
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
                                
        bytes32 tradeHash = keccak256(msg.sender, now, offeredQuantityInETH, renteeAddress, startDate, endDate,placeDetailsHash, "Sell");
        
        if(rentals[tradeHash].renterAddress != address(0)) revert();
        
        //Proper date validations
        if(rentals[tradeHash].startDate < now) revert();
        
        RentalOffer storage offer = rentals[tradeHash];
       
        offer.offeredQuantityInETH = offeredQuantityInETH;
        offer.renterAddress = msg.sender;
        offer.arbitratorAddress = arbitratorAddress;
        offer.arbitratorFee = arbitratorFees;
        currentRentOffersTradeHash.push(tradeHash);
        emit RentOfferPlaced(msg.sender, tradeHash);
    }

    function modifyRentOffer(bytes32 rentedPlaceHash, bytes32 placeDetailsHash){
        
    }
    
    function deleteRentOffer(bytes32 rentedPlaceHash){
        
    }
    
    
    
}