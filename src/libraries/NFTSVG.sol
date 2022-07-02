// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/utils/Strings.sol";

library NFTSVG {
    using Strings for uint256;

    function generateSVG(string memory score, string memory description)
        internal
        pure
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    '<svg width="690" height="420" fill="none" xmlns="http://www.w3.org/2000/svg"> ',
                    " <style> ",
                    "text { font: italic 40px serif; fill: red; } ",
                    "</style> ",
                    '<text x="10" y="40">',
                    score,
                    "</text>",
                    '<text x="10" y="80">',
                    description,
                    "</text>",
                    "</svg>"
                )
            );
    }
}
