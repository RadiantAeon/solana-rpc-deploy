#!/bin/bash

# example script of the above steps - change IP obviously
# copied from https://pumpkins-pool.gitbook.io/pumpkins-pool
solana-validator -l /solana/ledger wait-for-restart-window --min-idle-time 2 --skip-new-snapshot-check
solana-validator -l /solana/ledger set-identity /solana/unstaked_validator_identity.json
ln -sf /solana/unstaked_validator_identity.json /solana/validator_identity.json
scp /solana/ledger/tower-1_9-$(solana-keygen pubkey /solana/staked_validator_identity.json).bin sol@68.100.100.10:/solana/ledger