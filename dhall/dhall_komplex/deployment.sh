#!/bin/bash

IGNORE_TAG="empty"
NAMESPACE="default"

print_help() {
    echo "Add description of the script functions here."
    echo
    echo "Syntax: deployment [-1|-2|-s|h]"
    echo "options:"
    echo "a     ImageTag for Service A"
    echo "b     ImageTag for Service B"
    echo "s     Stage to deploy"
    echo "h     Print this Help."
    echo
}

deploy_service() {
    service=${1}
    dir=Service/${service}
    stage=$2
    tag=$3
    TAG=$tag dhall-to-yaml-ng --file "${dir}/${stage}.dhall" --output "${dir}/templates/service.yml"
    helm upgrade -i "${service}" --dry-run $dir
}

while getopts ":a:b:s:h" option; do
    case "${option}" in
        s)
            stage=${OPTARG}
            ;;
        a)
            service_a_tag=${OPTARG}
            ;;
        b)
            service_b_tag=${OPTARG}
            ;;
        h)
            print_help
            ;;
        *)
            ;;
    esac
done


[[ -z "$stage" ]] && echo "Stage is empty using local" && stage=local
echo "${stage}, ${service_a_tag}, ${service_b_tag}"
[[ ! -z "$service_a_tag" ]] && deploy_service "servicea" $stage "$service_a_tag"
[[ ! -z "$service_b_tag" ]] && deploy_service "serviceb" $stage "$service_b_tag"

