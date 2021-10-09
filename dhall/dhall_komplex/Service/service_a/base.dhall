let infra = ./../../Infrastructure/kubernetes/package.dhall

let lib = ../../Infrastructure/lib/lib.dhall

let typesUnion = ../../Infrastructure/lib/types_union.dhall

let buildService =
      λ(microservice : infra.microservice.Type) →
        let myDeployment = infra.deployment microservice

        let myService = infra.service microservice

        let myServiceAccount = infra.serviceAccount microservice

        in  lib.list::{
            , items = Some
              [ typesUnion.Deployment myDeployment
              , typesUnion.Service myService
              , typesUnion.ServiceAccount myServiceAccount
              ]
            }

in  buildService
