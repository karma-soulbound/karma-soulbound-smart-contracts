pragma solidity ^0.8.13;

import "./libraries/IntToUint.sol";

contract AAA {
    constructor () {
    }
    function sendString(int value) external pure returns (string memory result) {
        return IntToUint.toString(value);
    }
    function sendstringsss(int value) external pure returns (string memory result) {
        return IntToUint.tostringwithout(value);
    }
}