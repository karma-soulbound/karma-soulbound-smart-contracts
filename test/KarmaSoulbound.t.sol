// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/KarmaSoulbound.sol";

contract ContractTest is Test {
    KarmaSoulbound instance;
    address prayuth;
    function setUp() public {
        instance = new KarmaSoulbound();
        prayuth = address(69);
        vm.label(prayuth, "Prayuth");
    }
    function testMint() public {
        assertEq(instance.balanceOf(prayuth), 0);
        instance.mintKarma(prayuth, -100, "Commit Durian Fraud");
        (int256 score, string memory description) = instance.karmaData(1);
        assertEq(score, -100);
        assertEq(description, "Commit Durian Fraud");
        assertEq(instance.balanceOf(prayuth), 1);
    }
    function testTransfer() public {
        instance.mintKarma(prayuth, -100, "Commit Durian Fraud");
        vm.prank(prayuth);
        vm.expectRevert(abi.encodePacked(bytes4(keccak256("CanNotTransfer()"))));
        instance.safeTransferFrom(prayuth, address(70), 1);
    }
}
