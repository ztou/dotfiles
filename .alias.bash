#!/bin/bash

#                   Windows specific
# --------------------------------------------------
v_path='/Scripts/activate'
alias open='explorer'
alias cc='cmd //c'

if [ "$(uname)" = "Darwin" ] || [ "$(uname)" = "Linux" ]; then
    v_path='/bin/activate'
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

alias cvenv='virtualenv venv'
alias svenv='source venv/$v_path'
alias pir='pip install -r requirements.txt'
alias va='pre-commit run --all-files'


#                   docker
# --------------------------------------------------
alias ds='docker start -ai'
alias dp='docker ps'
alias dr='docker run -it'
alias dre='docker run -it --env-file ${ENV_FILE}'


#                   vault
# --------------------------------------------------
alias vl='vault login -method=ldap username=huangjoh'
alias vw-dev='vault write -format=json account/849563745824/sts/Resource-Admin -ttl=12h'
#alias vw-wsa='vault write cosv2-c-uw2/iwwsa-c-uw2/aws/sts/app ttl=12h'
tm_py='c:/dropbox/code/python/token-make/tm.py'
alias vw-wsa='python ${tm_py} -app iwwsa-c-uw2'
alias vw-opt='python ${tm_py} -app iwopt-c-uw2-hv'
alias vw-mb='python ${tm_py} -app iwmb-c-uw2'
alias vw-st='python ${tm_py} -app iwcostst-c-uw2-p1'


#                   git
# --------------------------------------------------
alias gch='git config --global credential.helper '\''cache --timeout=36000'\'''
alias gcr='git clone --recursive'

alias ga='git add'
alias gau='git add -u'
alias gac='git add -u . && git commit'
alias gaca='git add -u . && git commit --amend'
alias gca='git commit --amend'
alias gcm='git commit -m'
alias gb='git branch'
alias gc='git commit'
alias gr='git remote'
alias gco='git checkout'
alias grh='git reset HEAD'

alias gd='git diff'
alias gds='git diff --submodule=diff'
alias gdt='git difftool --no-prompt --tool=am'
alias gdc='git diff --cached'
alias gdct='git difftool --cached --no-prompt --tool=am'
alias gst='git status'
alias gsps='git show --pretty=short --show-signature'

alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gfo='git fetch origin'
alias gfom='git fetch origin master:refs/remotes/origin/master'

alias gl='git pull'
alias glol="git log --graph -20 --pretty='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glola="git log --graph -20 --pretty='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"
alias glog='git log --oneline --decorate --graph -20'
alias gloga='git log --oneline --decorate --graph --all -20'

alias gsi='git submodule init'
alias gsu='git submodule update'
alias gss='git submodule status'
alias gsa='git submodule add'

alias gstl='git stash list'
alias gstd='git diff HEAD stash@{0}'
alias gsts='git show stash@{0}'

alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

alias gfs='git flow feature start'
alias gff='git flow feature finish'

alias gfm='git fetch origin master:master'
alias gcm='git fetch origin master:master && git checkout master'
alias gcom='git fetch origin master:refs/remotes/origin/master && git checkout origin/master'

alias grom='git rebase origin/master'
alias grm='git rebase master'

alias egvim='export GIT_EDITOR=gvim'
alias evim='export GIT_EDITOR=vim'

#                   hub
# --------------------------------------------------
alias gcb='git rev-parse --abbrev-ref HEAD'
alias gp='git push -u origin $(gcb)'
alias gpf='git push origin +$(gcb)'
alias hb='hub browse'
alias hp='hub pull-request'
alias hpr='gp && hp -o'
alias publish='gp && hp -o'
