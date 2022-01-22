#!/bin/bash

REACTIVE_S3_FOLDER="../../../../Java/Reactive-S3"

function create_cluster() {
  if [[ $(kind get clusters) ]]; then echo "Stop kind" && exit 1; fi
  kind create cluster --config config/kind_config.yaml
}

function deploy_ingress_controller() {
  kubectl apply -f "config/ingress.yaml" && sleep 10
  kubectl wait --namespace ingress-nginx \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/component=controller \
    --timeout=90s
}

function start() {
  create_cluster
  deploy_ingress_controller
  create_monitoring
  create_localstack
}

function create_monitoring() {
  bash "deploy.sh" install-prometheus
  bash "deploy.sh" install-grafana
}

function create_localstack() {
    helm upgrade -i "localstack" ../../VolumeMounts/localstack
}

function deploy_services() {
  mvn clean package -f $REACTIVE_S3_FOLDER/ReactiveFileServer -DskipTests
  docker build $REACTIVE_S3_FOLDER/ReactiveFileServer -t reactive-server:1.0
  kind load docker-image reactive-server:1.0
  dhall-to-yaml-ng --file ../helm/reactive-file-server/local.dhall --output ../helm/reactive-file-server/templates/service.yml
  helm upgrade -i "reactive-server" ../helm/reactive-file-server

  mvn clean package -f $REACTIVE_S3_FOLDER/ReactiveClient -DskipTests
  docker build $REACTIVE_S3_FOLDER/ReactiveClient -t reactive-client:1.0
  kind load docker-image reactive-client:1.0
  dhall-to-yaml-ng --file ../helm/reactive-client/local.dhall --output ../helm/reactive-client/templates/service.yml
  helm upgrade -i "reactive-client" ../helm/reactive-client
}

if [[ "$PWD" != *"/scripts" ]]; then echo -e "You are not in /scripts. Pls navigate to it.\nCurrently you are in $PWD" ; exit 1; fi

"$@"
