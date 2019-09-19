#!/bin/bash

#                   Windows specific
# --------------------------------------------------
v_path='Scripts/activate'
alias open='explorer'
alias cc='cmd //c'

if [ "$(uname)" = "Darwin" ] || [ "$(uname)" = "Linux" ]; then
    v_path='bin/activate'
    unalias open
    unalias cc
fi

#                   general
# --------------------------------------------------
alias reload='source ~/.bashrc'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias td='tree -d -L 2'
alias t='tree -L 2'

#                   python
# --------------------------------------------------
alias penv='source $(pipenv --venv)/$v_path'
alias plr='pipenv lock -r'

alias pi='pip install'
alias pir='pip install -r requirements.txt'
alias pidev='pip install -e .[dev]'
alias pei='pipenv install'
alias va='pre-commit run --all-files'

alias pbuild='python setup.py sdist bdist_wheel --universal'
alias pupload='python setup.py upload'

function cvenv() {
    v=$1
    if [ -z "$v" ]; then
        v=.venv
    fi
    virtualenv "$v"
}

function svenv() {
    v=$1
    if [ -z "$v" ]; then
        v=.venv
    fi
    source $v/$v_path
}

function venv() {
    cvenv "$@" && svenv "$@"
}

alias cv='cvenv'
alias sv='svenv'
alias vv='venv'

#                   docker
# --------------------------------------------------
alias ds='docker start -ai'
alias dp='docker ps'
alias dr='docker run -it'
alias dre='docker run -it --env-file ${ENV_FILE}'


#                   yapf
# --------------------------------------------------
alias yi='yapf --recursive -i --style $YAPF_STYLE'


#
# other major alias
# --------------------------------------------------
source ~/dotfiles/sb/vault-utils/.alias-vault.bash
source ~/dotfiles/.alias-git.bash
