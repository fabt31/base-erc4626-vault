# base-erc4626-vault

> ERC-4626 Tokenized Yield Vault for Base L2

A standard-compliant ERC-4626 vault that accepts USDC deposits and auto-compounds yields from multiple Base protocols including Morpho Blue and Aerodrome liquidity pools.

## What is ERC-4626?

ERC-4626 is the tokenized vault standard. Users deposit assets, receive vault shares representing their proportional ownership, and withdraw their share of the growing pool anytime.

## Vault Strategies

- **Conservative**: Morpho Blue USDC supply (low risk, ~5-8% APY)
- **Balanced**: 50% Morpho + 50% Aerodrome USDC/USDC+ LP (~12-18% APY)
- **Aggressive**: Aerodrome concentrated LP + auto-rebalance (~25-40% APY)

## Installation

```bash
git clone https://github.com/fabt31/base-erc4626-vault
cd base-erc4626-vault
forge install
forge build
forge test
```

## Usage

```solidity
// Deposit 1000 USDC
IERC20(USDC).approve(vault, 1000e6);
uint256 shares = vault.deposit(1000e6, msg.sender);

// Redeem shares
uint256 assets = vault.redeem(shares, msg.sender, msg.sender);
```

## Security

- Audited by [Pending]
- OpenZeppelin ERC4626 base implementation
- Reentrancy guards on all state-changing functions
- Emergency pause mechanism

## License

MIT
