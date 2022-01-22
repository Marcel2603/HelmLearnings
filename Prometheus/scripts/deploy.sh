#!/bin/bash
set -e

HELM_DIR="../helm"

function pull_and_untar_deps {
    rm -rf charts 
    helm dep update --skip-refresh 
    if [[ -d charts ]]; then
        cd charts
        for filename in *.tgz; 
        do 
            tar -xf "$filename" 
            rm -f "$filename"
        done
        cd ..
    fi
}

function deploy_service {
    # $1 ServiceName, $2 NameSpace
    SERVICE="$1"
    NAMESAPCE="${2:-default}"
    cd "$HELM_DIR"
    cd "$SERVICE"
    pull_and_untar_deps
    helm upgrade -i "$SERVICE" --create-namespace -n $NAMESAPCE .
}

if [[ "$PWD" != *"/scripts" ]]; then echo -e "You are not in /scripts. Pls navigate to it.\nCurrently you are in $PWD" ; exit 1; fi

case "$1" in
"install-prometheus")
    deploy_service "prometheus" "monitoring"
    ;;
"install-grafana")
    deploy_service "grafana" "monitoring"
    ;;
*)
    echo "Pls give an parameter"
esac