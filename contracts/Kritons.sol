// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Base64.sol";
import  "./KrytonsADN.sol";

contract Kritons is ERC721,ERC721Enumerable,KritonsADN {
    using Counters for Counters.Counter;
    Counters.Counter private _idCounter;
    uint256 public maxSupply;

    //ID NFT TO ADN
    mapping(uint256 =>uint256) public tokenDNA;

    constructor(uint256 _maxSupply) ERC721("Kritons", "KN TS") {
        maxSupply = _maxSupply;
    }

    //Auto increment function
    function mint() public {
        //Address from owner (sender)
        uint256 current = _idCounter.current();
        require(current < maxSupply, "No Krytons left :");
        tokenDNA[current] = deterministicPseudoRandomDNA(current, msg.sender);
       _safeMint(msg.sender, current);
    }        

    //URL API
    function _baseURI() internal pure override returns (string memory) {
        return "https://avataaars.io/";
    }

    //PARAMS FOR GENERATE AVATAR
    function _paramsURI(uint256 _dna) internal view returns (string memory) {
        string memory params;

        {
            params = string(
                abi.encodePacked(
                    "accessoriesType=",
                    getAccessoriesType(_dna),
                    "&clotheColor=",
                    getClotheColor(_dna),
                    "&clotheType=",
                    getClotheType(_dna),
                    "&eyeType=",
                    getEyeType(_dna),
                    "&eyebrowType=",
                    getEyeBrowType(_dna),
                    "&facialHairColor=",
                    getFacialHairColor(_dna),
                    "&facialHairType=",
                    getFacialHairType(_dna),
                    "&hairColor=",
                    getHairColor(_dna),
                    "&hatColor=",
                    getHatColor(_dna),
                    "&graphicType=",
                    getGraphicType(_dna),
                    "&mouthType=",
                    getMouthType(_dna),
                    "&skinColor=",
                    getSkinColor(_dna)
                )
            );
        }

        return string(abi.encodePacked(params, "&topType=", getTopType(_dna)));
    }

    //Return image after get ADN
    function imageByDNA(uint256 _dna) public view returns (string memory) {
        string memory baseURI = _baseURI();
        string memory paramsURI = _paramsURI(_dna);

        return string(abi.encodePacked(baseURI, "?", paramsURI));
    }    

    //specific token id
    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721 Metadata: URI query for nonexistent token"
        );

        uint256 dna = tokenDNA[tokenId];
        string memory image = imageByDNA(dna);


        string memory jsonURI = Base64.encode(
            abi.encodePacked(
                '{ "name": "Krytons #',
                tokenId,
                '", "description": "Krytons are random Avatars By Abdiel Carrasco", "image": "',
                "// TODO: Calculate image URL",
                image,
                '"}'
            )
        );

        return string(abi.encodePacked("data:application/json;base64,", jsonURI));
    }

    // The following functions are overrides required by Solidity.
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}