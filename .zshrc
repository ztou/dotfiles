#!/bin/zsh

export TERM=xterm-256color
export LANG=en_US.UTF-8

source ~/.alias.bash

# source z.sh before fzfrc.bash
source ~/dotfiles/sb/z/z.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source ~/.fzfrc.bash
source ~/dotfiles/fzf-git.bash

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh

# ctrl-left, right
bindkey "\e[1;5D" backward-word
bindkey "\e[1;5C" forward-word

# up, down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# start ssh-agent
# source ~/dotfiles/.ssh-agent.bash

# eval "$(hub alias -s)"
eval "$(pyenv init -)"
eval "$(starship init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

