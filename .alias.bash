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
