// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattlesUpgraded is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;

    struct Attributes {
        uint256 level;
        uint256 strength;
        uint256 speed;
        uint256 life;
    }

    Counters.Counter private _tokenIds;

    // Maps an NFT token id to it's corresponding level
    mapping(uint256 => Attributes) public tokenIdToAttributes;

    constructor() ERC721("Chain Battles Upgraded", "CBTLSu") {}

    function generateCharacter(uint256 tokenId) public returns(string memory){
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Level: ",getLevels(tokenId),'</text>',
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Life: ",getLife(tokenId),'</text>',
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed: ",getSpeed(tokenId),'</text>',
            '<text x="50%" y="80%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength: ",getStrength(tokenId),'</text>',
            '</svg>'
        );
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            )    
        );
    }

    function getLevels(uint256 tokenId) public view returns (string memory) {
        uint256 levels = tokenIdToAttributes[tokenId].level;
        return levels.toString();
    }

    function getLife(uint tokenId) public view returns (string memory) {
        return tokenIdToAttributes[tokenId].life.toString();
    }

    function getSpeed(uint tokenId) public view returns (string memory) {
        return tokenIdToAttributes[tokenId].speed.toString();
    }

    function getStrength(uint tokenId) public view returns (string memory) {
        return tokenIdToAttributes[tokenId].strength.toString();
    }

    function getTokenURI(uint256 tokenId) public returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "Chain Battles #', tokenId.toString(), '",',
                '"description": "Battles on chain",',
                '"image": "', generateCharacter(tokenId), '"',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        Attributes memory attr;
        attr.level = 0;
        attr.speed = random(100);
        attr.strength = random(200);
        attr.life = random(250);
        tokenIdToAttributes[newItemId] = attr;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function random(uint number) public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
        msg.sender))) % number;
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId), "Please use an existing token");
        require(ownerOf(tokenId) == msg.sender, "You must own this token to train it");
        uint256 currentLevel = tokenIdToAttributes[tokenId].level;
        tokenIdToAttributes[tokenId].level = currentLevel + 1;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

}