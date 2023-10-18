export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

function pv() {
    venv_name="${1:-$(basename "$PWD")}"
    cmd="pyenv virtualenv $venv_name"
    echo running command: $cmd ...
    eval $cmd
}
function pa() {
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    venv_name="${1:-$(basename "$PWD")}"
    cmd="pyenv activate $venv_name"
    echo running command: $cmd ...
    eval $cmd
}
alias pva='pv && pa'
alias pd='pyenv deactivate'
alias pvl='pyenv virtualenvs'
alias pvd='pyenv virtualenv-delete'
alias mkenv=pv
alias workon=pa
