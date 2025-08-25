# Uniswap V2 Protocol Fuzzing Assignment

## Overview
This project implements property-based fuzz testing for Uniswap V2 core protocol components to validate critical invariants and identify potential vulnerabilities in the automated market maker (AMM) implementation.

## Objectives
- Verify the constant product formula (x * y = k) invariant holds across all operations
- Test liquidity pool operations under extreme and edge-case conditions
- Validate token reserve balance changes during swaps
- Ensure mathematical correctness of mint/burn operations
- Identify potential overflow, underflow, and rounding errors

## Fuzzing Architecture

### Core Components
- **FuzzSetup.sol**: Initial contract deployment and configuration
- **FuzzHandlers.sol**: Operation handlers for swap, add/remove liquidity
- **FuzzClamped.sol**: Input validation and boundary constraints
- **FuzzBeforeAfter.sol**: State capture mechanism for before/after comparisons
- **FuzzProps.sol**: Property assertions and invariant checking
- **FuzzUnit.sol**: Individual unit test implementations

### Key Properties Tested

#### 1. Constant Product Invariant (`prop_uniswapV2Pair_swap`)
```solidity
// K should never decrease during swaps (accounting for fees)
assert(beforeK <= afterK);
```

#### 2. Token Reserve Conservation (`prop_uniswapV2Pair_swap_token_reserves`)
```solidity
// One reserve increases while the other decreases
assert((b0 < a0 && b1 > a1) || (b0 > a0 && b1 < a1));
```

#### 3. Liquidity Addition (`prop_uniswapV2Pair_mint_increases_K`)
```solidity
// Adding liquidity should always increase K
assert(beforeK < afterK);
```

#### 4. Liquidity Removal (`prop_uniswapV2Pair_burn_decreases_K`)
```solidity
// Removing liquidity should always decrease K
assert(beforeK > afterK);
```

## Tools & Framework
- **Fuzzing Engines**: Echidna, Medusa
- **Smart Contract Framework**: Foundry
- **Target Protocol**: Uniswap V2 Core (Solidity 0.5.16)
- **Testing Environment**: Local blockchain simulation
- **Additional Tools**: TypeScript test suite for reference testing

## Project Structure
```
├── contracts/                 # Uniswap V2 core contracts
├── test/
│   ├── fuzz/                 # Fuzzing test suite
│   │   ├── FuzzSetup.sol     # Test environment setup
│   │   ├── FuzzHandlers.sol  # Operation handlers
│   │   ├── FuzzClamped.sol   # Input constraints
│   │   ├── FuzzBeforeAfter.sol # State management
│   │   ├── FuzzProps.sol     # Property assertions
│   │   ├── FuzzUnit.sol      # Unit tests
│   │   └── Hevm.sol          # Testing utilities
│   ├── *.spec.ts             # TypeScript reference tests
│   ├── mocks/                # Mock contracts
│   └── shared/               # Test utilities
├── echidna.yaml              # Echidna configuration
├── medusa.json               # Medusa configuration
├── foundry.toml              # Foundry configuration
└── findings/                 # Test results and reports
```

## Setup & Installation

### Prerequisites
- Node.js and Yarn
- Foundry
- Echidna
- Medusa

### Installation
```bash
# Clone the repository
git clone <repository-url>
cd uniswap-v2-fuzz

# Install dependencies
yarn install

# Install Foundry dependencies
forge install

# Build contracts
forge build
```

## Running Fuzzing Tests

### Echidna
```bash
# Run Echidna fuzzing campaign
echidna test/fuzz/FuzzProps.sol --contract FuzzProps --config echidna.yaml

# Run with custom parameters
echidna test/fuzz/FuzzProps.sol --contract FuzzProps --test-limit 10000
```

### Medusa
```bash
# Run Medusa fuzzing campaign
medusa fuzz --config medusa.json

# Run with verbose output
medusa fuzz --config medusa.json --verbosity 3
```

### Foundry Tests
```bash
# Run standard test suite
forge test

# Run with gas reporting
forge test --gas-report

# Run specific fuzz test
forge test --match-contract FuzzUnit
```

## Configuration

### Echidna Configuration (`echidna.yaml`)
Key parameters for fuzzing campaigns:
- Test limit and timeout settings
- Contract deployment parameters  
- Assertion checking modes
- Coverage tracking options

### Medusa Configuration (`medusa.json`)
- Fuzzing targets and entry points
- Test execution parameters
- Result output formatting

## Test Categories

### 1. Core AMM Properties
- **Constant Product Formula**: Ensures K invariant maintenance
- **Price Impact**: Validates price changes follow expected curves
- **Fee Accumulation**: Verifies protocol fees are correctly collected

### 2. Liquidity Operations  
- **Mint Operations**: Adding liquidity increases total K
- **Burn Operations**: Removing liquidity decreases total K
- **Initial Liquidity**: First liquidity provision edge cases

### 3. Swap Mechanics
- **Token Exchange**: Bidirectional swap correctness
- **Reserve Updates**: Proper balance adjustments
- **Slippage Protection**: Minimum output validation

### 4. Edge Cases & Attack Vectors
- **Rounding Errors**: Precision loss in calculations
- **Integer Overflows**: Large number handling
- **Zero Amount Operations**: Boundary condition handling
- **Reentrancy Patterns**: State consistency during external calls

## Operation Types
The fuzzing framework tests three primary operation types:
- `SWAP`: Token exchange operations
- `ADD`: Liquidity addition (mint)
- `REMOVE`: Liquidity removal (burn)

## Expected Results
- **Property Violations**: Any assertion failures indicate potential bugs
- **Gas Usage Analysis**: Identify gas-intensive operations
- **Coverage Metrics**: Ensure comprehensive code path testing
- **Edge Case Discovery**: Unusual input combinations that break assumptions

## Findings & Analysis
Results are stored in the `findings/` directory and should include:
- Counterexamples for failed properties
- Gas consumption reports
- Code coverage statistics
- Recommended fixes for discovered issues

## Known Limitations
- Testing limited to Uniswap V2 core functionality
- Fuzzing constrained by input parameter ranges
- Some external dependencies mocked for testing isolation
- Focus on mathematical properties rather than economic attacks

## Contributing
When extending the fuzzing suite:
1. Add new properties to `FuzzProps.sol`
2. Implement corresponding handlers in `FuzzHandlers.sol`
3. Update configuration files for new test scenarios
4. Document expected behaviors and edge cases

## References
- [Uniswap V2 Core Whitepaper](https://uniswap.org/whitepaper.pdf)
- [Echidna Documentation](https://github.com/crytic/echidna)
- [Medusa Documentation](https://github.com/crytic/medusa)
- [Foundry Documentation](https://book.getfoundry.sh/)

---
**Note**: This is an educational fuzzing implementation for learning property-based testing techniques. Results should be verified through additional security analysis methods.
