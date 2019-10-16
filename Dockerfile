FROM ubuntu:18.10

SHELL ["/bin/bash", "-c"]

# install dependencies
RUN apt update \
 && apt install -y curl git python libxml2 cmake g++

# install cpp toolchain
RUN git clone https://github.com/emscripten-core/emsdk.git \
 && cd emsdk \
 && ./emsdk install sdk-1.38.26-64bit \
 && ./emsdk activate sdk-1.38.26-64bit \
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
 && rustup target add wasm32-unknown-emscripten --toolchain nightly \
 && cargo install wasm-gc

RUN curl https://get.wasmer.io -sSfL | sh

RUN apt install -y time openjdk-11-jre
RUN echo ". /emsdk/emsdk_env.sh" >> /root/.profile

WORKDIR /project

ENTRYPOINT ["bash", "-l"]
