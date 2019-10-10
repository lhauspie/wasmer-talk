Build

```
cargo build --target=wasm32-wasi --release
```

Run 

```
wasmer run target/wasm32-wasi/release/rust-cp.wasm Cargo.toml copy.toml
wasmer run target/wasm32-wasi/release/rust-cp.wasm Cargo.toml copy.toml --dir=.
```