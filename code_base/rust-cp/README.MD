Build

```
cargo build --target=wasm32-wasi --release
```

Run 

```
wasmer target/wasm32-wasi/release/rust-cp.wasm 
```