#!/bin/bash
/solana/jito-solana/target/release/agave-validator -l /solana/ledger set-identity --require-tower /solana/staked_validator_identity.json
sudo chown solana -R /solana/ledger
ln -sf /solana/staked_validator_identity.json /solana/validator_identity.json