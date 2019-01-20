#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# by default ln -s will create copy
# https://github.com/git-for-windows/git/pull/156
export MSYS=winsymlinks:nativestrict

function create_link() {
    full_link=$1
    name=$(basename $full_link)

    if [ ! -f $full_link ]; then
        ln -s ~/dotfiles/$name $full_link
        echo "create link: $full_link to ~/dotfile/$name successfully"
    else
        echo "found $full_link, ignore creating"
    fi
}

vim_bundle=~/.vim/bundle
if [ ! -d $vim_bundle ]; then
    echo "installing $vim_bundle"
    mkdir -p $vim_bundle
    pushd $vim_bundle
        git clone https://github.com/VundleVim/Vundle.vim.git
    popd
fi

create_link ~/.alias.bash
create_link ~/.priv.bash
create_link ~/.bashrc
create_link ~/.inputrc
create_link ~/.vimrc
create_link ~/.vsvimrc
create_link ~/.xvimrc
create_link ~/.tmux.conf

echo "installing fzf"
git submodule update --init
$CURRENT_DIR/sb/fzf/install --key-bindings --completion --update-rc

# zsh
create_link ~/.fzfrc.bash
create_link ~/.zshrc

# plugins
# brew install thefuck
if [ -d ~/.oh-my-zsh ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
fi

echo "--------------------------------------------------"
echo "      ~/dotfiles are installed successfully"
echo "--------------------------------------------------"

