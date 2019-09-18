#                   vault
# --------------------------------------------------
# json or table
export APP_DEFAULT=iwwsa
export USER_DEFAULT=huangjoh

export VAULT_FORMAT=json
export VAULT_ADDR=https://civ1.dv.adskengineer.net:8200

export APP_ENV=dev
export APP_SUFFIX=-c-uw2
export APP_MONIKER=$APP_DEFAULT$APP_SUFFIX
export COS_MONIKER=cosv2-c-uw2

alias vl='vault login -method=ldap username=$USER_DEFAULT'
alias vw-dev='vault write -format=json account/849563745824/sts/Resource-Admin -ttl=12h'

# Init vault environment
#
function ve() {
    APP_ENV=$1
    if [ -z "$APP_ENV" ]; then
        APP_ENV=dev
    fi
    case $APP_ENV in
        dev )
            VAULT_ADDR=https://civ1.dv.adskengineer.net:8200
            COS_MONIKER=cosv2-c-uw2
            APP_SUFFIX=-c-uw2;;
        stg )
            VAULT_ADDR=https://civ1.st.adskengineer.net:8200
            COS_MONIKER=cosv2-s-ue1-ds
            APP_SUFFIX=-s-ue1;;
        prod )
            VAULT_ADDR=https://civ1.pr.adskengineer.net:8200
            COS_MONIKER=cosv2-p-ue1-ds
            APP_SUFFIX=-p-ue1;;
        dns )
            VAULT_ADDR=https://civ1.st.adskengineer.net:8200
            COS_MONIKER=cosv2-s-ue1-dn
            APP_SUFFIX=-s-ue1-dn;;
        dn )
            VAULT_ADDR=https://civ1.pr.adskengineer.net:8200
            COS_MONIKER=cosv2-p-ue1-dn
            APP_SUFFIX=-p-ue1-dn;;
        *)
            echo "ERROR: Invalid environment, must be one of (dev|stg|prod|ds|dns)"
    esac
}

function update_app_moniker() {
    m=$1
    if [ -z "$1" ]; then
        m=$APP_DEFAULT
    fi

    # check if it contains '-', if so, it is a full moniker
    if [[ "$m" == *"-"* ]]; then
        APP_MONIKER=$m
    else
        APP_MONIKER=$m$APP_SUFFIX
    fi
}

# Read credentials from vault
#
# alias vr-wsa='vault read cosv2-c-uw2/iwwsa-c-uw2/generic/appSecrets'
function vr() {
    update_app_moniker "$1"

    TYPE=$2
    if [ -z "$TYPE" ]; then
        TYPE=app
    fi

    vault read $COS_MONIKER/$APP_MONIKER/generic/${TYPE}Secrets
}

function vr-app() {
    vr "$1" "app"
}

function vr-test() {
    vr "$1" "test"
}

# Write credentials to vault
#
# alias vw-wsa='vault write cosv2-c-uw2/iwwsa-c-uw2/generic/appSecrets @xx.json'
function vw() {
    SECRET_FILE=$2
    if [ ! -f "$SECRET_FILE" ]; then
        echo "ERROR: Invalid secret file: $SECRET_FILE"
    else
        TYPE=$3
        if [ -z "$TYPE" ]; then
            TYPE=app
        fi

        update_app_moniker "$1"
        vault write $COS_MONIKER/$APP_MONIKER/generic/${TYPE}Secrets @"$SECRET_FILE"
    fi
}

function vw-app() {
    vw "$1" "$2" "app"
}

function vw-test() {
    vw "$1" "$2" "test"
}

# Generate AWS token
#
# cmd='vault write cosv2-c-uw2/iwwsa-c-uw2/aws/sts/app ttl=12h'
#
function kk() {
    update_app_moniker "$@"

    if [ -z "$TM_PY" ]; then
        TM_PY=~/dotfiles/sb/vault-utils/tm.py
    fi
    python "$TM_PY" -app $APP_MONIKER
}
