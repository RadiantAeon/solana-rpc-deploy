#!/bin/bash
cd /solana/agave
git pull
git checkout $1
cargo build --release

if [$2 -ne '']; then
    cd /solana/yellowstone-grpc
    git pull
    git checkout $2
    cargo build --release
fi