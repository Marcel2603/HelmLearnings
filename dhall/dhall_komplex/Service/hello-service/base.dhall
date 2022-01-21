let infra = ./../../Infrastructure/kubernetes/package.dhall

let lib = ../../Infrastructure/lib/lib.dhall

let typesUnion = ../../Infrastructure/lib/types_union.dhall

let k8sTypesUnion = ./../../Infrastructure/lib/k8sTypesUnion.dhall

let Config =
      { image : Text
      , tag : Text
      , pullPolicy : Text
      , domain : Text
      , tester : Text
      , foo : Text
      , db_url : Text
      }

let envVars =
      λ(config : Config) →
        { env =
          [ infra.makeEnv { name = "tester", value = config.tester }
          , infra.makeEnv { name = "foo", value = "{{ now | unixEpoch }}" }
          , infra.makeEnv { name = "db_url", value = config.db_url }
          ]
        }

let createService =
      λ(config : Config) →
        infra.microservice::{
        , name = "hello-service"
        , appPort = +8080
        , image = config.image
        , tag = config.tag
        , replicas = +1
        , domain = Some config.domain
        , envVars = Some (envVars config).env
        }

let buildService =
      λ(config : Config) →
        let microservice = createService config

        let myDeployment = infra.deployment microservice

        let myService = infra.service microservice

        let myServiceAccount = infra.serviceAccount microservice

        let myIngress = infra.ingress microservice

        in  lib.list::{
            , items = Some
              [ typesUnion.k8s (k8sTypesUnion.Deployment myDeployment)
              , typesUnion.k8s (k8sTypesUnion.Service myService)
              , typesUnion.k8s (k8sTypesUnion.ServiceAccount myServiceAccount)
              , typesUnion.k8s (k8sTypesUnion.Ingress myIngress)
              ]
            }

in  buildService
