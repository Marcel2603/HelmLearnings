let deployment = ./deployment.dhall

let lib = ../../lib/lib.dhall

let MicroService = ./microservice.dhall

let service = ./service.dhall

let typesUnion = ../../lib/types_union.dhall

let buildService =
      λ(microservice : MicroService.Type) →
        let myDeployment = deployment microservice

        let myService = service microservice

        in  lib.list::{
            , items = Some
              [ typesUnion.Deployment myDeployment
              , typesUnion.Service myService
              ]
            }

in  buildService
