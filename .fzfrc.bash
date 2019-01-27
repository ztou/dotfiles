#!/bin/bash

#                   fzf
# --------------------------------------------------
#
# Windows doesn't support height
if ! { [ "`uname`" = "Darwin" ] && [ "`uname`" = "Linux" ]; }; then
    export FZF_DEFAULT_OPTS='--no-height'
fi

# remember to intall fd and add to path
# https://github.com/sharkdp/fd
#
export FZF_DEFAULT_COMMAND='fd --type f'

# From https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings
#
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS='--bind "F3:toggle-preview" --preview "cat {} | head -100" --color dark,hl:33,hl+:37,fg+:235,bg+:136,fg+:254 --color info:254,prompt:37,spinner:108,pointer:235,marker:235'

# show long commands if needed
export FZF_CTRL_R_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_R_OPTS='--preview "echo {}" --preview-window down:3:hidden:wrap'


# download tree from http://downloads.sourceforge.net/gnuwin32/tree-1.5.2.2-bin.zip
export FZF_ALT_C_COMMAND='fd --type d'
export FZF_ALT_C_OPTS='--bind "F3:toggle-preview" --preview "tree -L 2 -C {} | head -200"'

unalias gg 2> /dev/null
gg() {
  [ $# -gt 0  ] && _z "$*" && return
  echo "$(_z -l 2>&1 | fzf --no-height --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}

unalias z 2> /dev/null
z() {
  [ $# -gt 0  ] && _z "$*" && return
  cd $(gg)
}
