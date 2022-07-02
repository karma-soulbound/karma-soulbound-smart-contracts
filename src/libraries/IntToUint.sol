pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/utils/Strings.sol";

library IntToUint {
    function toString(int value) internal pure returns (string memory) {
        if (value > 0) return Strings.toString(uint(value));
        else return string.concat("-", Strings.toString(uint(0-value)));
    }
    function tostringwithout(int value) internal pure returns (string memory) {
        return Strings.toString(uint(value));
    }
}