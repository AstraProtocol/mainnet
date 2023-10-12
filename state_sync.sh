#!/bin/bash
set -uxe

#rm -rf ~/.astrad
#
#
## MAKE HOME FOLDER AND GET GENESIS
#astrad init state --chain-id astra_11110-1
curl https://raw.githubusercontent.com/AstraProtocol/mainnet/main/genesis.json > ~/.astrad/config/genesis.json
INTERVAL=20000
# GET TRUST HASH AND TRUST HEIGHT

LATEST_HEIGHT=$(curl -s https://cosmos.astranaut.io:26657/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$(($LATEST_HEIGHT-$INTERVAL))
TRUST_HASH=$(curl -s "https://cosmos.astranaut.io:26657/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)



# TELL USER WHAT WE ARE DOING
echo "TRUST HEIGHT: $BLOCK_HEIGHT"
echo "TRUST HASH: $TRUST_HASH"

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"https://cosmos.astranaut.io:26657,https://cosmos.astranaut.io:26657\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.astrad/config/config.toml

sed -i.bak -E 's#^(seeds[[:space:]]+=[[:space:]]+).*$#\1"665532046ce09bb9c364826cc6b589ca89eddea2@34.87.148.96:26656,a99a441714f2d11c69b5746e4ff6ad64a9fa0ad7@34.92.235.232:26656"#' ~/.astrad/config/config.toml
sed -i.bak -E 's#^(timeout_commit[[:space:]]+=[[:space:]]+).*$#\1"2400ms"#' ~/.astrad/config/config.toml

# astrad start --x-crisis-skip-assert-invariants
