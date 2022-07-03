// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/KarmaSoulbound.sol";

contract KarmaSoulboundTest is Test {
    address constant alice = 0x1231231231231231231231231231231231231231;

    KarmaSoulbound karmaSoulbound;

    function setUp() public {
        karmaSoulbound = new KarmaSoulbound();
    }

    function testMintKarmaAsOwner() public {
        assertEq(karmaSoulbound.balanceOf(alice), 0);
        karmaSoulbound.mintKarma(alice, -1, "Steal");
        assertEq(karmaSoulbound.balanceOf(alice), 1);
    }

    function testFailMintKarmaAsNotOwner() public {
        vm.expectRevert();
        vm.prank(address(alice));
        karmaSoulbound.mintKarma(alice, -1, "Steal");
    }

    function testBurnKarmaAsOwner() public {
        assertEq(karmaSoulbound.balanceOf(alice), 0);
        karmaSoulbound.mintKarma(alice, -1, "Steal");
        assertEq(karmaSoulbound.balanceOf(alice), 1);
        karmaSoulbound.burnKarma(1);
        assertEq(karmaSoulbound.balanceOf(alice), 0);
    }

    function testFailBurnKarmaAsNotOwner() public {
        karmaSoulbound.mintKarma(alice, -1, "Steal");
        assertEq(karmaSoulbound.balanceOf(alice), 1);
        vm.expectRevert();
        vm.prank(address(alice));
        karmaSoulbound.burnKarma(1);
    }
}
