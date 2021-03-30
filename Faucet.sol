pragma solidity ^0.8.0;
contract Faucet {
    address owner;
    uint256 sendAmount;
    mapping (address => uint) lastSent;
    uint public timeLimit;
    constructor()payable{
        owner = msg.sender;
        sendAmount = 1000000000000000;
        timeLimit = 1 days;
    }
    modifier onlyowner(){
        require(msg.sender==owner,"Must be owner");
        _;
    }
    /**
	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
	 * Can only be called by the current owner.
	 */
	function transferOwnership(address newOwner) public onlyowner {
		_transferOwnership(newOwner);
	}
	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

	/**
	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
	 */
	function _transferOwnership(address newOwner) internal {
		require(newOwner != address(0), "Ownable: new owner is the zero address");
		emit OwnershipTransferred(owner, newOwner);
		owner = newOwner;
	}
	function getBalance() public view returns (uint){
	     return address(this).balance;
	}
	function getWei() public payable  returns (bool){
	    if(lastSent[msg.sender]<=(block.timestamp-timeLimit)&&address(this).balance>sendAmount){
	        payable(msg.sender).transfer(sendAmount);
	        lastSent[msg.sender] = block.timestamp;
	        return true;
	    } else {
	        return false;
	    }
	}
	function getRemainingTime() public view  returns (uint){
	     if(timeLimit>(block.timestamp-lastSent[msg.sender]))
          return timeLimit-(block.timestamp-lastSent[msg.sender]);
       else
          return 0;
	}
	function setTimeLimit(uint limit) public onlyowner {
	        timeLimit = limit;
	}
	function setSendAmount(uint256 val)public onlyowner{
	        sendAmount = val;
	       
	}
	function killMe() public onlyowner{
	        selfdestruct(payable(owner));
	}
}
