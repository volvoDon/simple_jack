// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleJackpot {
    address payable public owner;
    uint256 public betAmount;

    event Payout(address indexed winner, uint256 amount);

    constructor(uint256 _betAmount) {
        owner = payable(msg.sender);
        betAmount = _betAmount;
    }

    function play() external payable {
        require(msg.value == betAmount, "Invalid bet amount.");

        uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 10;

        if (randomNumber == 0) {
            uint256 payoutAmount = betAmount * 10;
            require(address(this).balance >= payoutAmount, "Insufficient contract balance.");

            payable(msg.sender).transfer(payoutAmount);
            emit Payout(msg.sender, payoutAmount);
        } else {
            owner.transfer(msg.value);
        }
    }

    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw.");
        owner.transfer(address(this).balance);
    }

    function setBetAmount(uint256 _betAmount) external {
        require(msg.sender == owner, "Only owner can set the bet amount.");
        betAmount = _betAmount;
    }
}
