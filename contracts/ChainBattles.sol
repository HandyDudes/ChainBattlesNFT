// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// The contract that will be used as a foundation of our ERC721 Smart contract
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

// A library which will take care of handling and storing our tokenIDs
import "@openzeppelin/contracts/utils/Counters.sol";

// library to implement the "toString()" function, that converts data into strings - sequences of characters
import "@openzeppelin/contracts/utils/Strings.sol";

// library to handle base64 data like on-chain SVGs
import "@openzeppelin/contracts/utils/Base64.sol";

/// @dev Add struct to hold token variables

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter; 
    Counters.Counter private _tokenIds;

    //Token Structure for characteristics
    struct tokenStats {
        uint256 t_level;
        uint256 t_speed;
        uint256 t_strength;
        uint256 t_health;
    }


    mapping(uint256 => tokenStats) public tokenIdToStats;

    constructor() ERC721 ("Chain Battles", "CBTLS"){
    }

// TODO create a function to change the character type, ie. warrior, mage, priest

function generateCharacter(uint256 tokenId) public returns(string memory){

    bytes memory svg = abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
        '<rect width="100%" height="100%" fill="black" />',
        '<text x="50%" y="30%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">', "Level: ",getLevels(tokenId),'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed: ",getSpeeds(tokenId),'</text>',
        '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength: ",getStrengths(tokenId),'</text>',
        '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Health: ",getHealths(tokenId),'</text>',
        '</svg>'
    );
    return string(
        abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(svg)
        )    
    );
}


// getter functions for stats
function getLevels(uint256 tokenId) public view returns (string memory) {
    uint256 levels = tokenIdToStats[tokenId].t_level;
    return levels.toString();
}

function getSpeeds(uint256 tokenId) public view returns (string memory) {
    uint256 speeds = tokenIdToStats[tokenId].t_speed;
    return speeds.toString();
}

function getStrengths(uint256 tokenId) public view returns (string memory) {
    uint256 strengths = tokenIdToStats[tokenId].t_strength;
    return strengths.toString();
}

function getHealths(uint256 tokenId) public view returns (string memory) {
    uint256 healths = tokenIdToStats[tokenId].t_health;
    return healths.toString();
}


function getTokenURI(uint256 tokenId) public returns (string memory){
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

function random(uint number) public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty))) % number;
    }

function mint() public {
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    _safeMint(msg.sender, newItemId);
    // initialize stats value
    tokenIdToStats[newItemId].t_level = 0;  //random(5)
    tokenIdToStats[newItemId].t_strength = random(5);  //
    tokenIdToStats[newItemId].t_speed = random(5);  //
    tokenIdToStats[newItemId].t_health = (random(4)+1);  //health always >1
    _setTokenURI(newItemId, getTokenURI(newItemId));
}

function train(uint256 tokenId) public {
    require(_exists(tokenId), "Please use an existing token");
    require(ownerOf(tokenId) == msg.sender, "You must own this token to train it");
    uint256 currentLevel = tokenIdToStats[tokenId].t_level;
    tokenIdToStats[tokenId].t_level = currentLevel + 1;
    _setTokenURI(tokenId, getTokenURI(tokenId));
}


}