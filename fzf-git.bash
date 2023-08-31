# GIT heart FZF
# -------------

is_in_git_repo() {
  git rev-parse HEAD >/dev/null 2>&1
}

fzf-down() {
  fzf --no-height "$@" --border
}

f_gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
    fzf-down -m --ansi --nth 2..,.. \
      --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
    cut -c4- | sed 's/.* -> //'
}

f_gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
    fzf-down --ansi --multi --tac --preview-window right:70% \
      --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
    sed 's/^..//' | cut -d' ' -f1 |
    sed 's#^remotes/##'
}

f_gt() {
  is_in_git_repo || return
  git tag --sort -version:refname | /
  fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {} | head -'$LINES
}

f_gh() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always --no-merges |
    fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
      --header 'Press CTRL-S to toggle sort' \
      --preview 'echo {} | grep -o "[a-f0-9]\{7,\}" | xargs git show --color=always | head -'$LINES | grep -o "[a-f0-9]\{7,\}"
}
#--preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES | grep -o "[a-f0-9]\{7,\}"

f_gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
    fzf-down --tac \
      --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
    cut -d$'\t' -f1
}

#
# fco - checkout git branch/tag
#
unalias fco 2>/dev/null
fco() {

  is_in_git_repo || return

  if [ "$1" ]; then
    git checkout $1
    return
  fi

  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" |
      sed '/^$/d'
  ) || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}'
  ) || return
  target=$(
    (
      echo "$branches"
      echo "$tags"
    ) |
      fzf --no-hscroll --no-multi -n 2 \
        --ansi
  ) || return

  # sample: branch  origin/master
  branch=$(awk '{print $2}' <<<"$target")

  #strip the git remote: origin/
  git checkout ${branch//origin\//}

}

#
# gco - checkout local git branch
#
unalias gco 2>/dev/null
gco() {
  is_in_git_repo || return

  if [ "$1" ]; then
    git checkout $*
    return
  fi

  local tags branches target
  branches=$(
    git --no-pager branch \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" |
      sed '/^$/d'
  ) || return
  target=$(
    echo "$branches" | fzf --no-hscroll --no-multi -n 2 --ansi
  ) || return

  # sample: branch  master
  branch=$(awk '{print $2}' <<<"$target")

  #strip the git remote: origin/
  git checkout ${branch}

}
