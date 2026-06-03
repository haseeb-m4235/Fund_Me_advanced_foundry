//SPDX-Licence-Identifier: MIT
pragma solidity ^0.8.34;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundeMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 SEND_VALUE = 0.01 ether;
    uint256 STARTING_BALANCE = 100 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumTransfer() public view {
        assertEq(fundMe.MINIMUM_USD(), 5);
        console.log("Minimum transfer in USD:", fundMe.MINIMUM_USD());
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.i_owner(), msg.sender);
        console.log("Owner address:", fundMe.i_owner());
    }

    function testVersion() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
        console.log("Price feed version:", version);
    }

    function testFund() public {
        vm.expectRevert();
        fundMe.fund(); //
    }

    modifier fund() {
        vm.deal(USER, STARTING_BALANCE);
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testFundUpdatesFundedDataStructure() public fund {
        console.log("Sending value:", SEND_VALUE);
        console.log("Minimum USD:", fundMe.MINIMUM_USD());

        uint256 current_funds = fundMe.getAddressToAmountFunded(USER);
        assertEq(current_funds, SEND_VALUE);
        console.log("Funds sent:", current_funds);
    }

    function testAddsFundersToArrayOfFunders() public fund {
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
        console.log("Funder added to array:", funder);
    }

    function onlyOwnerCanWithdraw() public fund {
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }
}
