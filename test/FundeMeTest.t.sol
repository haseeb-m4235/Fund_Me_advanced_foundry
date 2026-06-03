//SPDX-Licence-Identifier: MIT
pragma solidity ^0.8.34;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundeMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumTransfer() public view {
        assertEq(fundMe.MINIMUM_USD(), 5 * 10 ** 18);
        console.log("Minimum transfer in USD:", fundMe.MINIMUM_USD());
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.i_owner(), msg.sender);
        console.log("Owner address:", fundMe.i_owner());
    }

    function testVersion() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 0);
        console.log("Price feed version:", version);
    }
}
