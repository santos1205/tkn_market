// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, Ownable {
    uint256 public nextTokenId;
    uint256 public maxSupply;

    constructor(
        string memory name,
        string memory symbol,
        uint256 _maxSupply
    ) ERC721(name, symbol) {
        maxSupply = _maxSupply;
    }

    function mintNFT(address recipient) external onlyOwner {
        require(nextTokenId < maxSupply, "Max supply reached");
        uint256 tokenId = nextTokenId;
        _safeMint(recipient, tokenId);
        nextTokenId++;
    }
}
