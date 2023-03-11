// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

contract DogCoin {
    string public name = "DogCoin";
    string public symbol = "DOG";
    uint256 public _totalSupply = 2000000;
    address public owner;

    // mapping to store the balances of each address
    // 2. balanceOf(msg.sender)
    mapping(address => uint256) balances;

    // mapping to store an array for each address that stores the details of all the transactions made by that address
    mapping(address => Payment[]) payments;

    // event that emits the new value when the total supply changes
    event Mint(uint256 amount);

    // event that emits the sender, receiver and amount when a transfer happens
    event Transfer(address indexed from, address indexed to, uint256 amount);

    // struct to store the details of a transaction
    struct Payment {
        address to;
        uint256 amount;
        uint256 timestamp;
    }

    // modifier to check if the sender is the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    constructor() {
        // set the total supply to owner's balance
        balances[msg.sender] = _totalSupply;
        owner = msg.sender;
    }

    // public function that returns the total supply
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    // public function that can increase the total supply by increments of 1000
    // function mint() public {
    //     _totalSupply += 1000;
    // }

    // public function that can increase the total supply by increments of 1000 but only if the sender is the owner
    function mint() public onlyOwner {
        _totalSupply += 1000;

        // emit Mint event with the new total supply
        emit Mint(_totalSupply);
    }

    // public function that returns the balance of an address
    function balanceOf(address _address) public view returns (uint256) {
        return balances[_address];
    }

    // public function that transfers tokens from the sender to another address
    // we do not need senders address as a parameter because we can get it from msg.sender
    // If we incllude the sender address as a parameter, then anyone can transfer tokens from any address
    function transfer(address _to, uint256 _amount) public {
        // check if the sender has enough tokens
        require(balances[msg.sender] >= _amount, "Not enough tokens");

        // check if the amount is greater than 0
        require(_amount > 0, "Amount should be greater than 0");

        // add to the array of transactions made by the sender
        payments[msg.sender].push(Payment(_to, _amount, block.timestamp));

        // transfer the tokens
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;

        // emit Transfer event
        emit Transfer(msg.sender, _to, _amount);
    }

    // public function that returns the details of all the transactions made by an address
    function getPayments(address _address) public view returns (Payment[] memory) {
        return payments[_address];
    }
}