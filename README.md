// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ArcTestnetNFT is ERC721URIStorage, Ownable {
    uint256 private _nextTokenId;

    // Defines the Name and Symbol of your NFT collection
    constructor() ERC721("Arc Pioneer NFT", "APN") Ownable(msg.sender) {}

    // Function to mint a new NFT
    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }
}# ARCTEST1
