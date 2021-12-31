// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Cryptoids is ERC721Enumerable, Ownable {
  using Counters for Counters.Counter;
  using SafeMath for uint256;
  Counters.Counter private _tokenIds;

  uint256 public constant MAX_SUPPLY = 10000;
  uint256 public constant MINT_PRICE = 0.05 ether;
  uint256 public constant MAX_PER_MINT = 10;

  string public baseTokenURI;

  constructor(string memory _baseURI) ERC721("Cryptoid", "CRD") {
    setBaseURI(_baseURI);
  }

  /**
   * @dev Function for minting Cryptoids
   * @param _amount Token ID
   */
  function mint(uint256 _amount) public payable {
    uint256 totalMinted = _tokenIds.current();

    require(totalMinted.add(_amount) <= MAX_SUPPLY, "No NFT's left for mint.");
    require(_amount > 0 && _amount <= MAX_PER_MINT, "Cannot mint specified number of NFTs.");
    require(msg.value >= MINT_PRICE.mul(_amount), "Amount of Ether is incorrect");

    for (uint256 i = 0; i < _amount; i++) {
      _mintSingleNFT();
    }
  }

  function _mintSingleNFT() private {
    uint256 newTokenID = _tokenIds.current();
    _safeMint(msg.sender, newTokenID);
    _tokenIds.increment();
  }

  function tokensOfOwner(address _owner) external view returns (uint256[] memory) {
    uint256 tokenCount = balanceOf(_owner);
    uint256[] memory tokensId = new uint256[](tokenCount);
    for (uint256 i = 0; i < tokenCount; i++) {
      tokensId[i] = tokenOfOwnerByIndex(_owner, i);
    }

    return tokensId;
  }

  function setBaseURI(string memory _baseTokenURI) public onlyOwner {
    baseTokenURI = _baseTokenURI;
  }

  function withdraw() public payable onlyOwner {
    uint256 balance = address(this).balance;
    require(balance > 0, "No ether left to withdraw");

    bool sent = payable(msg.sender).send(balance);

    require(sent, "Transfer failed.");
  }
}
