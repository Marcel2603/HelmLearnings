let Prelude = ../lib/k8s/prelude.dhall

let kubernetes = ../lib/k8s/k8s.dhall

let MicroService = ./microservice.dhall

let selector = ./selector.dhall

let podSpec
    : MicroService.Type → kubernetes.PodSpec.Type
    = λ(MicroService : MicroService.Type) →
        let rootContainer =
              [ kubernetes.Container::{
                , name = "web"
                , env = Some MicroService.envVars
                , image = Some MicroService.image
                , imagePullPolicy = Some "Always"
                , ports = Some
                  [ kubernetes.ContainerPort::{
                    , containerPort = MicroService.appPort
                    }
                  ]
                }
              ]

        let other = MicroService.otherContainers

        let combined = rootContainer # other

        in  kubernetes.PodSpec::{
            , containers = combined
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
            }
          , spec = Some (podSpec MicroService)
          }
        }

let deployment =
      λ(MicroService : MicroService.Type) →
        kubernetes.Deployment::{
        , metadata = kubernetes.ObjectMeta::{
          , name = Some MicroService.name
          , namespace = Some "apps"
          }
        , spec = Some (spec MicroService)
        }

in  deployment
