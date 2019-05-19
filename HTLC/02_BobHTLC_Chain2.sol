// Bob initiates a hased timelock conditional payment to Alice on chain 2
contract BobHTLC_Chain2 {

    // from address
    address public fromBob;
    // to address
    address public toAlice;
    // timeout
    unit256 public timeOut;
    // hashlock
    bytes32 hashLock;    

    // contructor
    function BobHTLC_Chain2(address _toAlice, byte32 _hashLock, uint256 _timeOut){
        fromBob = msg.sender;
        toAlice = _toAlice;
        hashLock = _hashLock;
        timeOut = now + _timeOut minutes;            
    }    
        
    // allow payments
    function () public payable {}
    
    // executing the transaction -> Bob gets the payment
    // if valid secretHash presented
    // if timeout still not reached
    function claim(string _secretHash) public {
       require(digest == sha256(_secretHash));
       require(now <= timeOut);
       toAlice.transfer(address(this).balance);        
    }

    // reverting the transaction -> Alice gets the payment
    // only if timeout still already reached    
    function expire() public {
     require(now > timeOut);
     fromBob.transfer(address(this).balance);
    }
}

