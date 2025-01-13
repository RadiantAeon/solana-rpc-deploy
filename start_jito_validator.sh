#!/bin/bash

BLOCK_ENGINE_URL=https://frankfurt.mainnet.block-engine.jito.wtf
SHRED_RECEIVER_ADDR=145.40.93.84:1002
RELAYER_URL=http://frankfurt.mainnet.relayer.jito.wtf:8100

exec /solana/jito-solana/target/release/agave-validator\
        --identity /solana/validator_identity.json\
        --vote-account /solana/vote.json\
        --accounts /solana/accounts\
        --ledger /solana/ledger\
        --limit-ledger-size 50000000\
        --entrypoint entrypoint.mainnet-beta.solana.com:8001\
        --entrypoint entrypoint2.mainnet-beta.solana.com:8001\
        --entrypoint entrypoint3.mainnet-beta.solana.com:8001\
        --entrypoint entrypoint4.mainnet-beta.solana.com:8001\
        --entrypoint entrypoint5.mainnet-beta.solana.com:8001\
        --rpc-port 1100\
        --no-port-check\
        --account-index spl-token-owner\
        --account-index program-id\
        --log /solana/solana-validator.log\
        --snapshots /solana/snapshots\
        --full-rpc-api\
        --private-rpc\
        --maximum-local-snapshot-age 2500\
        --rpc-send-default-max-retries 0\
        --rpc-send-leader-count 2\
        --account-index-include-key SAVEYPDMSAYT2oRLdoHsyaHpWmB1YpWevD5gPqGJE9u\
        --account-index-include-key So1endDq2YkqhipRh3WViPa8hdiSpxWy6z3Z6tMCpAo\
        --account-index-include-key FarmsPZpWu9i7Kky8tPN37rs2TpmMrAZrC7S7vJa91Hr\
        --account-index-include-key KLend2g3cP87fffoy8q1mQqGKjrxjC8boSyAYavgmjD\
        --account-index-include-key KLendKi8jXBpa4GAG8UNFsd2npkRbLBxaPkciPVHWy5\
        --full-snapshot-interval-slots 10000\
        --incremental-snapshot-interval-slots 2000\
        --geyser-plugin-config /solana/yellowstone-grpc/yellowstone-grpc-geyser/config.json\
        --tip-payment-program-pubkey T1pyyaTNZsKv2WcRAB8oVnk93mLJw2XzjtVYqCsaHqt\
        --tip-distribution-program-pubkey 4R3gSG8BpU4t19KYj8CfnbtRpnT8gtk4dvTHxVRwc2r7\
        --merkle-root-upload-authority GZctHpWXmsZC1YHACTGGcHhYxjdRqQvTpYkb9LMvxDib\
        --commission-bps 1000\
        --relayer-url ${RELAYER_URL} \
        --block-engine-url ${BLOCK_ENGINE_URL} \
        --shred-receiver-address ${SHRED_RECEIVER_ADDR}\
        --block-verification-method unified-scheduler\