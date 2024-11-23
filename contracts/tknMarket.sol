// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

// contract address: 0xE9436E39D744eBc67261B34210140ac86381C430

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol"; // Import IERC721Receiver
import "./nftFactory.sol";

contract TKNMarket is ReentrancyGuard, Ownable, IERC721Receiver {
    struct NFTDetails {
        uint256 valor;
        bool isListed;
    }
    struct NFT {
        address nftAddress;
        uint256 tokenId;
    }

    NFTFactory public nftContract;

    mapping(address => mapping(uint256 => NFTDetails)) public nftMappingList;
    NFT[] public listedNFTs;

    event TokenAdded(address indexed nftAddress, uint256 indexed tokenId, uint256 price);
    event Bought(address indexed nftAddress, uint256 indexed tokenId, address buyer, uint256 price);

    constructor(
        string memory _nftName, 
        string memory _nftSymbol,
        string memory _contractURI
        ) Ownable(msg.sender) { 
        nftContract = new NFTFactory(_nftName, _nftSymbol, _contractURI);
    }   

    function mintNFT(string memory _tokenURI, uint256 _valor) external {
        // Minta NFT para o próprio contrato
        nftContract.mintNFT(address(this), _tokenURI);
        uint256 currentTokenId = nftContract.tokenId();
        // add nft na lista do marketplace
        NFT memory itemNft = NFT(address(nftContract), currentTokenId);
        listedNFTs.push(itemNft);
        nftMappingList[address(nftContract)][currentTokenId] = NFTDetails(_valor, true);
    }

    
    function buyNFT(address nftAddress, uint256 tokenId) external payable nonReentrant {
        NFTDetails storage nftAVenda = nftMappingList[nftAddress][tokenId];
        require(nftAVenda.isListed, "NFT not listed for sale");
        require(msg.value == nftAVenda.valor, "Incorrect price");

        // Transfer payment to contract owner
        payable(owner()).transfer(msg.value);

        // Transfer NFT to buyer
        IERC721(nftAddress).safeTransferFrom(address(this), msg.sender, tokenId);

        // Mark NFT as no longer listed
        nftAVenda.isListed = false;

        emit Bought(nftAddress, tokenId, msg.sender, nftAVenda.valor);
    }

    function withdrawFunds() external onlyOwner nonReentrant {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");

        payable(owner()).transfer(balance);
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external override pure returns (bytes4) {
        return this.onERC721Received.selector;
    }

    // Get all listed NFTs
    function getAllContractNFTs() external view 
    returns (address[] memory, uint256[] memory, uint256[] memory, string[] memory) {
        uint256 count = listedNFTs.length;

        // Initialize arrays
        address[] memory nftAddresses = new address[](count);
        string[] memory tokenURIs = new string[](count);
        uint256[] memory tokenIds = new uint256[](count);
        uint256[] memory prices = new uint256[](count);

        // Populate arrays with listed NFTs
        for (uint256 i = 0; i < count; i++) {
            NFT memory nftItem = listedNFTs[i];            
            nftAddresses[i] = nftItem.nftAddress;
            tokenURIs[i] = IERC721Metadata(nftItem.nftAddress).tokenURI(nftItem.tokenId);
            tokenIds[i] = nftItem.tokenId;
            prices[i] = nftMappingList[nftItem.nftAddress][nftItem.tokenId].valor;
        }

        return (nftAddresses, tokenIds, prices, tokenURIs);
    }

    function getNFTDetails(address nftAddress, uint256 tokenId) external view returns (uint256 valor, bool isListed) {
        NFTDetails memory nftDetail = nftMappingList[nftAddress][tokenId];
        return (nftDetail.valor, nftDetail.isListed);
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
