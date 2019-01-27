#!/bin/bash

#                   rust
# --------------------------------------------------
alias cn='cargo new'
alias cb='cargo build'
alias cr='cargo run'
alias cf='cargo fmt'
alias cbw='cargo build --release --target wasm32-unknown-unknown'
alias wbw='wasm-build --target wasm32-unknown-unknown'
alias ce='cargo expand'
alias cee='cargo expand >./src/expand.rs'


#                   parity
# --------------------------------------------------
alias p0='parity --config node0.toml -l parity-wasm=debug'
alias pd0='parity-d --config node0.toml -l parity-wasm=debug'
#export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/src


#                   ruby
# --------------------------------------------------
alias bi='bundle install'
alias bu='bundle update'
alias js='bundle exec jekyll serve'
