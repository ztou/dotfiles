#!/bin/bash

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]:-$0:A}")" >/dev/null && pwd)"

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
        if ln -s "$source_link" "$full_link"; then
            echo "create link: $full_link to $source_link successfully"
        fi
    fi

    old_link=$full_link.old
    if [ -f "$old_link" ]; then
        echo "source $old_link in $full_link"
        {
            echo ""
            echo "source \"$old_link\""
        } >>"$full_link"
    fi
}

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
backup_link ~/.zshenv
create_link ~/.zshenv
backup_link ~/.zshrc
create_link ~/.zshrc

echo "init submodules..."
git submodule update --init --recursive

echo "trying to install utils tools..."
case "$(uname -s)" in
Linux*)
    echo "installing git-completion.bash..."
    curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o /etc/bash_completion.d/git-completion.bash

    test_app git
    echo "installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --key-bindings --completion --update-rc

    echo "installing starship..."
    curl -sS https://starship.rs/install.sh | sh
    ;;

Darwin*)
    test_app brew
    brew install hub bat fd jq bash-completion tree starship zsh-autosuggestions zsh-syntax-highlighting
    brew tap homebrew/cask-fonts
    brew install --cask font-fira-code
    brew install fzf
    # To install useful key bindings and fuzzy completion:
    $(brew --prefix)/opt/fzf/install --key-bindings --completion --update-rc
    ;;

MINGW64*)
    test_app scoop
    scoop install hub 7zip ag bat curl fd jq less which starship
    scoop bucket add nerd-fonts
    scoop install firacode
    scoop install fzf
    ;;

*) ;;
esac

echo "--------------------------------------------------"
echo "      ~/dotfiles are installed successfully"
echo "--------------------------------------------------"
