#!/bin/bash
set -e

HELM_DIR="../helm"

function deploy_service {
    # $1 ServiceName, $2 NameSpace
    SERVICE="$1"
    NAMESAPCE="${2:-default}"
    cd "$HELM_DIR"
    cd "$SERVICE"
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