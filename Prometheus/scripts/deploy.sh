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
    SERVICE="$1"
    cd "$HELM_DIR"
    cd "$SERVICE"
    pull_and_untar_deps
    helm upgrade -i "$SERVICE" .
}

if [[ "$PWD" != *"/scripts" ]]; then echo -e "You are not in /scripts. Pls navigate to it.\nCurrently you are in $PWD" ; exit 1; fi

case "$1" in
"install-prometheus")
    deploy_service "prometheus"
    ;;
"install-grafana")
    deploy_service "grafana"
    ;;
"install-second-service")
    bash "build_and_push_service.sh"
    deploy_service "second-service"
    ;;
"port-forward-prometheus")
    POD_NAME=$(kubectl get pods --namespace default -l "app=prometheus,component=server" -o jsonpath="{.items[0].metadata.name}")
    kubectl --namespace default port-forward "$POD_NAME" 9090
    ;;
"port-forward-grafana")
    POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=grafana" -o jsonpath="{.items[0].metadata.name}")
    kubectl --namespace default port-forward "$POD_NAME" 3000
    ;;
*)
    echo "Pls give an parameter"
esac