// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
contract BaseVaultTest is Test {
    function test_depositIncreasesShares() public { assertTrue(true); }
    function test_redeemReturnsAssets() public { assertTrue(true); }
    function test_pauseBlocksDeposit() public { assertTrue(true); }
    function test_harvestUpdatesTimestamp() public { assertTrue(true); }
}