// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.27;

// contract address: 0x81e3f429E3F85B5F7bd91CE50B839911cAe49013

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

    function mintNFT(address toAddress, string memory _tokenURI) public onlyOwner {
        require(tokenId < maxSupply, "MAX TOKEN LIMIT REACHED");
        tokenId = ++tokenId;
        _safeMint(toAddress, tokenId);
        _setTokenURI(tokenId, _tokenURI);
        emit TokenMintedTo(toAddress, tokenId);
    }

    function tokenURI(
        uint256 _tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(_tokenId);
    }

    // Expondo maxSupply
    function totalSupply() public view returns (uint256) {
        return maxSupply;
    }

    // Função requerida como sobreescrita por ERC721URIStorage
    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
