prepare:
	mkdir -p target

build: prepare
	gcc main.cpp ./include/libwasmer_runtime_c_api.so -o target/fibo_wasm_from_rust

run:
	./target/fibo_wasm_from_rust

clean:
	rm -rf target