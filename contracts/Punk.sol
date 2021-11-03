// SPDX-License-Identifier: MIT

// CeloApes | Apes are now on Celo

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CeloApes is Ownable, Pausable, ERC721Enumerable {
    using Strings for uint256;

    string public baseURI;
    string public baseExtension = ".json";
    uint256 public maxSupply = 10000;
    uint256 public maxMintAmount = 100;
    uint256 public cost = 3 ether;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _initBaseURI
    ) ERC721(_name, _symbol) {
        setBaseURI(_initBaseURI);
        mint(msg.sender, 100);
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function mint(address _to, uint256 _mintAmount) public payable whenNotPaused {
        uint256 supply = totalSupply();
        require(_mintAmount > 0, "CeloApes: mintAmount should be greater than 0");
        require(_mintAmount <= maxMintAmount, "CeloApes: mintAmount should be less than max mint");
        require(supply + _mintAmount <= maxSupply, "CeloApes: Supply not available");
        if (msg.sender != owner()) {
            require(msg.value >= cost * _mintAmount, "CeloApes: Insuffcient Celo");
        }
        for (uint256 i = 1; i <= _mintAmount; i++) {
            _safeMint(_to, supply + i);
        }
    }

    function walletOfOwner(address _owner) public view returns (uint256[] memory) {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "CeloApes: URI query for nonexistent token");
        string memory curretBaseURI = _baseURI();
        return
            bytes(curretBaseURI).length > 0
                ? string(abi.encodePacked(curretBaseURI, tokenId.toString(), baseExtension))
                : "";
    }

    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }

    function setMaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
        maxMintAmount = _newmaxMintAmount;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
        baseExtension = _newBaseExtension;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function withdraw() public payable onlyOwner {
        require(payable(msg.sender).send(address(this).balance), "Transfer Failed");
    }

    function withdrawERC20(IERC20 token) public onlyOwner {
        require(token.transfer(msg.sender, token.balanceOf(address(this))), "Transfer failed");
    }
}
