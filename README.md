# Yield Farming Smart Contract

## Overview
This Clarity smart contract implements a **Yield Farming** system on the Stacks blockchain, allowing users to stake LP tokens and earn rewards over time.

## Features
- **Stake LP Tokens** – Users can deposit LP tokens to earn rewards.
- **Unstake LP Tokens** – Users can withdraw their tokens after a set lock period.
- **Rewards System** – Rewards are calculated based on the staking duration and distributed from a reward pool.
- **Admin Controls** – Admin can set reward rates, minimum stake amounts, and lock periods.
- **Security Enhancements** – Minimum staking amount and lock period restrictions to prevent abuse.

## Smart Contract Functions
### Public Functions
- `stake(amount uint)` – Stake LP tokens.
- `unstake()` – Withdraw staked LP tokens after the lock period.
- `withdraw-rewards()` – Claim earned rewards.
- `set-reward-rate(new-rate uint)` – Admin-only function to update the reward rate.
- `set-min-stake(new-min uint)` – Admin-only function to update the minimum stake.
- `set-lock-period(new-lock uint)` – Admin-only function to modify the lock period.

### Read-Only Functions
- `calculate-rewards(user principal)` – Computes the user's pending rewards.

## Deployment
To deploy this contract on the Stacks blockchain, use the [Clarinet](https://github.com/hirosystems/clarinet) tool:
```sh
clarinet test
clarinet check
clarinet deploy
```

## License
MIT License

