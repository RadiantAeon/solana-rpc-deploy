#!/bin/bash

# example script of the above steps - change IP obviously
# copied from https://pumpkins-pool.gitbook.io/pumpkins-pool
if [ "$#" -ne 3 ]; then
    echo "Not enough params: run this script with the following args: COLD_SERVER_SSH SOURCE_VARIANT DEST_VARIANT"
    echo "Variant strings are: \"fd\" and \"agave\""
    exit 1;
fi

if ([$2 != "agave" ] && [$2 != "fd"]) || ([$3 != "agave" ] && [$3 != "fd"]); then
    echo "Variant strings are: \"fd\" and \"agave\""
    exit 1;
fi

if [$2 = "fd"] && ([! -f /solana/firedancer/build/native/gcc/bin/fdctl] || [! -f /solana/firedancer/firedancer_config.toml]); then
    echo "Did not find /solana/firedancer/build/native/gcc/bin/fdctl and/or /solana/firedancer/firedancer_config.toml! Are you sure you're running firedancer locally?"
    exit 1;
fi

/solana/jito-solana/target/release/agave-validator -l /solana/ledger wait-for-restart-window --min-idle-time 2 --skip-new-snapshot-check
ln -sf /solana/unstaked_validator_identity.json /solana/validator_identity.json
scp /solana/ledger/tower-1_9-$(solana-keygen pubkey /solana/staked_validator_identity.json).bin $1:/solana/ledger
if [$2 == "agave"]; then
    /solana/jito-solana/target/release/agave-validator -l /solana/ledger set-identity /solana/unstaked_validator_identity.json
else
    /solana/firedancer/build/native/gcc/bin/fdctl set-identity --config /solana/firedancer/firedancer_config.toml /solana/unstaked_validator_identity.json
fi
if [$3 == "agave"]; then
    ssh $1 'bash -s' < hotswap_cold_agave.sh
else
    ssh $1 'bash -s' < hotswap_cold_firedancer.sh 
fi