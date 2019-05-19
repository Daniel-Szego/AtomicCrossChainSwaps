// Alice initiates a hased timelock conditional payment to Bob on chain 1
contract AliceHTLC_Chain1 {

    // from address
    address payable public fromAlice;
    // to address
    address payable public toBob;
    // timeout
    uint256 public timeOut;
    // hashlock
    bytes32 public hashLock;    
    // hacked timelock
    bool public timelock;
    

    // contructor
    constructor(address payable _toBob, bytes32 _hashLock, uint256 _timeOut) public {
        fromAlice = msg.sender;
        toBob = _toBob;
        hashLock = _hashLock;
        timeOut = now + (_timeOut * (1 minutes));
        timelock = true;
    }    
        
    function patchTimeLock() public{
        timelock = false;
    }    
        
    // allow payments
    function () payable external {}
    
    // getting contract balance
    function getBalance() public view returns (uint256){
        return address(this).balance;
    } 
    
    // executing the transaction -> Bob gets the payment
    // if valid secretHash presented
    // if timeout still not reached
    function claim(string memory _secretHash) public {
       require(hashLock == sha256(abi.encodePacked(_secretHash)));
       require((now <= timeOut) || (timelock == false));
       toBob.transfer(address(this).balance);        
    }

    // reverting the transaction -> Alice gets the payment back
    // only if timeout still already reached    
    function expire() public {
      require((now > timeOut) || (timelock == false));
     fromAlice.transfer(address(this).balance);
    }
}

// Bob initiates a hased timelock conditional payment to Alice on chain 2
contract BobHTLC_Chain2 {

    // from address
    address payable public fromBob;
    // to address
    address payable public toAlice;
    // timeout
    uint256 public timeOut;
    // hashlock
    bytes32 public hashLock;    
    // hacked timelock
    bool public timelock;


    // contructor
    constructor (address payable _toAlice, bytes32 _hashLock, uint256 _timeOut) public {
        fromBob = msg.sender;
        toAlice = _toAlice;
        hashLock = _hashLock;
        timeOut = now + _timeOut * (1 minutes);
        timelock = true;
    }    
        
    function patchTimeLock() public {
       timelock = false;
    }    

    // allow payments
    function () payable external {}
    
    // getting contract balance
    function getBalance() public view returns (uint256){
        return address(this).balance;
    } 
    
    // executing the transaction -> Alice gets the payment
    // if valid secretHash presented
    // if timeout still not reached
    function claim(string memory _secretHash) public {
       require(hashLock == sha256(abi.encodePacked(_secretHash)));
        require((now <= timeOut) || (timelock == false));
       toAlice.transfer(address(this).balance);        
    }

    // reverting the transaction -> Bob gets the payment back
    // only if timeout still already reached    
    function expire() public {
     require((now > timeOut) || (timelock == false));
     fromBob.transfer(address(this).balance);
    }
}