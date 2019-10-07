compile-cpp:
	g++ code_base/cpp/fibo.cpp code_base/cpp/main.cpp -o fibo_cpp.exe

compile-rust:
	rustc code_base/rust/fibo.rs -o fibo_rust.exe

wasm-cpp:
	em++ -Os code_base/cpp/main.cpp -Os code_base/cpp/fibo.cpp -s EXPORT_ALL=1 -s ONLY_MY_CODE=1 -g -o fibo_cpp.wasm

wasm-rust:
	rustc +nightly code_base/rust/fibo.rs --target wasm32-wasi -o fibo_rust.wasm
	rustc +nightly code_base/rust/fibo.rs --target wasm32-unknown-unknown -o fibo_rust.wasm

compile: compile-rust compile-cpp

wasm: wasm-rust wasm-cpp

clean:
	rm -rf fibo_*.*
