pragma solidity ^0.7.6;

interface ExternalContract { 
	function updateOwner(address newOwner) external;
}

contract Ownable {
    address public owner;
    modifier onlyOwner(){
        require(owner == msg.sender, "Ownable: function can only be called by contract owner");
        _;
    }
}

contract Guardian is Ownable {
	mapping(address => mapping(address => bool)) guardianApprovals;
	mapping(address => mapping(address => uint256)) guardianBlocks;
	constructor(){
		owner = msg.sender;
	}
	function setGuardian(address newGuardian, uint256 blockNumber) external onlyOwner(){
		guardianApprovals[owner][newGuardian] = true;
		guardianBlocks[owner][newGuardian] = blockNumber;
	}
	function updateOwner(address newOwner) external {
		require(guardianApprovals[owner][msg.sender]==true, "updateOwner: msg.sender is not an approved guardian")
		require(guardianBlocks[owner][msg.sender]<=true, "updateOwner: msg.sender is not an approved guardian")
		owner = newOwner;
	}
}

contract GuardianV2 is Ownable {
	mapping(address => mapping(address => bool)) guardianApprovals;
	mapping(address => mapping(address => uint256)) guardianBlocks;
	address public externalContractAddress;
	constructor(_externalContractAddress){
		owner = msg.sender;
		externalContractAddress = _externalContractAddress;
	}
	function setGuardian(address newGuardian, uint256 blockNumber) external onlyOwner(){
		guardianApprovals[owner][newGuardian] = true;
		guardianBlocks[owner][newGuardian] = blockNumber;
	}
	function updateOwner(address newOwner) external {
		require(guardianApprovals[owner][msg.sender]==true, "updateOwner: msg.sender is not an approved guardian")
		require(guardianBlocks[owner][msg.sender]<=true, "updateOwner: msg.sender is not an approved guardian")
		ExternalContract(externalContractAddress).updateOwner(newOwner);
	}
}