#                   vault
# --------------------------------------------------
USER_DEFAULT=huangjoh
APP_DEFAULT=iwwsa
APP_SUFFIX=-c-uw2

# json or table
export VAULT_FORMAT=json
export VAULT_ADDR=https://civ1.dv.adskengineer.net:8200

export APP_MONIKER=$APP_DEFAULT$APP_SUFFIX
export COS_MONIKER=cosv2-c-uw2

alias vl='vault login -method=ldap username=$USER_DEFAULT'
alias vw-dev='vault write -format=json account/849563745824/sts/Resource-Admin -ttl=12h'

# Init vault environment
#
function ve() {

    # default env: dev
    env=${1:-dev}
    case $env in
        dev )
            VAULT_ADDR=https://civ1.dv.adskengineer.net:8200
            COS_MONIKER=cosv2-c-uw2
            APP_SUFFIX=-c-uw2
            ;;

        stg )
            VAULT_ADDR=https://civ1.st.adskengineer.net:8200

            if [[ "$2" == "dn" ]]; then
                COS_MONIKER=cosv2-s-ue1-dn
                APP_SUFFIX=-s-ue1-dn
            else
                COS_MONIKER=cosv2-s-ue1-ds
                APP_SUFFIX=-s-ue1
            fi
            ;;

        prod )
            VAULT_ADDR=https://civ1.pr.adskengineer.net:8200

            if [[ "$2" == "dn" ]]; then
                COS_MONIKER=cosv2-p-ue1-dn
                APP_SUFFIX=-p-ue1-dn
            else
                COS_MONIKER=cosv2-p-ue1-ds
                APP_SUFFIX=-p-ue1
            fi
            ;;

        show )
            show_vault_environment
            return
            ;;

        *)
            echo "ERROR: invalid input, must be one of (dev|stg|prod [dn] or show)"
            return
            ;;
    esac

    # update default app moniker
    APP_MONIKER=$APP_DEFAULT$APP_SUFFIX

    show_vault_environment
}

function show_vault_environment() {
    echo "-----------------------------------------------------------------------"
    echo "  Vault environment is setup ready:"
    echo ""
    echo "      VAULT_ADDR:                 $VAULT_ADDR"
    echo "      VAULT USER  (default):      $USER_DEFAULT"
    echo "      COS_MONIKER:                $COS_MONIKER"
    echo "      APP_MONIKER (default):      $APP_MONIKER"
}

function update_app_moniker() {
    m=${1:-$APP_DEFAULT}

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

    TYPE=${2:-app}
    (set -x; vault read $COS_MONIKER/$APP_MONIKER/generic/${TYPE}Secrets)
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
        (set -x; vault write $COS_MONIKER/$APP_MONIKER/generic/${TYPE}Secrets @"$SECRET_FILE")
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
function tk() {
    update_app_moniker "$@"

    if [ -z "$TK_PY" ]; then
        TK_PY=~/dotfiles/sb/vault-utils/tk.py
    fi
    python "$TK_PY" -cos $COS_MONIKER -app $APP_MONIKER
}

function vk() {
    update_app_moniker "$@"
    (set -x; vault write $COS_MONIKER/$APP_MONIKER/aws/sts/app ttl=12h)
}
