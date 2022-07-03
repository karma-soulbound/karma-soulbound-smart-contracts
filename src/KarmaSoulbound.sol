// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "./libraries/NFTDescriptor.sol";
import "./libraries/IntToUint.sol";

error CanNotTransfer();
error NotTokenOwner();

contract KarmaSoulbound is ERC721Enumerable, Ownable {
    uint256 lastId = 0;
    uint256 lastForgiveId = 0;
    mapping(uint256 => Karma) public karmaData;
    mapping(address => int256) public karmaBalance;
    struct Karma {
        int256 score;
        string description;
    }
    mapping(uint256 => uint256) public forgiveRequestId;

    constructor() ERC721("Karma Soulbound", "Karma") {}

    function mintKarma(
        address _to,
        int256  _score,
        string calldata _description
    ) public onlyOwner {
        karmaData[lastId + 1] = Karma({
            score: _score,
            description: _description
        });
        karmaBalance[_to] += _score;
        _safeMint(_to, lastId + 1);
        lastId += 1;
    }

    function burnKarma(uint256 tokenId) public onlyOwner {
        address bearer = ownerOf(tokenId);
        int256 karma = karmaBalance[bearer].score;
        _burn(tokenId);
        emit KarmaForgiven(bearer, tokenId, karma);
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
                IntToUint.toString(token.score),
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

    function forgiveRequest(uint256 _tokenId) public {
        _exists(_tokenId);
        if(ownerOf(_tokenId) != _msgSender()) {
            revert NotTokenOwner();
        }
        else {
            forgiveRequestId[lastForgiveId + 1] = _tokenId;
            emit RequestForForgiveness(_msgSender(), _tokenId, lastForgiveId + 1);
            lastForgiveId += 1;
        }
    }
    function grantForgiveness(uint256 _forgiveRequestId) public onlyOwner {
        uint256 tokenId = forgiveRequestId[_forgiveRequestId];
        int256 karma = karmaBalance[tokenId];
        address bearer = ownerOf(tokenId);
        karmaBalance[bearer] -= karma;
        require(tokenId != 0);
        _burn(tokenId);
        emit KarmaForgiven(bearer, tokenId, karma);
    }

    event RequestForForgiveness(address indexed bearer, uint256 tokenId, uint256 forgiveId);
    event KarmaForgiven(address indexed bearer, uint256 tokenId, int256 karma);
}
