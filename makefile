compile-cpp:
	g++ fibo/fibo.cpp -o fibo_cpp.exe

compile-rust:
	rustc fibo/fibo.rs -o fibo_rust.exe

wasm-cpp:
	emcc fibo/fibo.cpp -o fibo_cpp.wasm

wasm-rust:
	rustc +nightly fibo/fibo.rs --target wasm32-wasi -o fibo_rust.wasm

compile: compile-rust compile-cpp

wasm: wasm-rust wasm-cpp

clean:
	rm -rf fibo_*.exe
	rm -rf fibo_*.wasm
	rm -rf fibo_*.js
	rm -rf fibo_*.html
