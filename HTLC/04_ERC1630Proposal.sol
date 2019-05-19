contract ETHSwap {
  bytes32 secretHash;
  uint256 expiration;
  address payable buyer;
  address payable seller;

  constructor (bytes32 _secretHash, uint256 _expiration, address payable _buyer) public payable {
    secretHash = _secretHash;
    expiration = _expiration;
    buyer = _buyer;
    seller = msg.sender;
  }

  function claim (string _secret) public {
    require(secretHash == sha256(abi.encodePacked(_secret)));
    require(now <= expiration);
    buyer.transfer(address(this).balance);
  }

  function expire () public {
    require(now > expiration);
    seller.transfer(address(this).balance);
  }
}

