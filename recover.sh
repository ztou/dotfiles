#!/bin/bash

function cleanup_link() {
    full_link=$1
    if [ -f "$full_link" ]; then
        echo "remove link: $full_link"
        rm -f "$full_link"
    fi

    old_link=$full_link.old
    if [ -f "$old_link" ]; then
        echo "recover old link: $old_link"
        mv "$old_link" "$full_link"
    fi
}


cleanup_link ~/.alias.bash
cleanup_link ~/.priv.bash
cleanup_link ~/.bashrc
cleanup_link ~/.inputrc
cleanup_link ~/.vimrc
cleanup_link ~/.vsvimrc
cleanup_link ~/.xvimrc
cleanup_link ~/.tmux.conf


# zsh
cleanup_link ~/.fzfrc.bash
cleanup_link ~/.zshrc

