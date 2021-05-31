#!/bin/bash

# readlink - readlink symbol link location
#
DOTFILES="$( cd "$( dirname "$(readlink ${BASH_SOURCE[0]:-$0:A})" )" >/dev/null && pwd )"

# from - https://conemu.github.io/en/CygwinMsys.html#bash-history

# ignore duplicate
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=5000

# Allow "sharing" of history between instances
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
#PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

function source_bash() {
    bash_file=$1
    if [ -f $bash_file ]; then
        source $bash_file
    else
        echo "warning - not able to find file: $bash_file, ignore"
    fi
}

source_bash $DOTFILES/.alias.bash
source_bash $DOTFILES/sb/z/z.sh
source_bash $DOTFILES/sb/hub/etc/hub.bash_completion.sh

# disable hub alias since it causes 0.07 second delay on running bash command
#
#eval "$(hub alias -s bash)"


#                   git auto completion
# --------------------------------------------------
case "$(uname -s)" in
    Linux*)     source_bash /etc/bash_completion.d/git-completion.bash;;

    # Mac - brew install bash-completion
    # Darwin*)    source_bash /usr/local/etc/bash_completion;;

    # Windows - C:\Program Files\Git\mingw64\share\git\completion\git-completion.bash
    *)
esac

__git_complete ga _git_add
__git_complete gb _git_branch
__git_complete gco _git_checkout


#                   fzf
# --------------------------------------------------
# https://github.com/junegunn/fzf/issues/963
#
export TERM=cygwin
# export TERM=xterm-256color
# export TERM=xterm-color
# export TERM=xterm
# export TERM=

source_bash $DOTFILES/.fzfrc.bash
source_bash ~/.fzf.bash
source_bash $DOTFILES/fzf-git.bash


# ssh-agent
source_bash $DOTFILES/.ssh-agent.bash


# key binding
bind '"\er": redraw-current-line'
bind '"\C-g\C-f": "$(f_gf)\e\C-e\er"'
bind '"\C-g\C-b": "$(f_gb)\e\C-e\er"'
bind '"\C-g\C-t": "$(f_gt)\e\C-e\er"'
bind '"\C-g\C-h": "$(f_gh)\e\C-e\er"'
bind '"\C-g\C-r": "$(f_gr)\e\C-e\er"'

source "$HOME/.cargo/env"
