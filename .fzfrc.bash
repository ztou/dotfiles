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

# print recent dir
unalias j 2> /dev/null
j() {
  # [ $# -gt 0  ] && _z -e "$*" && return
  [ "$1" ] && _z -e "$*" && return
  _z -l 2>&1 | fzf --no-height --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//'
}

# cd recent dir
unalias z 2> /dev/null
z() {
  dir=$(j "$*")
  [ "$dir" ] && cd "$dir"
}

# code recent dir
unalias fe 2> /dev/null
e() {
  dir=$(j "$*")
  [ "$dir" ] && echo "opening $dir with code..." && code "$dir"
}

# https://github.com/junegunn/fzf/wiki/Examples

# fcd - cd to selected directory
fcd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() (
  IFS=$'\n' out=("$(fzf --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-code} "$file"
  fi
)

# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
fkill() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi
}

# fco - checkout git branch/tag
fco() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi) || return

  # sample: branch  origin/master
  branch=$(awk '{print $2}' <<<"$target" )

  #strip the git remote: origin/
  git checkout ${branch//origin\//}
}

# fco_preview - checkout git branch/tag, with a preview showing the commits between the tag/branch and HEAD
fco_preview() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'") || return

  # sample: branch  origin/master
  branch=$(awk '{print $2}' <<<"$target" )

  #strip the git remote: origin/
  git checkout ${branch//origin\//}
}
