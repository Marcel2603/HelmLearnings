let infra = ./../../Infrastructure/kubernetes/package.dhall

let lib = ../../Infrastructure/lib/lib.dhall

let typesUnion = ../../Infrastructure/lib/types_union.dhall

let Config =
      { image : Text
      , tag : Text
      , pullPolicy : Text
      , aws_access : Text
      , aws_secret : Text
      , aws_bucket : Text
      , db_url : Text
      , db_user : Text
      , db_pw : Text
      }

let envVars =
      λ(config : Config) →
        { env =
          [ infra.makeEnv
              { name = "AWS_ACCESS_KEY_ID", value = config.aws_access }
          , infra.makeEnv
              { name = "AWS_SECRET_ACCESS_KEY", value = config.aws_secret }
          , infra.makeEnv
              { name = "AWS_DEFAULT_REGION", value = "eu-central-1" }
          , infra.makeEnv { name = "S3_BUCKET", value = config.aws_bucket }
          , infra.makeEnv { name = "PGHOST", value = config.db_url }
          , infra.makeEnv { name = "PGUSER", value = config.db_user }
          , infra.makeEnv { name = "PGPASSWORD", value = config.db_pw }
          , infra.makeEnv { name = "PAGER", value = "pspg -s 5" }
          ]
        }

let createService =
      λ(config : Config) →
        infra.microservice::{
        , name = "devops-service"
        , appPort = +80
        , image = config.image
        , tag = config.tag
        , replicas = +1
        , envVars = Some (envVars config).env
        }

let buildService =
      λ(config : Config) →
        let microservice = createService config

        let myDeployment = infra.deployment microservice

        in  lib.list::{ items = Some [ typesUnion.Deployment myDeployment ] }

in  buildService
