#!/bin/bash

IGNORE_TAG="empty"
NAMESPACE="default"

print_help() {
    echo "Add description of the script functions here."
    echo
    echo "Syntax: deployment [-1|-2|-s|h]"
    echo "options:"
    echo "a     ImageTag for Hello Service"
    echo "b     ImageTag for Second Service"
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
    helm upgrade -i "test-release-${service}" $dir
}

while getopts ":a:b:s:h" option; do
    case "${option}" in
        s)
            stage=${OPTARG}
            ;;
        a)
            hello_service_tag=${OPTARG}
            ;;
        b)
            second_service_tag=${OPTARG}
            ;;
        h)
            print_help
            exit 0
            ;;
        *)
            print_help
            exit 0
            ;;
    esac
done


[[ -z "$stage" ]] && echo "Stage is empty using local" && stage=local
[[ ! -z "$hello_service_tag" ]] && deploy_service "hello-service" $stage "$hello_service_tag"
[[ ! -z "$second_service_tag" ]] && deploy_service "second-service" $stage "$second_service_tag"

