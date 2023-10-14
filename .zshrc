#!/bin/zsh

# readlink - readlink symbol link location
#
DOTFILES="$(cd "$(dirname "$(readlink ${BASH_SOURCE[0]:-$0:A})")" >/dev/null && pwd)"

export TERM=xterm-256color
export LANG=en_US.UTF-8

source $DOTFILES/.alias.bash
alias reload='source ~/.zshrc'

# source z.sh before fzfrc.bash
source $DOTFILES/sb/z/z.sh

if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
    source $DOTFILES/.fzfrc.bash
    source $DOTFILES/fzf-git.bash
fi

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh

# ctrl-left, right
bindkey "\e[1;5D" backward-word
bindkey "\e[1;5C" forward-word

# home, end
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# up, down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

eval "$(starship init zsh)"
