// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.27;

// contract address: 0xfd69CD8F5921f0C699B3Ac0C54ed5534835b091E

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTFactory is ERC721, ERC721URIStorage, Ownable {
    uint256 public tokenId;
    uint256 public maxSupply;
    string public contractURI;

    event TokenMintedTo(address to, uint tokenId);

    constructor(
        string memory name,
        string memory symbol,
        string memory _contractURI
    ) ERC721(name, symbol) Ownable(msg.sender) {
        maxSupply = 100;
        contractURI = _contractURI;
    }

    function mintToMarketplace(address marketplaceAddress, string memory _tokenURI) public onlyOwner {
        require(tokenId < maxSupply, "MAX TOKEN LIMIT REACHED");
        uint256 _tokenId = tokenId++;
        _safeMint(marketplaceAddress, _tokenId);
        _setTokenURI(tokenId, _tokenURI);
        emit TokenMintedTo(marketplaceAddress, tokenId);
    }

    function tokenURI(
        uint256 _tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(_tokenId);
    }

    // Função requerida como sobreescrita
    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
