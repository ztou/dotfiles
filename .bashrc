#!/bin/bash

# readlink - readlink symbol link location
#
DOTFILES="$( cd "$( dirname "$(readlink ${BASH_SOURCE[0]:-$0:A})" )" >/dev/null && pwd )"

# from - https://conemu.github.io/en/CygwinMsys.html#bash-history

# ignore duplicate
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=5000

# Allow "sharing" of history between instances
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
#PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

function source_bash() {
    bash_file=$1
    if [ -f $bash_file ]; then
        source $bash_file
    else
        echo "warning - not able to find file: $bash_file, ignore"
    fi
}

source_bash $DOTFILES/.alias.bash
alias reload='source ~/.bashrc'

source_bash $DOTFILES/sb/z/z.sh

__git_complete ga _git_add
__git_complete gb _git_branch
__git_complete gco _git_checkout
__git_complete fco _git_checkout


#                   fzf
# --------------------------------------------------
# https://github.com/junegunn/fzf/issues/963
#
export TERM=cygwin
# export TERM=xterm-256color
# export TERM=xterm-color
# export TERM=xterm
# export TERM=

source_bash ~/.fzf.bash
source_bash $DOTFILES/.fzfrc.bash
source_bash $DOTFILES/fzf-git.bash

# ssh-agent
# source_bash $DOTFILES/.ssh-agent.bash

eval "$(starship init bash)"

# disable hub alias since it causes 0.07 second delay on running bash command
#
#eval "$(hub alias -s bash)"
