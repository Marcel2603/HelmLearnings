let kubernetes = ./../../lib/k8s.dhall

let MicroService = ./microservice.dhall

let selector = ./selector.dhall

let spec
    : MicroService.Type → kubernetes.ServiceSpec.Type
    = λ(config : MicroService.Type) →
        kubernetes.ServiceSpec::{
        , type = Some "ClusterIP"
        , ports = Some
          [ kubernetes.ServicePort::{
            , targetPort = Some (kubernetes.IntOrString.Int config.appPort)
            , port = config.appPort
            , name = Some "http"
            }
          ]
        , selector = Some (toMap { app = config.name })
        }

let service
    : MicroService.Type → kubernetes.Service.Type
    = λ(config : MicroService.Type) →
        kubernetes.Service::{
        , metadata = kubernetes.ObjectMeta::{
          , name = Some config.name
          , labels = Some (toMap { app = config.name })
          }
        , spec = Some (spec config)
        }

in  service
