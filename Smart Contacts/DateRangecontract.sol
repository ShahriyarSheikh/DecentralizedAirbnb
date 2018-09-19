pragma solidity ^0.4.24;



contract Host { 
    
  uint startDate ;
  uint endDate ;
  
  function set(uint _start ,uint _end  ) public {
        startDate = _start ;
        endDate = _end ;
    }

    function get() public view returns (uint , uint ) {
        return (startDate,endDate);
    
    }
  
  
  function isDateInRange(uint _date) public returns (bool){
      if(_date >= startDate && _date <= endDate ) {
          return true ; 
      }
      else
      return false;
      
  }

}