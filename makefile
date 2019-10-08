prepare:
	mkdir -p target

compile-cpp: prepare
	g++ code_base/cpp/fibo.cpp code_base/cpp/main.cpp -o target/fibo_cpp.exe

compile-rust: prepare
	rustc code_base/rust/fibo.rs -o target/fibo_rust.exe

wasm-cpp: prepare
	em++ -Os code_base/cpp/main.cpp -Os code_base/cpp/fibo.cpp -s EXPORT_ALL=1 -s ONLY_MY_CODE=1 -g -o target/fibo_cpp.wasm

wasm-rust: prepare
	rustc +nightly code_base/rust/fibo.rs --target wasm32-wasi -o target/fibo_rust.wasm

compile: compile-rust compile-cpp

wasm: wasm-rust wasm-cpp

clean:
	rm -rf target/*
