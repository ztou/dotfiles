#!/bin/zsh

export TERM=xterm-256color
export LANG=en_US.UTF-8

source ~/.alias.bash

# put z.sh before fzfrc.bash
source ~/dotfiles/sb/z/z.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source ~/.fzfrc.bash
source ~/dotfiles/fzf-git.bash

# start ssh-agent
# source ~/dotfiles/.ssh-agent.bash

# eval "$(hub alias -s)"
eval "$(pyenv init -)"
eval "$(starship init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
