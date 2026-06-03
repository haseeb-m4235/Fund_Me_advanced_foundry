// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "@chainlink/contracts/src/v0.8/tests/MockV3Aggregator.sol";
import {console} from "forge-std/console.sol";

contract HelperConfig is Script {
    // if we are on local anvil mock it otherwise use the given chain

    uint8 public constant DECIMAL = 8;
    int256 public constant INITIAL_ANSWER = 2000 * 10 ** 8;

    struct NetworkConfig {
        address s_priceFeed;
    }
    //testing commit
    NetworkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = SepoliaEthConfig();
            console.log("Sepolia being used");
        } else {
            activeNetworkConfig = getOrCreateAnvilConfig();
            console.log("Anvil being used");
        }
    }

    function SepoliaEthConfig() public pure returns (NetworkConfig memory) {
        // price feed address of Sepolia Eth / USD
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            s_priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getOrCreateAnvilConfig() public returns (NetworkConfig memory) {
        // price feed address of Anvil Eth / USD
        //Deploy the mock contract
        // Return the mock address
        if (activeNetworkConfig.s_priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMAL,
            INITIAL_ANSWER
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            s_priceFeed: address(mockPriceFeed)
        });

        return anvilConfig;
    }
}
