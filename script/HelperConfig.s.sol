// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "@chainlink/contracts/src/v0.8/tests/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // if we are on local anvil mock it otherwise use the given chain

    struct NetworkConfig {
        address priceFeed;
    }

    NetworkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = SepoliaEthConfig();
        } else {
            activeNetworkConfig = getAnvilConfig();
        }
    }

    function SepoliaEthConfig() public pure returns (NetworkConfig memory) {
        // price feed address of Sepolia Eth / USD
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getAnvilConfig() public returns (NetworkConfig memory) {
        // price feed address of Anvil Eth / USD
        //Deploy the mock contract
        // Return the mock address
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            8,
            2000 * 10 ** 8
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}
