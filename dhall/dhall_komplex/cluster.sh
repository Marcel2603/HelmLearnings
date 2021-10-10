#!/bin/bash

start_cluster(){
    if [[ -z $(kind --version) ]];then install_kind; fi
    kind create cluster
}

delete_cluster() {
    kind delete cluster
}

upload_docker_image(){
    kind load docker-image $1
}

build_container_and_upload() {
    name=$1
    dir=$2
    tag=$3
    image="$name:$tag"
    run_maven=$4
    [[ $4 == true ]] && mvn clean package -DskipTests -f $dir
    docker build $dir -t $image
    upload_docker_image $image
}

install_kind() {
    echo "Kind is not installed. Should i install it? (y/n)"
    read n
    if [[ $n != "y" ]];then echo "Pls install kind manually, or insert y" && exit 1; fi
    curl -Lo installation.sh https://raw.githubusercontent.com/Marcel2603/UsefullScripts/master/installation.sh
    chmod +x installation.sh
    ./installation.sh install_kind
    export PATH="$HOME/.local/bin:$PATH"
    rm installation.sh
}

check_kind() {
    if [[ -z $(kind --version) ]];then install_kind; fi
    if [[ -z $(kubectl cluster-info --context kind-kind) ]];then ./cluster.sh start_cluster; fi
}


upload_services() {
    check_kind
    version=${1:-1.0.0}
    build_container_and_upload "hello-service" $HELLO_SERVICE $version true
    build_container_and_upload "second-service" $SECOND_SERVICE $version true
    build_container_and_upload "devops-service" $DEVOPS_SERVICE $version false

}

HELLO_SERVICE="../services/hello-service"
SECOND_SERVICE="../services/second-service"
DEVOPS_SERVICE="../services/devops-service"
"$@"
