let kubernetes = ./../lib/k8s.dhall

let MicroService = ./microservice.dhall

let selector = ./selector.dhall

let helmUtils = ./../lib/helm_utils.dhall

let podSpec
    : MicroService.Type → kubernetes.PodSpec.Type
    = λ(MicroService : MicroService.Type) →
        let rootContainer =
              [ kubernetes.Container::{
                , name = "${MicroService.name}-container"
                , env = MicroService.envVars
                , image = Some "${MicroService.image}:${MicroService.tag}"
                , imagePullPolicy = Some MicroService.pullPolicy
                , ports = Some
                  [ kubernetes.ContainerPort::{
                    , name = Some "http"
                    , containerPort = MicroService.appPort
                    }
                  ]
                }
              ]

        in  kubernetes.PodSpec::{
            , containers = rootContainer
            , imagePullSecrets = Some
              [ kubernetes.LocalObjectReference::{ name = Some "regcred" } ]
            }

let spec =
      λ(MicroService : MicroService.Type) →
        kubernetes.DeploymentSpec::{
        , selector = selector MicroService.name
        , replicas = Some MicroService.replicas
        , template = kubernetes.PodTemplateSpec::{
          , metadata = Some kubernetes.ObjectMeta::{
            , name = Some MicroService.name
            , labels = Some (toMap { app = MicroService.name })
            }
          , spec = Some (podSpec MicroService)
          }
        }

let deployment =
      λ(MicroService : MicroService.Type) →
        kubernetes.Deployment::{
        , metadata = kubernetes.ObjectMeta::{
          , name = Some MicroService.name
          , namespace = Some helmUtils.Release.namespace
          , labels = Some (toMap { app = MicroService.name })
          }
        , spec = Some (spec MicroService)
        }

in  deployment
