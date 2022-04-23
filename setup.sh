#!/bin/bash

export DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]:-$0:A}" )" >/dev/null && pwd )"

# by default ln -s will create copy
# https://github.com/git-for-windows/git/pull/156
export MSYS=winsymlinks:nativestrict


function test_app() {
    type $1 >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Can not find $1, please install $1 first."
        exit 1
    fi
}

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
    source_link=$DOTFILES/$name

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

backup_link ~/.alias.bash
create_link ~/.alias.bash
backup_link ~/.alias-jenkins.bash
create_link ~/.alias-jenkins.bash
backup_link ~/.bash_profile
create_link ~/.bash_profile
backup_link ~/.bashrc
create_link ~/.bashrc

create_link ~/.inputrc
create_link ~/.vimrc
create_link ~/.vsvimrc
create_link ~/.xvimrc
create_link ~/.tmux.conf
create_link ~/.isort.cfg
create_link ~/.clang-format

# zsh - move this up, since fzf will create the .zshrc/.bashrc file
create_link ~/.fzfrc.bash
backup_link ~/.zshenv
create_link ~/.zshenv
backup_link ~/.zshrc
create_link ~/.zshrc

echo "init submodules..."
git submodule update --init --recursive

echo "installing fzf..."
"$DOTFILES/sb/fzf/install" --key-bindings --no-completion --update-rc

echo "trying to install utils tools..."
case "$(uname -s)" in
    Linux*)
        sudo curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o /etc/bash_completion.d/git-completion.bash;;

    Darwin*)
        test_app brew
        brew install hub jq bash-completion thefuck pyenv pyenv-virtualenv pipenv tree;;

    MINGW64*)
        test_app scoop
        scoop install hub 7zip ag bat curl dig fd jq less which;;
    *)
esac

# plugins for zsh
if [ -d ~/.oh-my-zsh ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
fi

echo "--------------------------------------------------"
echo "      ~/dotfiles are installed successfully"
echo "--------------------------------------------------"
