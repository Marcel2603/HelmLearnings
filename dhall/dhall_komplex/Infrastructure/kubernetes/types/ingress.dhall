let kubernetes = ./../../lib/k8s.dhall

let MicroService = ./microservice.dhall

let helmUtils = ./../../lib/helm_utils.dhall

let metadata
    : MicroService.Type → kubernetes.ObjectMeta.Type
    = λ(microservice : MicroService.Type) →
        kubernetes.ObjectMeta::{
        , name = Some microservice.name
        , labels = Some (toMap { app = microservice.name })
        , namespace = Some "apps"
        }

let rule
    : MicroService.Type → kubernetes.IngressRule.Type
    = λ(microservice : MicroService.Type) →
        kubernetes.IngressRule::{
        , host = microservice.domain
        , http = Some kubernetes.HTTPIngressRuleValue::{
          , paths =
            [ kubernetes.HTTPIngressPath::{
              , pathType = "Prefix"
              , path = Some "/*"
              , backend = kubernetes.IngressBackend::{
                , service = Some kubernetes.IngressServiceBackend::{
                  , name = microservice.name
                  , port = Some kubernetes.ServiceBackendPort::{
                    , number = Some microservice.appPort
                    }
                  }
                }
              }
            ]
          }
        }

let ingress
    : MicroService.Type → kubernetes.Ingress.Type
    = λ(microservice : MicroService.Type) →
        kubernetes.Ingress::{
        , metadata = kubernetes.ObjectMeta::{
          , name = Some microservice.name
          , namespace = Some helmUtils.Release.namespace
          , labels = Some (toMap { app = microservice.name })
          }
        , spec = Some kubernetes.IngressSpec::{
          , rules = Some [ rule microservice ]
          }
        }

in  ingress
