# wasmer-talk
Groups demo for the talk named "Wasmer : la VM du futur ?"


## How to

Build the docker image that contains all the tools to build wasm binaries :
```bash
$ docker build . -t wasm
```

Run this docker image by providing the project as volume
```bash
$ docker run -it --rm -v $PWD:/project wasm:latest
```

Run the `make` commands that you want to build conventional binaries:
```bash
$ make compile-cpp # to compile only fibo.cpp to fibo_cpp.exe
$ make compile-rust # to compile only fibo.rs to fibo_rust.exe
$ make compile # to do both previous commands at once
```

Run the `make` commands that you want to build Webassembly binaries:
```bash
$ make wasm-cpp # to compile only fibo.cpp to fibo_cpp.wasm
$ make wasm-rust # to compile only fibo.rs to fibo_rust.wasm
$ make wasm # to do both previous commands at once
```

The `make clean` command will remove all binaries.


## Interesting Links

### Tuto and Explorer
https://emscripten.org  
https://rustwasm.github.io/book/  
https://mbebenita.github.io/WasmExplorer/

### Some blog posts
https://medium.com/wasmer/executing-webassembly-in-your-rust-application-d5cd32e8ce46
https://medium.com/wasmer/running-webassembly-from-any-language-5741f6320ccd
https://ariya.io/2019/05/basics-of-memory-access-in-webassembly  
