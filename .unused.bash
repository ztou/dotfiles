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

# start ssh-agent
# source ~/dotfiles/.ssh-agent.bash

# eval "$(hub alias -s)"
eval "$(pyenv init -)"

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

__git_complete ga _git_add
__git_complete gb _git_branch
__git_complete gco _git_checkout
__git_complete fco _git_checkout

# export TERM=xterm-256color
# export TERM=xterm-color
# export TERM=xterm
# export TERM=

# readlink - readlink symbol link location
#
DOTFILES="$(cd "$(dirname "$(readlink ${BASH_SOURCE[0]:-$0:A})")" >/dev/null && pwd)"

function source_bash() {
    bash_file=$1
    if [ -f $bash_file ]; then
        source $bash_file
    else
        echo "warning - not able to find file: $bash_file, ignore"
    fi
}

vim_bundle=~/.vim/bundle
if [ ! -d $vim_bundle ]; then
    echo "installing $vim_bundle"
    mkdir -p $vim_bundle
    pushd $vim_bundle || exit
    git clone https://github.com/VundleVim/Vundle.vim.git
    popd || exit
fi

#                   Windows specific
# --------------------------------------------------
v_ending='\r\n'

if [ "$(uname)" = "Darwin" ] || [ "$(uname)" = "Linux" ]; then
    v_ending='\n'
fi

#export $(cat .env | xargs)
function ex() {
    cat ~/.env && export $(grep -v '^#' ~/.env | tr $v_ending ' ')
}

function uex() {
    cat ~/.env && unset $(grep -v '^#' ~/.env | sed -E 's/(.*)=.*/\1/' | tr $v_ending ' ')
}
