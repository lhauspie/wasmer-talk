prepare:
	mkdir -p target

compile-cpp: prepare
	g++ code_base/cpp/fibo.cpp code_base/cpp/main.cpp -o target/fibo_cpp

compile-rust: prepare
	rustc code_base/rust/src/main.rs -o target/fibo_rust -C opt-level=3

wasm-cpp: prepare
	emcc code_base/cpp/main.cpp code_base/cpp/fibo.cpp -g -o target/fibo_cpp.wasm
	emcc -Os code_base/cpp/main.cpp -Os code_base/cpp/fibo.cpp -s EXPORTED_FUNCTIONS='["__Z4fiboj"]' -s ONLY_MY_CODE=1 -g -o target/fibo_cpp_js.wasm

wasm-rust: prepare
	cd code_base/rust && cargo +nightly build --target wasm32-wasi --release
	cd code_base/rust && cargo +nightly build --target wasm32-unknown-unknown --release
	# cd code_base/rust && cargo +nightly build --target wasm32-unknown-emscripten --release
	cd code_base/rust && wasm-gc target/wasm32-unknown-unknown/release/fibo_rust.wasm -o target/fibo_rust.gc.wasm
	cp code_base/rust/target/fibo_rust.gc.wasm target/fibo_rust_js.wasm
	cp code_base/rust/target/wasm32-wasi/release/fibo_rust.wasm target/fibo_rust.wasm
	# rustc --target=wasm32-unknown-emscripten code_base/rust/src/main.rs -o target/fibo_rust.js -C opt-level=s

compile: compile-rust compile-cpp

wasm: wasm-rust wasm-cpp

perf:
	@echo "******************** RUST NATIF ********************"
	time target/fibo_rust 43
	@echo "******************** CPP NATIF ********************"
	time target/fibo_cpp 43
	@echo "******************** WASM RUST ********************"
	time wasmer run target/fibo_rust.wasm 43
	@echo "******************** WASM CPP ********************"
	time wasmer run target/fibo_cpp.wasm 43
	@echo "******************** JVM ********************"
	time java -cp code_base/java Fibonacci 43
	@echo "******************** JVM without JIT ********************"
	time java -Xint -cp code_base/java Fibonacci 37

clean:
	find . -name "target" | xargs rm -rf