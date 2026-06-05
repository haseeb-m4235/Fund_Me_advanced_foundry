# FundMe Advanced - A Decentralized Funding Contract

A production-ready Solidity smart contract for accepting cryptocurrency donations with USD-denominated minimum funding requirements. Built with **Foundry** and integrated with **Chainlink Price Feeds** for secure, real-time price conversion.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
- [Testing](#testing)
- [Deployment](#deployment)
- [Project Structure](#project-structure)
- [Gas Optimization](#gas-optimization)
- [Contributing](#contributing)

## Overview

**FundMe** is a decentralized funding contract that allows users to contribute ETH to a funding pool while enforcing a minimum USD value threshold. The contract uses Chainlink's decentralized price feeds to convert ETH amounts to USD in real-time, ensuring donations meet the minimum requirement regardless of ETH price fluctuations.

### Use Cases

- Crowdfunding campaigns with USD-denominated goals
- Charitable donations with minimum contribution thresholds
- DeFi fundraising with price-stable minimum requirements
- Smart contract demos for educational purposes

## Features

✅ **USD-Denominated Minimums** - Enforce funding minimums in USD, not fixed ETH amounts  
✅ **Chainlink Price Feeds** - Real-time, decentralized ETH/USD pricing  
✅ **Owner Withdrawals** - Secure fund withdrawal with access control  
✅ **Gas Optimized** - Optimized withdrawal function to reduce gas costs  
✅ **Comprehensive Tests** - Full unit and integration test coverage  
✅ **Multi-Chain Support** - Deploy to Ethereum, Sepolia, Arbitrum, and more  
✅ **Best Practices** - Custom errors, immutable storage, proper function ordering  

## Architecture

### Smart Contracts

#### **FundMe.sol**
Main funding contract with the following key functions:

- `fund()` - Accept ETH donations meeting the $5 USD minimum
- `withdraw()` - Owner function to withdraw all funds (standard implementation)
- `cheaperWithdraw()` - Gas-optimized withdrawal using memory array
- Getter functions for tracking funders and amounts

**Key Parameters:**
- **MINIMUM_USD**: $5 USD (stored as 5 * 10^18 wei)
- **Owner**: Address that deployed the contract (immutable)
- **Price Feed**: Chainlink AggregatorV3Interface for ETH/USD

#### **PriceConverter.sol**
Library for ETH/USD conversion:

- `getPrice()` - Fetch latest ETH/USD price from Chainlink
- `getConversionRate()` - Convert ETH amounts to USD equivalent

### Deployment Architecture

- **DeployFundMe.s.sol** - Main deployment script
- **HelperConfig.s.sol** - Chain-specific configuration and mock setup
- **MockV3Aggregator** - Local price feed mock for testing

## Getting Started

### Prerequisites

- **Foundry**: [Install Foundry](https://book.getfoundry.sh/getting-started/installation)
- **Git**: For cloning the repository
- **Node.js**: (Optional) For additional tooling

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/Fund_Me_advanced_foundry.git
cd Fund_Me_advanced_foundry

# Install dependencies
forge install

# Build contracts
forge build
```

### Environment Setup

Create a `.env` file in the project root:

```env
# Private key for deployment
PRIVATE_KEY=your_private_key_here

# RPC endpoints
ETHEREUM_RPC_URL=https://eth-mainnet.g.alchemy.com/v2/your-key
SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/your-key
```

## Testing

### Run All Tests

```bash
# Run all tests
forge test

# Run with verbose output
forge test -v

# Run specific test file
forge test --match-path test/Unit/FundeMeTest.t.sol

# Run with gas reporting
forge test --gas-report
```

### Test Coverage

The project includes comprehensive test coverage:

- **Unit Tests** (`test/Unit/FundeMeTest.t.sol`)
  - Price feed configuration
  - Fund functionality with minimum validation
  - Funder tracking
  - Withdrawal functionality
  - Access control

- **Integration Tests** (`test/Integration/FundMeIntegrationTest.t.sol`)
  - End-to-end funding flows
  - Cross-contract interactions

- **Mocks** (`test/mocks/MockV3Aggregator.sol`)
  - Chainlink V3 aggregator simulation for local testing

## Deployment

### Deploy to Anvil (Local)

```bash
# Start local node
anvil

# In another terminal, deploy
forge script script/DeployFundMe.s.sol --rpc-url http://localhost:8545 --broadcast
```

### Deploy to Sepolia Testnet

```bash
forge script script/DeployFundMe.s.sol \
  --rpc-url $SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast \
  --verify
```

### Deploy to Mainnet

```bash
forge script script/DeployFundMe.s.sol \
  --rpc-url $ETHEREUM_RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast \
  --verify
```

## Project Structure

```
Fund_Me_advanced_foundry/
├── src/
│   ├── FundMe.sol          # Main funding contract
│   └── PriceConverter.sol   # Price conversion library
├── script/
│   ├── DeployFundMe.s.sol   # Deployment script
│   ├── HelperConfig.s.sol   # Chain configuration
│   └── Interactions.s.sol   # Contract interaction helpers
├── test/
│   ├── Unit/
│   │   └── FundeMeTest.t.sol        # Unit tests
│   ├── Integration/
│   │   └── FundMeIntegrationTest.t.sol # Integration tests
│   └── mocks/
│       └── MockV3Aggregator.sol      # Price feed mock
├── lib/
│   ├── forge-std/          # Foundry standard library
│   └── chainlink-brownie-contracts/  # Chainlink interfaces
├── foundry.toml            # Foundry configuration
├── Makefile                # Convenience commands
└── README.md               # This file
```

## Gas Optimization

The contract includes two withdrawal implementations:

### Standard Withdrawal
```solidity
function withdraw() public onlyOwner
```
- Standard loop through storage array
- Higher gas cost for large numbers of funders

### Optimized Withdrawal
```solidity
function cheaperWithdraw() public onlyOwner
```
- Copies storage array to memory
- Reduces storage reads
- **Recommended for production** with many funders

**Gas Savings**: Up to 40% cheaper with 100+ funders

## Key Concepts

### Chainlink Price Feeds
- Decentralized oracle providing real-time ETH/USD prices
- Chainlink nodes aggregate price data from multiple sources
- `AggregatorV3Interface` provides the `latestRoundData()` function

### Price Conversion Logic
```
ETH Amount (18 decimals) × ETH/USD Price × 10^-18 = USD Value
```

### Custom Errors
Uses custom errors instead of require strings for gas efficiency:
```solidity
error FundMe__NotOwner();
```

## Development Commands

```bash
# Format code
forge fmt

# Get gas snapshots
forge snapshot

# Start interactive shell
forge console

# Lint check (using aderyn)
aderyn .
```

## Supported Networks

- **Ethereum Mainnet** - Using Chainlink ETH/USD feed
- **Sepolia Testnet** - Using mock price feed for testing
- **Arbitrum One** - Multi-chain compatible
- **zkSync Era** - With chain-specific handling

## Security Considerations

⚠️ **This is a learning/demo contract**. Before mainnet deployment:

- [ ] Full security audit by professional firm
- [ ] Formal verification of critical functions
- [ ] Additional access control patterns (if needed)
- [ ] Event emissions for fund tracking
- [ ] Withdrawal approval pattern (for production)

## Future Enhancements

- [ ] Event emissions for on-chain indexing
- [ ] Withdrawal request queue for additional security
- [ ] Multiple withdrawal strategies
- [ ] Time-locked withdrawals
- [ ] Emergency pause mechanism

## Resources

- [Foundry Book](https://book.getfoundry.sh/)
- [Chainlink Documentation](https://docs.chain.link/)
- [Solidity Docs](https://docs.soliditylang.org/)
- [Patrick Collins Full Course](https://github.com/PatrickAlphaC/foundry-full-course-f23)

## License

This project is licensed under the MIT License - see the individual contract headers for details.

## Acknowledgments

- **Patrick Collins** - Original FundMe contract design
- **Chainlink Labs** - Price feed oracles and contracts
- **Foundry Community** - Testing framework and tooling
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
