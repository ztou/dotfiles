#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# by default ln -s will create copy
# https://github.com/git-for-windows/git/pull/156
export MSYS=winsymlinks:nativestrict

function backup_link() {
    full_link=$1
    old_link=$full_link.old
    if [ -f "$full_link" ] && ! [ -L "$full_link" ]; then
        echo "found $full_link, rename it to $old_link"
        mv "$full_link" "$old_link"
    fi
}

function create_link() {
    full_link=$1
    name=$(basename "$full_link")
    source_link=~/dotfiles/$name

    if [ -f "$source_link" ]; then
        if ln -s "$source_link" "$full_link"
        then
            echo "create link: $full_link to $source_link successfully"
        fi
    fi

    old_link=$full_link.old
    if [ -f "$old_link" ]; then
        echo "source $old_link in $full_link"
        {
            echo ""
            echo "source \"$old_link\""
        } >> "$full_link"
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

create_link ~/.alias-git.bash
create_link ~/.alias-vault.bash
backup_link ~/.alias.bash
create_link ~/.alias.bash
backup_link ~/.priv.bash
create_link ~/.priv.bash
backup_link ~/.bashrc
create_link ~/.bashrc

create_link ~/.inputrc
create_link ~/.vimrc
create_link ~/.vsvimrc
create_link ~/.xvimrc
create_link ~/.tmux.conf
create_link ~/.isort.cfg

# zsh - move this up, since fzf will create the .zshrc/.bashrc file
create_link ~/.fzfrc.bash
backup_link ~/.zshrc
create_link ~/.zshrc

echo "installing fzf"
git submodule update --init --recursive
"$CURRENT_DIR/sb/fzf/install" --key-bindings --completion --update-rc


# plugins
# brew install thefuck
if [ -d ~/.oh-my-zsh ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
fi

#                   git auto completion
# --------------------------------------------------
case "$(uname -s)" in
    Linux*)     sudo curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o /etc/bash_completion.d/git-completion.bash;;

    Darwin*)    brew install bash-completion hub thefuck pyenv pyenv-virtualenv;;

    # Windows - C:\Program Files\Git\mingw64\share\git\completion\git-completion.bash
    *)
esac


echo "--------------------------------------------------"
echo "      ~/dotfiles are installed successfully"
echo "--------------------------------------------------"

