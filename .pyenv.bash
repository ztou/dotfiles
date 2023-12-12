export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

function vv() {
    venv_name="${1:-$(basename "$PWD")}"
    cmd="pyenv virtualenv $venv_name"
    echo running command: $cmd ...
    eval $cmd
}
function va() {
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    venv_name="${1:-$(basename "$PWD")}"
    cmd="pyenv activate $venv_name"
    echo running command: $cmd ...
    eval $cmd
}
alias vva='vv && va'
alias vd='pyenv deactivate'
alias vvl='pyenv virtualenvs'
alias vvd='pyenv virtualenv-delete -f'
alias mkenv=vv
alias workon=va
