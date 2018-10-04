pragma solidity ^0.4.24;

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