let infra = ./../../Infrastructure/kubernetes/package.dhall

let lib = ../../Infrastructure/lib/lib.dhall

let typesUnion = ../../Infrastructure/lib/types_union.dhall

let Config =
      { image : Text, tag : Text, pullPolicy: Text, tester : Text, foo : Text, db_url : Text }

let envVars =
      λ(config : Config) →
        { env =
          [ infra.makeEnv { name = "tester", value = config.tester }
          , infra.makeEnv { name = "foo", value = config.foo }
          , infra.makeEnv { name = "db_url", value = config.db_url }
          ]
        }

let createService =
      λ(config : Config) →
        infra.microservice::{
        , name = "second-service"
        , appPort = +8080
        , image = config.image
        , tag = config.tag
        , replicas = +1
        , envVars = Some (envVars config).env
        }

let buildService =
      λ(config : Config) →
        let microservice = createService config

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
