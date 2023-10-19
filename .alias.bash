#!/bin/bash

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]:-$0:A}")" >/dev/null && pwd)"

#                   general
# --------------------------------------------------
alias reload='source ~/.zshrc'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias so='scoop'
alias ecode='export GIT_EDITOR="code -w"'
alias ce='code ~/.env'

function ex() {
    cat ~/.env && export $(cat ~/.env | grep -v '^#' | tr -d '\r')
}

function uex() {
    cat ~/.env && unset $(cat ~/.env | grep -v '^#' | sed -E -n 's/^([^=]+)=.*/\1/p')
}

#                   python
# --------------------------------------------------
alias pbuild='python setup.py sdist bdist_wheel --universal'
alias pupload='python setup.py upload'
#                   docker
# --------------------------------------------------
alias ds='docker start -ai'
alias dp='docker ps'
alias dr='docker run -it'
alias dre='docker run -it --env-file ${ENV_FILE}'
alias dc='docker compose'

#                   git
# --------------------------------------------------
source $DOTFILES/.alias-git.bash

[ -f ~/.priv.bash ] && source ~/.priv.bash
