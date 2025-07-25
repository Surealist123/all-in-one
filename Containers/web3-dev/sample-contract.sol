// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title PrivateContract
 * @dev A sample smart contract for private Web3 development
 */
contract PrivateContract {
    mapping(address => uint256) private balances;
    mapping(address => bool) private authorizedUsers;
    
    address private owner;
    
    event BalanceUpdated(address indexed user, uint256 newBalance);
    event UserAuthorized(address indexed user);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    modifier onlyAuthorized() {
        require(authorizedUsers[msg.sender] || msg.sender == owner, "Not authorized");
        _;
    }
    
    constructor() {
        owner = msg.sender;
        authorizedUsers[msg.sender] = true;
    }
    
    function authorizeUser(address user) external onlyOwner {
        authorizedUsers[user] = true;
        emit UserAuthorized(user);
    }
    
    function updateBalance(uint256 newBalance) external onlyAuthorized {
        balances[msg.sender] = newBalance;
        emit BalanceUpdated(msg.sender, newBalance);
    }
    
    function getBalance() external view onlyAuthorized returns (uint256) {
        return balances[msg.sender];
    }
    
    function isAuthorized(address user) external view returns (bool) {
        return authorizedUsers[user];
    }
}