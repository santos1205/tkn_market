// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

// contract address: 0x857BE7553d197509Ae6a6934D773663fADBCcACF

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TKNMarket is ReentrancyGuard, Ownable {
    struct Listing {
        uint256 price;
        bool isListed;
    }

    mapping(address => mapping(uint256 => Listing)) public listings;

    event TokenAdded(address indexed nftAddress, uint256 indexed tokenId, uint256 price);
    event Bought(address indexed nftAddress, uint256 indexed tokenId, address buyer, uint256 price);

    constructor() Ownable(msg.sender) { }

    /**
     * @dev List an NFT owned by the contract for sale.
     * @param nftAddress Address of the NFT contract.
     * @param tokenId ID of the NFT to list.
     * @param price Sale price of the NFT.
     */
    function addToMarketList(address nftAddress, uint256 tokenId, uint256 price) external onlyOwner nonReentrant {
        require(price > 0, "Price must be greater than zero");

        IERC721 nft = IERC721(nftAddress);
        require(nft.ownerOf(tokenId) == address(this), "Marketplace does not own this NFT");

        listings[nftAddress][tokenId] = Listing(price, true);
        emit TokenAdded(nftAddress, tokenId, price);
    }

    /**
     * @dev Buy an NFT from the marketplace.
     * @param nftAddress Address of the NFT contract.
     * @param tokenId ID of the NFT to buy.
     */
    function buyNFT(address nftAddress, uint256 tokenId) external payable nonReentrant {
        Listing storage listing = listings[nftAddress][tokenId];
        require(listing.isListed, "NFT not listed for sale");
        require(msg.value == listing.price, "Incorrect price");

        // Transfer payment to contract owner
        payable(owner()).transfer(msg.value);

        // Transfer NFT to buyer
        IERC721(nftAddress).safeTransferFrom(address(this), msg.sender, tokenId);

        // Mark NFT as no longer listed
        listing.isListed = false;

        emit Bought(nftAddress, tokenId, msg.sender, listing.price);
    }

    function withdrawFunds() external onlyOwner nonReentrant {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");

        payable(owner()).transfer(balance);
    }

    /**
     * @dev Withdraw any unlisted NFTs back to the owner.
     * @param nftAddress Address of the NFT contract.
     * @param tokenId ID of the NFT to withdraw.
     */
    // ### FOR FUTURE IMPLEMENTATIONS
    // function withdrawNFT(address nftAddress, uint256 tokenId) external onlyOwner nonReentrant {
    //     IERC721 nft = IERC721(nftAddress);
    //     require(nft.ownerOf(tokenId) == address(this), "Marketplace does not own this NFT");
    //     require(!listings[nftAddress][tokenId].isListed, "Cannot withdraw a listed NFT");

    //     nft.safeTransferFrom(address(this), msg.sender, tokenId);
    // }
}
