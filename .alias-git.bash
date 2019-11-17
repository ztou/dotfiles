#                   git
# --------------------------------------------------

# remove git submodule
#
function rmsb() {

    sb=$1
    if [ -z "$sb" ]; then
        echo "error: please input the submodule path"
    else
        #  remove the whole submodule.$name section from .git/config together with their work tree
        git submodule deinit -f "$sb"

        # remove the submodule directory working tree and index and .gitmodules file
        git rm "$sb"

        # remove the submodule directory located at path/to/submodule
        rm -rf ".git/modules/$sb"
    fi
}

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
alias grr='git reset origin/$(gcb)'

alias gd='git diff'
alias gds='git diff --submodule=diff'
alias gdt='git difftool --submodule=diff --no-prompt --tool=am'
alias gdc='git diff --submodule=diff --cached'
alias gdct='git difftool --submodule=diff --cached --no-prompt --tool=am'
alias gst='git status'
alias gsps='git show --pretty=short --show-signature'

alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gfo='git fetch origin'
alias gfom='git fetch origin master:refs/remotes/origin/master'

alias gl="git log --graph -100 --pretty='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ci) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gla="gl --all"
alias glog='git log --oneline --decorate --graph -50'
alias gloga='glog --all'

alias gsb='git submodule'
alias gsi='git submodule init'
alias gsu='git submodule update'
alias gsur='git submodule update --recursive'
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
