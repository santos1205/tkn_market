// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFTMarketplace is ReentrancyGuard {
    struct Listing {
        address seller;
        uint256 price;
    }

    mapping(address => mapping(uint256 => Listing)) public listings;

    event Listed(address indexed nftAddress, uint256 indexed tokenId, address seller, uint256 price);
    event Bought(address indexed nftAddress, uint256 indexed tokenId, address buyer, uint256 price);

    function listNFT(address nftAddress, uint256 tokenId, uint256 price) external nonReentrant {
        require(price > 0, "Price must be greater than zero");
        
        IERC721 nft = IERC721(nftAddress);
        require(nft.ownerOf(tokenId) == msg.sender, "Not the owner of the NFT");
        require(nft.isApprovedForAll(msg.sender, address(this)), "Marketplace not approved");

        listings[nftAddress][tokenId] = Listing(msg.sender, price);
        emit Listed(nftAddress, tokenId, msg.sender, price);
    }

    function buyNFT(address nftAddress, uint256 tokenId) external payable nonReentrant {
        Listing memory listing = listings[nftAddress][tokenId];
        
        require(listing.price > 0, "NFT not listed for sale"); // Ensure NFT is listed
        require(msg.value == listing.price, "Incorrect price"); // Ensure correct payment amount
        require(msg.sender != listing.seller, "Seller cannot buy their own NFT"); // Prevent self-purchase

        delete listings[nftAddress][tokenId]; // Remove the listing

        // Transfer NFT to buyer and funds to seller
        IERC721(nftAddress).safeTransferFrom(listing.seller, msg.sender, tokenId);
        payable(listing.seller).transfer(msg.value);

        emit Bought(nftAddress, tokenId, msg.sender, msg.value);
    }
}
