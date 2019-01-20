#DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
DOTFILES=~/dotfiles

# ignore duplicate
export HISTCONTROL=ignoreboth:erasedups

function source_bash() {
    bash_file=$1
    if [ -f $bash_file ]; then
        source $bash_file
        #echo "source $bash_file successfully"
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
source_bash $DOTFILES/.fzfrc.bash
[ -f ~/.fzf.bash ] && source ~/.fzf.bash