let infra = ./../../../dhall/dhall_komplex/Infrastructure/kubernetes/package.dhall

let lib = ../../../dhall/dhall_komplex/Infrastructure/lib/lib.dhall

let typesUnion = ../../../dhall/dhall_komplex/Infrastructure/lib/types_union.dhall

let k8sTypesUnion = ./../../../dhall/dhall_komplex/Infrastructure/lib/k8sTypesUnion.dhall

let Config =
      { image : Text
      , tag : Text
      , pullPolicy : Text
      , domain : Text
      }

let envVars =
      λ(config : Config) →
        { env =
          [ infra.makeEnv
              { name = "LOCALSTACK_URL"
              , value = "http://localstack.default.svc:4566"
              }
          , infra.makeEnv { name = "S3_BUCKET", value = "bucket" }
          , infra.makeEnv { name = "SPRING_PROFILES_ACTIVE", value = "compose" }
          ]
        }

let createService =
      λ(config : Config) →
        infra.microservice::{
        , name = "reactive-server"
        , appPort = +9000
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
