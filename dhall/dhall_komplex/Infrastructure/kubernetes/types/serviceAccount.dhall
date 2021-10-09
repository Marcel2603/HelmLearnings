let k8s = ../../lib/k8s.dhall

let Microservice = ./microservice.dhall

let helmUtils = ./../../lib/helm_utils.dhall

let serviceAccount
    : Microservice.Type → k8s.ServiceAccount.Type
    = λ(service : Microservice.Type) →
        k8s.ServiceAccount::{
        , metadata = k8s.ObjectMeta::{
          , name = Some "${helmUtils.Release.name}-${service.name}"
          }
        }

in  serviceAccount
