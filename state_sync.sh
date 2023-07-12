#!/bin/bash
set -uxe

astrad tendermint unsafe-reset-all --home .astrad

# MAKE HOME FOLDER AND GET GENESIS
astrad init validator --chain-id astra_11110-1
INTERVAL=3000
# GET TRUST HASH AND TRUST HEIGHT

LATEST_HEIGHT=$(curl -s https://cosmos.astranaut.io:26657/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$(($LATEST_HEIGHT-$INTERVAL))
TRUST_HASH=$(curl -s "https://cosmos.astranaut.io:26657/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)



# TELL USER WHAT WE ARE DOING
echo "TRUST HEIGHT: $BLOCK_HEIGHT"
echo "TRUST HASH: $TRUST_HASH"

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"http://159.65.13.59:26657,http://104.248.149.15:26657\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.astrad/config/config.toml

sed -i.bak -E 's#^(seeds[[:space:]]+=[[:space:]]+).*$#\1"665532046ce09bb9c364826cc6b589ca89eddea2@34.87.148.96:26656,2c7f17ac837a023270f137d4c8e66a6757c7f0be@34.96.182.32:26656"#' ~/.astrad/config/config.toml
sed -i.bak -E 's#^(timeout_commit[[:space:]]+=[[:space:]]+).*$#\1"2400s"#' ~/.astrad/config/config.toml
