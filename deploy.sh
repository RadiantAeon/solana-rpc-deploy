#!/bin/bash

# args: $AGAVE_VERSION $YELLOWSTONE-GRPC-GIT-REV
no_rpc="n"
if [ "$#" -ne 2 ]; then
    echo "Not enough params: run this script with the following args: AGAVE_VERSION YELLOWSTONE-GRPC-GIT-REV"
    echo "If you only want to install non rpc components, enter y:"
    read no_rpc
    if [ "$no_rpc" != "y" ]; then
        exit 1
    fi
fi

rpc_x_token=$(cat /proc/sys/kernel/random/uuid)
geyser_x_token=$(cat /proc/sys/kernel/random/uuid)
jupiter_x_token=$(cat /proc/sys/kernel/random/uuid)
starting_pwd=$(pwd)

# updates
sudo apt-get update
sudo apt-get upgrade -y

# solana user
sudo useradd -M solana
sudo usermod -L solana

# setup service
sudo cp solana-validator.service /etc/systemd/system/solana-validator.service
sudo systemctl enable solana-validator.service
sudo systemctl stop solana-validator.service

# get requirements to build agave validator
curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
rustup update
sudo apt-get install -y libssl-dev libudev-dev pkg-config zlib1g-dev llvm clang cmake make libprotobuf-dev protobuf-compiler libclang-dev

# clone validator
sudo mkdir /solana
cd /solana
git clone https://github.com/anza-xyz/agave

# install solana cli tools
sh -c "$(curl -sSfL https://release.anza.xyz/v2.2.3/install)"
PATH="/root/.local/share/solana/install/active_release/bin:$PATH"

# generate validator identity
solana-keygen new -o /solana/unstaked_validator_identity.json
ln -sf /solana/unstaked_validator_identity.json /solana/validator_identity.json

cd $starting_pwd
if [ "$no_rpc" != "y" ]; then
    # setup nginx
    sudo apt-get install nginx
    # probably not the best way but it works!
    sudo cp nginx-reverse-proxy /etc/nginx/sites-enabled/default
    sudo sed -i s/RPC_X_TOKEN/$rpc_x_token/g /etc/nginx/sites-enabled/default
    sudo sed -i s/JUPITER_X_TOKEN/$jupiter_x_token/g /etc/nginx/sites-enabled/default

    # clone yellowstone-grpc
    # @TODO - this doesn't install all deps for yellowstone
    cd /solana
    git clone https://github.com/rpcpool/yellowstone-grpc
    cd $starting_pwd
    cp yellowstone-geyser-config.json /solana/yellowstone-grpc/yellowstone-grpc-geyser/config.json
    sed -i s/GEYSER_X_TOKEN/$geyser_x_token/g /solana/yellowstone-grpc/yellowstone-grpc-geyser/config.json

    # build validator and yellowstone plugin
    bash build-validator.sh $1 $3
else
    # just build validator
    bash build-validator.sh $1
fi


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

# echo the variables
if [ "$no_rpc" != "y" ]; then
    echo RPC is deloyed at http://0.0.0.0:8899/$rpc_x_token
    echo Yellowstone GRPC Geyser is deployed at http://0.0.0.0:10000 with X_TOKEN=$geyser_x_token
    echo Jupiter is deployed at http://0.0.0.0:8899/$jupiter_x_token
else
    echo Validator deployed! Don\'t forget to change the start_validator params and copy keys.
fi
