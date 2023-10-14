#!/bin/bash

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]:-$0:A}")" >/dev/null && pwd)"

#                   Windows specific
# --------------------------------------------------
v_activate='Scripts/activate'
v_ending='\r\n'

if [ "$(uname)" = "Darwin" ] || [ "$(uname)" = "Linux" ]; then
    v_activate='bin/activate'
    v_ending='\n'
fi

#export $(cat .env | xargs)
function ex() {
    cat ~/.env && export $(grep -v '^#' ~/.env | tr $v_ending ' ')
}

function uex() {
    cat ~/.env && unset $(grep -v '^#' ~/.env | sed -E 's/(.*)=.*/\1/' | tr $v_ending ' ')
}

#                   general
# --------------------------------------------------
alias reload='source ~/.zshrc'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias so='scoop'
alias ecode='export GIT_EDITOR="code -w"'
alias ce='code ~/.env'

#                   python
# --------------------------------------------------
alias penv='source ".venv/$v_activate"'
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
