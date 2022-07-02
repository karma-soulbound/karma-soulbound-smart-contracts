pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/AAA.sol";

contract AAATest is Test {
    AAA test;
    string res;
    int value;
    function setUp() public {
        res = "-69";
        value = -69;
        test = new AAA();
    }
    function testExample() public {
        string memory something = test.sendString(value);
        console2.log(something);
        assertEq(res, something);
    }
    function test2() public {
        string memory something = test.sendstringsss(value);
        console2.log(something);
        assertEq(res, something);
    }
}