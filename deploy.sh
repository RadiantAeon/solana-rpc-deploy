#!/bin/bash

# args: $AGAVE_VERSION $RPC_X_TOKEN $YELLOWSTONE-GRPC-GIT-REV $GEYSER_X_TOKEN $JUPITER_X_TOKEN
if [ "$#" -ne 5 ]; then
    echo "Not enough params: run this script with the following args: AGAVE_VERSION RPC_X_TOKEN YELLOWSTONE-GRPC-GIT-REV GEYSER_X_TOKEN JUPITER_X_TOKEN"
    exit 1
fi

starting_pwd=$(pwd)

# updates
sudo apt-get update
sudo apt-get upgrade -y

# solana user
sudo useradd -M solana
sudo usermod -L solana

# setup nginx
sudo apt-get install nginx
# probably not the best way but it works!
sudo cp nginx-reverse-proxy /etc/nginx/sites-enabled/default
sudo sed -i s/RPC_X_TOKEN/$2/g /etc/nginx/sites-enabled/default
sudo sed -i s/JUPITER_X_TOKEN/$5/g /etc/nginx/sites-enabled/default

# setup service
sudo cp solana-validator.service /etc/systemd/system/solana-validator.service
sudo systemctl enable solana-validator.service
sudo systemctl stop solana-validator.service

# get requirements to build agave validator
curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
rustup update
sudo apt-get install libssl-dev libudev-dev pkg-config zlib1g-dev llvm clang cmake make libprotobuf-dev protobuf-compiler

# clone validator
mkdir /solana
cd /solana
git clone https://github.com/anza-xyz/agave

# install solana cli tools
sh -c "$(curl -sSfL https://release.solana.com/v1.18.18/install)"
PATH="/root/.local/share/solana/install/active_release/bin:$PATH"

# generate validator identity
solana-keygen new -o /solana/validator_identity.json

# clone yellowstone-grpc
# @TODO - this doesn't install all deps for yellowstone
cd /solana
git clone https://github.com/rpcpool/yellowstone-grpc
cd $starting_pwd
cp yellowstone-geyser-config.json /solana/yellowstone-grpc/yellowstone-grpc-geyser/config.json
sed -i s/GEYSER_X_TOKEN/$4/g /solana/yellowstone-grpc/yellowstone-grpc-geyser/config.json

# build validator and yellowstone plugin
bash build-validator.sh $1 $3

# tune knobs or whatever
sudo cp sysctl.conf /etc/sysctl.d/21-solana-validator.conf
sudo sysctl -p /etc/sysctl.d/21-solana-validator.conf

# logrotate
sudo cp logrotate /etc/logrotate.d/sol
systemctl restart logrotate.service

# move validator start script
cp start_validator.sh /solana/start_validator.sh
chmod +x /solana/start_validator.sh

# transfer ownership of /solana directory to the solana user
chown -R solana /solana
chown -R $(whoami) /solana/agave
chmod -R +r /solana/agave
chown -R $(whoami) /solana/yellowstone-grpc
chmod -R +r /solana/yellowstone-grpc

# start rpc
sudo systemctl start solana-validator.service