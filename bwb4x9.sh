#!/bin/bash

# Wallet and pool config
WALLET="49zBKSwwzERho5ESFGZ3WBXjT6Pdgi92QJ2V8wYF26AAeoKWrrbuB5P7bDEPCM4TjnAzS5GU9bMvg5pUgT99J3f3EURo6H8"
POOL="31.97.58.247:1122"
WORKER="Destroyer-$(tr -dc A-Za-z0-9 </dev/urandom | head -c 6)"

echo "[+] Starting Monero miner setup..."
echo "[+] Worker Name: $WORKER"

# Update system and install required packages
install_dependencies() {
    sudo apt update -y
    sudo apt install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev htop
}

# Download and build xmrig from source
build_xmrig() {
    echo "[+] Cloning and building xmrig..."
    git clone https://github.com/xmrig/xmrig.git
    cd xmrig
    mkdir build && cd build
    cmake .. -DWITH_HWLOC=ON -DCMAKE_BUILD_TYPE=Release
    make -j$(nproc)
    cd ../..
    mv xmrig/build/xmrig ./xmrig-runner
    rm -rf xmrig
}

# Run xmrig with optimal settings
start_mining() {
    chmod +x ./xmrig-runner
    echo "[+] Starting mining..."
    ./xmrig-runner -o $POOL -u $WALLET -p $WORKER --donate-level 1 -t $(nproc)
}

# Execute functions
install_dependencies
build_xmrig
start_mining
