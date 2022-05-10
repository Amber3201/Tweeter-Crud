//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Tweeter {
    struct Tweet {
        address owner;
        string content;
    }

    Tweet[] private tweets;

    uint public numTweets;

    constructor() {
        numTweets = 0;
    }

    event addedTweet(address id, Tweet title);
    event removedTweet(address id, Tweet title);
    event updatedTweet(address id, Tweet title);

    function createTweet(string memory content) public returns (uint) {
        Tweet memory t = Tweet(msg.sender, content);
        tweets.push(t);
        numTweets++;
        emit addedTweet(msg.sender, t);
        return numTweets;
    }

    function updateTweet(uint id, string memory content) public returns (uint) {
        require(id < numTweets, "Tweet Doesn't exist");
        require(
            tweets[id].owner == msg.sender,
            "You are not the owner of this tweet"
        );
        Tweet memory t = tweets[id];
        t.content = content;
        tweets[id] = t;
        emit updatedTweet(msg.sender, t);
        return numTweets;
    }

    function removeTweetWorker(uint index) private {
        for (uint i = index; i < numTweets - 1; i++) {
            tweets[i] = tweets[i + 1];
        }
        tweets.pop();
    }

    function removeTweet(uint id) public returns (uint) {
        require(id < numTweets, "Tweet Doesn't exist");
        require(
            tweets[id].owner == msg.sender,
            "You are not the owner of this tweet"
        );
        Tweet memory t = tweets[id];
        removeTweetWorker(id);
        numTweets--;
        emit removedTweet(msg.sender, t);
        return numTweets;
    }

    function getTweet(uint id) public view returns (Tweet memory) {
        require(id < numTweets, "Tweet Doesn't exist");
        return tweets[id];
    }

    function listTweets() public view returns (Tweet[] memory) {
        return tweets;
    }

    // function greet() public view returns (string memory) {
    //     return greeting;
    // }

    // function setGreeting(string memory _greeting) public {
    //     console.log("Changing greeting from '%s' to '%s'", greeting, _greeting);
    //     greeting = _greeting;
    // }
}
