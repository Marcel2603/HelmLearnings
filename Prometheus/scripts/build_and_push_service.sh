#!/usr/bin/env bash

set -e 
if [[ "$PWD" != *"/scripts" ]]; then echo -e "You are not in /scripts. Pls navigate to it.\nCurrently you are in $PWD" ; exit 1; fi


mvn clean package -DskipTests -f ../second-service

# Set docker env
eval "$(minikube docker-env)"             # unix shells

# Build image
docker build -t second-service:0.0.1 ../second-service
