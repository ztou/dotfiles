# ignore duplicate
export HISTCONTROL=ignoreboth:erasedups
DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"/dotfiles

function source_bash() {
    bash_file=$1
    if [ -f $bash_file ]; then
        source $bash_file
        echo "source $bash_file successfully"
    else
        echo "not able to find bash file: $bash_file, ignoring  ..."
    fi
}

source_bash $DOTFILES/.alias.bash
source_bash $DOTFILES/.priv.bash
source_bash $DOTFILES/sb/z/z.sh
source_bash $DOTFILES/sb/hub/etc/hub.bash_completion.sh

#                   git auto completion
# --------------------------------------------------
# C:\Program Files\Git\mingw64\share\git\completion\git-completion.bash
__git_complete ga _git_add
__git_complete gb _git_branch
__git_complete gco _git_checkout


#                   fzf
# --------------------------------------------------
#
# Windows doesn't support height
if !( [ "`uname`" == "Darwin" ] && [ "`uname`" == "Linux" ] ); then
    export FZF_DEFAULT_OPTS='--no-height'
fi

# From https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings
#
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS='--bind "F3:toggle-preview" --preview "cat {} | head -100" --color dark,hl:33,hl+:37,fg+:235,bg+:136,fg+:254 --color info:254,prompt:37,spinner:108,pointer:235,marker:235'

# show long commands if needed
export FZF_CTRL_R_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_R_OPTS='--preview "echo {}" --preview-window down:3:hidden:wrap'

export FZF_ALT_C_COMMAND='fd --type d'
export FZF_ALT_C_OPTS='--bind "F3:toggle-preview" --preview "tree -L 2 -C {} | head -200"'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

unalias z 2> /dev/null
z() {
  [ $# -gt 0  ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf --no-height --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}

