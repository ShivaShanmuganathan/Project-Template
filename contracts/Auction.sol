// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface IERC721 {
    function transferFrom(
        address from,
        address to,
        uint nftId
    ) external;
}

contract EnglishAuction {
    event Start();
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);
    event End(address winner, uint amount);

    IERC721 public immutable nft;
    uint public immutable nftId;

    address payable public immutable seller;
    uint public endAt;
    bool public started;
    bool public ended;

    address public highestBidder;
    uint public highestBid;
    // mapping from bidder to amount of ETH the bidder can withdraw
    mapping(address => uint) public bids;

    constructor(
        address _nft,
        uint _nftId,
        uint _startingBid
    ) {
        nft = IERC721(_nft);
        nftId = _nftId;

        seller = payable(msg.sender);
        highestBid = _startingBid;
    }

    function start() external onlySeller{
        
        require(!started, "Already Started");
        started = true;
        endAt = block.timestamp + 7 days;
        nft.transferFrom(msg.sender, address(this), nftId);
        emit Start();
        
    }

    function bid() external payable {
        
        require(started, "Not Started");
        require(!ended, "Ended");
        require(msg.value > highestBid, "not the highestBid");
        
        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }
        
        highestBidder = msg.sender;
        highestBid = msg.value;
        emit Bid(msg.sender, msg.value);
        
    }

    function withdraw() external {
        // Write your code here
        uint amount = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
        
    }
    

    function end() external {
        // Write your code here
        require(started, "Not Started");
        require(endAt < block.timestamp, "Not Expired");
        require(!ended, "Ended Auction");
        ended = true;
        nft.transferFrom(address(this), highestBidder, nftId);
        seller.transfer(highestBid);
        emit End(highestBidder, highestBid);
        
    }
    
    modifier onlySeller() {
        require(msg.sender == seller, "not the seller");
        _;
    }
}
