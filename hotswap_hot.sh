#!/bin/bash

# example script of the above steps - change IP obviously
# copied from https://pumpkins-pool.gitbook.io/pumpkins-pool
if [ "$#" -ne 1 ]; then
    echo "Not enough params: run this script with the following args: COLD_SERVER_SSH"
    exit 1;
fi
/solana/jito-solana/target/release/agave-validator -l /solana/ledger wait-for-restart-window --min-idle-time 2 --skip-new-snapshot-check
scp /solana/ledger/tower-1_9-$(solana-keygen pubkey /solana/staked_validator_identity.json).bin $1:/solana/ledger
/solana/jito-solana/target/release/agave-validator -l /solana/ledger set-identity /solana/unstaked_validator_identity.json
ln -sf /solana/unstaked_validator_identity.json /solana/validator_identity.json
ssh $1 'bash -s' < hotswap_cold.sh