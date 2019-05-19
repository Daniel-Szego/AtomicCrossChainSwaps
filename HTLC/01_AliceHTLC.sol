// Alice initiates a hased timelock conditional payment to Bob on chain 1
contract AliceHTLC_Chain1 {

    // from address
    address public fromAlice;
    // to address
    address public toBob;
    // timeout
    unit256 public timeOut;
    // hashlock
    bytes32 hashLock;    

    // contructor
    function AliceHTLC_Chain1(address _toBob, byte32 _hashLock, uint256 _timeOut){
        fromAlice = msg.sender;
        toBob = _toBob;
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
       toBob.transfer(address(this).balance);        
    }

    // reverting the transaction -> Alice gets the payment
    // only if timeout still already reached    
    function expire() public {
     require(now > timeOut);
     fromAlice.transfer(address(this).balance);
    }
}

