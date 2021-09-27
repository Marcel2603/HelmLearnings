let deployment = ./deployment.dhall

let list = ../lib/k8s/types/list.dhall

let MicroService = ./microservice.dhall

let service = ./service.dhall

let typesUnion = ../lib/k8s/types_union.dhall

let buildService =
        λ(microservice : MicroService.Type)
      → let myDeployment = deployment microservice
        let myService = service microservice

        in  list::{
            , items =
              [, typesUnion.Deployment myDeployment
              , typesUnion.Service myService
              ]
            }

in  buildService 
