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
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'

# From https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings
#
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS='--bind "F3:toggle-preview" --preview "bat --style=numbers --color=always {} | head -500" --color dark,hl:33,hl+:37,fg+:235,bg+:136,fg+:254 --color info:254,prompt:37,spinner:108,pointer:235,marker:235'

# show long commands if needed
# export FZF_CTRL_R_COMMAND="$FZF_DEFAULT_COMMAND"
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
#
unalias z 2> /dev/null
z() {
  dir=$(j "$*")
  [ "$dir" ] && cd "$dir"
}

# open recent dir with code
#
zo() {
  dir=$(j "$*")
  [ "$dir" ] && echo "opening $dir with code..." && code "$dir"
}


# open dir with code
#
o() {
  dir=$(fd --type d "$*" | fzf --preview "tree -L 2 -C {} | head -200")
  [ "$dir" ] && echo "opening $dir with code..." && code "$dir"
}

# edit file with code (ctrl-o) or vim
#
e() {
  IFS=$'\n'
  out=$(fzf --query="$1" --exit-0 --expect=ctrl-o --preview "bat --style=numbers --color=always {} | head -500")
  echo $out
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)

  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && code "$file" || vim "$file"
  fi
}

# fuzzy grep via ag, open with code (ctrl-o) or vim
#
f() {
  out=`ag --nocolor "$1" | fzf --exit-0 --expect=ctrl-o`
  key=$(head -1 <<< "$out")

  line=$(head -2 <<< "$out" | tail -1)
  file=$(cut -d':' -f1 <<< "$line")
  number=$(cut -d':' -f2 <<< "$line")

  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && code --goto "$file":$number || vim "$file" +$number
  fi
}

alias v='vim -o `fzf`'

fag(){
  local line
  line=`ag --nocolor "$1" | fzf` \
    && vim $(cut -d':' -f1 <<< "$line") +$(cut -d':' -f2 <<< "$line")
}

# cd into dir repeatedly 
#
cd() {
    if [[ "$#" != 0 ]]; then
        builtin cd "$@";
        return
    fi
    while true; do
        local lsd=$(echo ".." && ls -p | grep '/$' | sed 's;/$;;')
        local dir="$(printf '%s\n' "${lsd[@]}" |
            fzf --reverse --preview '
                __cd_nxt="$(echo {})";
                __cd_path="$(echo $(pwd)/${__cd_nxt} | sed "s;//;/;")";
                echo $__cd_path;
                echo;
                ls -p --color=always "${__cd_path}";
        ')"
        [[ ${#dir} != 0 ]] || return 0
        builtin cd "$dir" &> /dev/null
    done
}

# fco - checkout git branch/tag
#
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
