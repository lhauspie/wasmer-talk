# Démos

## Préparation
docker run -it --rm -v $PWD:/project wasm:latest
make all
cd calling_wasm/rust && make build
make clean

Ouvrir les onglets
Démarrer VM Windows
Démarrer le cast du téléphone
cd /home/alocquet/dev/projects/zenika/conf/scrcpy
./run x

## Démo - wasmer
make all
wasmer run target/fibo_rust.wasm 34

## Démo - sécurité
cd code_base/rust-cp
cargo +nightly build --target=wasm32-wasi
wasmer run target/wasm32-wasi/debug/rust-cp.wasm Cargo.toml todelete.toml
wasmer run target/wasm32-wasi/debug/rust-cp.wasm --dir=. -- Cargo.toml todelete.toml

## Démo perf
make perf

## Démo WAPM
wapm install -g torch2424/wasm-matrix
wasm-matrix -l 15 -c 15

Partie windows : password : azerty

## Démo code cross language
cd calling_wasm/rust
make build
make run
cd ../cpp
make build
make run
