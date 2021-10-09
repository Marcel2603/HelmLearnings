let k8s = ../../lib/k8s.dhall

let Microservice = ./microservice.dhall

let serviceAccount
    : Microservice.Type → k8s.ServiceAccount.Type
    = λ(service : Microservice.Type) →
        k8s.ServiceAccount::{
        , metadata = k8s.ObjectMeta::{
          , name = Some "RELEASE-NAME-${service.name}"
          }
        }

in  serviceAccount
