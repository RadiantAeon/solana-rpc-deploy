#!/bin/bash
/solana/firedancer/build/native/gcc/bin/fdctl set-identity --config /solana/firedancer/firedancer_config.toml /solana/staked_validator_identity.json --require-tower --force
sudo chown solana -R /solana/ledger
ln -sf /solana/staked_validator_identity.json /solana/validator_identity.json
