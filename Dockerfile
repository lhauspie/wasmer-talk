FROM ubuntu:18.10

SHELL ["/bin/bash", "-c"]

# install dependencies
RUN apt update \
 && apt install -y curl git python libxml2 cmake g++

# install cpp toolchain
RUN git clone https://github.com/emscripten-core/emsdk.git \
 && cd emsdk \
 && ./emsdk install 1.38.46 \
 && ./emsdk activate 1.38.46 \
 && . ./emsdk_env.sh

# install rust toolchain
RUN curl https://sh.rustup.rs -sSf -o rustup-init.sh \
 && /bin/sh ./rustup-init.sh -y \
 && rm rustup-init.sh \
 && . ~/.profile \
 && . ~/.cargo/env \
 && rustup toolchain install nightly \
 && rustup target add wasm32-wasi --toolchain nightly \
 && rustup target add wasm32-unknown-unknown --toolchain nightly \
 && cargo install wasm-gc

RUN /root/.cargo/bin/rustup target add wasm32-unknown-emscripten --toolchain nightly

RUN curl https://get.wasmer.io -sSfL | sh

ENV PATH="/root/.cargo/bin:${PATH}"
ENV PATH="${PATH}:/emsdk"
ENV PATH="${PATH}:/emsdk/clang/fastcomp/build_incoming_64/bin"
ENV PATH="${PATH}:/emsdk/node/8.9.1_64bit/bin"
ENV PATH="${PATH}:/emsdk/emscripten/incoming"
ENV PATH="${PATH}:/emsdk/binaryen/master_64bit_binaryen/bin"
ENV PATH="${PATH}:/emsdk/fastcomp/emscripten"
ENV PATH="${PATH}:/emsdk/node/12.9.1_64bit/bin"

ENV EMSDK="/emsdk"
ENV EM_CONFIG="/root/.emscripten"
ENV EMSCRIPTEN="/emsdk/emscripten/incoming"
ENV BINARYEN_ROOT="/emsdk/binaryen/master_64bit_binaryen"
ENV EMSDK_NODE="/emsdk/node/12.9.1_64bit/bin/node"

WORKDIR /project

ENTRYPOINT ["bash", "-l"]
