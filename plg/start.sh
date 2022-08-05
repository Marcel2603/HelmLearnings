#!/bin/bash
function create_cluster() {
  if [[ $(kind get clusters) ]]; then echo "Stop kind" && exit 1; fi
  kind create cluster 
}



function install_loki() {
    helm repo add grafana https://grafana.github.io/helm-charts
    helm repo update
    helm upgrade --install loki --namespace=monitor --create-namespace grafana/loki-distributed
    helm upgrade -i loki-grafana -n monitor grafana/grafana
    kubectl get secret --namespace monitor loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
    kubectl port-forward --namespace monitor service/loki-grafana 3000:80

}

"$@"
