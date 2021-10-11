let lib = ./../Infrastructure/lib/lib.dhall

let k8s = ./../Infrastructure/lib/k8s.dhall

let typesUnion = ./../Infrastructure/lib/types_union.dhall

let Config = { name : Text, secretId : Text, versionId : Text }

let createSecrets =
      \(config : Config) ->
        lib.awsSecret::{
        , metadata = k8s.ObjectMeta::{ name = Some config.name }
        , spec = Some lib.awsSecretSpec::{
          , stringDataFrom = lib.secretsManagerSecret::{
            , secretId = config.secretId
            , versionId = config.versionId
            }
          }
        }

let FirstSecret =
      { name = "FirstSecret"
      , secretId = "first-secret"
      , versionId = "some uuid"
      }

let SecondSecret =
      { name = "SecondSecret"
      , secretId = "second-secret"
      , versionId = "some uuid 2"
      }

let secrets =
      let firstSecret = createSecrets FirstSecret

      let secondSecret = createSecrets SecondSecret

      in  lib.list::{
          , items = Some
            [ typesUnion.AwsSecret firstSecret
            , typesUnion.AwsSecret secondSecret
            ]
          }

in  secrets
