#!/bin/bash

# readlink - readlink symbol link location
#
DOTFILES="$(cd "$(dirname "$(readlink ${BASH_SOURCE[0]:-$0:A})")" >/dev/null && pwd)"

#
# from - https://conemu.github.io/en/CygwinMsys.html#bash-history
#
# ignore duplicate
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=5000

# Allow "sharing" of history between instances
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
#PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

export TERM=cygwin
export LANG=en_US.UTF-8

source $DOTFILES/.alias.bash
alias reload='source ~/.bashrc'

# source z.sh before fzfrc.bash
source $DOTFILES/sb/z/z.sh

if [ -f ~/.fzf.bash ]; then
    source ~/.fzf.bash
    source $DOTFILES/.fzfrc.bash
    source $DOTFILES/fzf-git.bash
fi

eval "$(starship init bash)"

#source $DOTFILES/sb/vault-utils/.alias-vault.bash

#source $DOTFILES/.pyenv.bash
