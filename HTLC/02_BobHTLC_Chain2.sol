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

    // contructor
    constructor (address payable _toAlice, bytes32 _hashLock, uint256 _timeOut) public {
        fromBob = msg.sender;
        toAlice = _toAlice;
        hashLock = _hashLock;
        timeOut = now + _timeOut * (1 minutes);            
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
       require(now <= timeOut);
       toAlice.transfer(address(this).balance);        
    }

    // reverting the transaction -> Bob gets the payment back
    // only if timeout still already reached    
    function expire() public {
     require(now > timeOut);
     fromBob.transfer(address(this).balance);
    }
}