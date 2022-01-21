#!/bin/bash

function create_cluster() {
  if [[ $(kind get clusters) ]]; then echo "Stop kind" && exit 1; fi
  kind create cluster --config config/kind_config.yaml
}

function deploy_ingress_controller() {
  kubectl apply -f "config/ingress.yaml" && sleep 5
  kubectl wait --namespace ingress-nginx \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/component=controller \
    --timeout=90s
}

function start() {
  create_cluster
  deploy_ingress_controller
  create_monitoring
}

function create_monitoring() {
  bash "deploy.sh" install-prometheus
  bash "deploy.sh" install-grafana
}

function deploy_services() {
  bash "deploy.sh" install-second-service

}

"$@"
