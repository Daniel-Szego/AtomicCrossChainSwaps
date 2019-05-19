pragma solidity ^0.4.18;

contract HTLC {
    
////////////////
//Global VARS//////////////////////////////////////////////////////////////////////////
//////////////

    string public version = "0.0.1";
    bytes32 public digest = 0x;
    address public dest = 0x;
    uint public timeOut = now + 1 hours;
    address issuer = msg.sender; 

/////////////
//MODIFIERS////////////////////////////////////////////////////////////////////
////////////

    
    modifier onlyIssuer {require(msg.sender == issuer); _; }

//////////////
//Operations////////////////////////////////////////////////////////////////////////
//////////////

/* public */   
    //a string is subitted that is hash tested to the digest; If true the funds are sent to the dest address and destroys the contract    
    function claim(string _hash) public returns(bool result) {
       require(digest == sha256(_hash));
       selfdestruct(dest);
       return true;
       }
    
    // allow payments
    function () public payable {}

/* only issuer */
    //if the time expires; the issuer can reclaim funds and destroy the contract
    function refund() onlyIssuer public returns(bool result) {
        require(now >= timeOut);
        selfdestruct(issuer);
        return true;
    }
}

