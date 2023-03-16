// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "https://github.com/0xcert/ethereum-erc721/src/contracts/token/ERC20/ERC20.sol";

contract BadLotteryGame {
    uint256 public prizeAmount;         // payout amount
    address payable[] public players;    
    uint256 public num_players;        
    address payable[] public prize_winners; 
    event winnersPaid(uint256);

    constructor() {}

    // There is no access control on this function, so anyone can call it and 
    // add themselves to the players array.
    // this function does not validate the _playerAddress parameter, so anyone
    // can call this function and add any address to the players array.
    function addNewPlayer(address payable _playerAddress) public payable {
        if (msg.value == 500000) {
            players.push(_playerAddress);
        }
        num_players++;
        if (num_players > 50) {
            emit winnersPaid(prizeAmount);
        }
    }

    // This function is using the block timestamp as a random number generator.
    // This is not a good idea, because the timestamp is not a random number.
    // Anyone can call this function and add themselves to the prize_winners array.
    function pickWinner(address payable _winner) public {
        if ( block.timestamp % 15 == 0){    // use timestamp for random number
            prize_winners.push(_winner);
        }          
    }

    // This function is vulnerable to reentrancy attacks.
    // It distributes the prize to the prize_winners array, but it does not check
    // if the prize_winners array is empty. If the prize_winners array is empty,
    // the function will still try to distribute the prize, which will cause a
    // reentrancy attack.
    function payout() public {
        if (address(this).balance == 500000 * 100) {
            uint256 amountToPay = prize_winners.length / 100;
            distributePrize(amountToPay);
        }
    }

    // This function should use the less than operator (<) instead of the less
    // than or equal to operator (<=) to avoid an out of bounds array access.
    function distributePrize(uint256 _amount) public {
        for (uint256 i = 0; i <= prize_winners.length; i++) {
            prize_winners[i].transfer(_amount);
        }
    }

    // The contrat does not have a withdraw function, so the players cannot
    // withdraw their funds if they lose or chose to stop playing the game.

    // The contract does not have a fallback function, so if the contract
    // receives ether, it will be lost.

    // The contract does not have a safe math library, so it is vulnerable to
    // integer overflow and underflow attacks.
}