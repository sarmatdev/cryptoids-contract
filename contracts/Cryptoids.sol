// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Cryptoids is ERC721Enumerable {
  using Counters for Counters.Counter;
  using SafeMath for uint256;
  Counters.Counter private _tokenIds;

  uint256 public constant MAX_CRYPTOIDS_SUPPLY = 10000;
  uint256 public constant MINT_PRICE = 0.05 ether;
  uint256 public constant MAX_ITEMS_PER_MINT = 20;

  constructor() ERC721("Cryptoid", "CRD") {}

  /**
   * @dev Function for minting Cryptoids
   * @param _amount Token ID
   */
  function mint(uint256 _amount) public payable {
    require(getMintPrice(_amount) == msg.value, "Amount of Ether is incorrect");
    for (uint256 i = 0; i < _amount; i++) {
      uint256 mintIndex = totalSupply();
      _safeMint(msg.sender, mintIndex);
    }
  }

  /**
   * @dev Calculate mint price based on mint amount
   * @param amount Amount to mint
   */
  function getMintPrice(uint256 amount) public view returns (uint256) {
    require(totalSupply() < MAX_CRYPTOIDS_SUPPLY, "Sale has already ended, no more Cryptoids left to sell.");

    return amount.mul(MINT_PRICE);
  }
}
