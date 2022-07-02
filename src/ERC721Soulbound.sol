// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

error CanNotTransfer();

contract ERC721Soulbound is ERC721 {
    constructor(string memory name, string memory symbol)
        ERC721(name, symbol)
    {}

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId);
        // Ignore transfers during minting
        if (from == address(0)) {
            return;
        }
        revert CanNotTransfer();
    }
}
