#!/bin/bash
solana-validator -l /solana/ledger set-identity --require-tower /solana/staked_validator_identity.json
ln -sf /solana/staked_validator_identity.json /solana/validator_identity.json