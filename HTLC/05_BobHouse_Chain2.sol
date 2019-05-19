// Bob initiates a hased timelock conditional payment to Alice on chain 2
contract BobHouse_Chain2 {

    // from address
    address public addressBob;
    // to address
    address public addressAlice;
    // timeout
    uint256 public timeOut;
    // hashlock
    bytes32 public hashLock;    
    // houseowner
    address public addressHouseOwner;

    // do I own the house
    function DoIOwnTheHouse() view public returns (bool) {
        if(msg.sender == addressHouseOwner){
            return true;        
        }
        return false;
    }    
    
    // contructor
    constructor (address _toAlice, bytes32 _hashLock, uint256 _timeOut) public {
        addressBob = msg.sender;
        addressAlice = _toAlice;
        hashLock = _hashLock;
        timeOut = now + (_timeOut * (1 minutes));
        addressHouseOwner = addressBob;
    }    
        
    // initializing house transfer
    // hause will be transferred to a temporal address which is the address of the contract
    // it is implemented as an external contract, because at the constructor call time the address of the contract is still not knonw 
    function InitHouseTransfer() public {
        require(msg.sender == addressBob);
        require(addressHouseOwner == addressBob);
        addressHouseOwner = address(this);    
    }
    
    // executing the transaction -> Alice gets the house 
    // if valid secretHash presented
    // if timeout still not reached
    function claim(string _secretHash) public {
       require(hashLock == sha256(abi.encodePacked(_secretHash)));
       require(now <= timeOut);
       addressHouseOwner = addressAlice;    
    }

    // reverting the transaction -> Bob gets the hause back
    // only if timeout still already reached    
    function expire() public {
     require(now > timeOut);
     addressHouseOwner = addressBob;
    }
}
