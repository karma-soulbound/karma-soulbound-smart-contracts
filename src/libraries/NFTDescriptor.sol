// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/utils/Base64.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";
import "./NFTSVG.sol";

library NFTDescriptor {
    using Strings for uint256;

    function generateTokenURI(
        string memory name,
        string memory description,
        string memory tokenScore,
        string memory tokenDescription
    ) public pure returns (string memory) {
        string memory image = Base64.encode(
            bytes(NFTSVG.generateSVG(tokenScore, tokenDescription))
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            string(
                                abi.encodePacked(
                                    '{"name":"',
                                    name,
                                    '", "description":"',
                                    description,
                                    '", "image": "',
                                    "data:image/svg+xml;base64,",
                                    image,
                                    '","attributes": [',
                                    '{"trait_type": "Score", "value": "',
                                    tokenScore,
                                    '"},{"trait_type": "Description", "value": "',
                                    tokenDescription,
                                    '"}]}'
                                )
                            )
                        )
                    )
                )
            );
    }

    function generateContractURI(string memory name, string memory description)
        public
        pure
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            string(
                                abi.encodePacked(
                                    '{"name": "',
                                    name,
                                    '","description": "',
                                    description,
                                    '"}'
                                )
                            )
                        )
                    )
                )
            );
    }
}
