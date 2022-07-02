// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "./libraries/NFTDescriptor.sol";

error CanNotTransfer();

contract KarmaSoulbound is ERC721Enumerable, Ownable {
    uint256 lastId;

    mapping(uint256 => Karma) public karmaData;

    struct Karma {
        string score;
        string description;
    }

    constructor() ERC721("Karma Soulbound", "Karma") {}

    function mintKarma(
        address _to,
        string memory _score,
        string memory _description
    ) public onlyOwner {
        karmaData[lastId + 1] = Karma({
            score: _score,
            description: _description
        });
        _safeMint(_to, lastId + 1);
        lastId += 1;
    }

    function burnKarma(uint256 tokenId) public onlyOwner {
        _burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(_exists(tokenId));
        Karma memory token = karmaData[tokenId];
        return
            NFTDescriptor.generateTokenURI(
                "Test",
                "Test Description",
                token.score,
                token.description
            );
    }

    function contractURI() external pure returns (string memory) {
        return NFTDescriptor.generateContractURI("Test", "Test Description");
    }

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
        if (to == address(0) && msg.sender == owner()) {
            return;
        }
        revert CanNotTransfer();
    }
}
