let kubernetes = ../lib/k8s/k8s.dhall

in  { Type =
        { name : Text
        , appPort : Integer
        , image : Text
        , domain : Text
        , replicas : Integer
        , leIssuer : Text
        , envVars : List kubernetes.EnvVar.Type
        , otherContainers : List kubernetes.Container.Type
        }
    , default =
        { name = "nginx"
        , appPort = +80
        , image = "nginx:1.21"
        , domain = ""
        , replicas = +1
        , leIssuer = "staging"
        , envVars = [] : List kubernetes.EnvVar.Type
        , otherContainers = [] : List kubernetes.Container.Type
        }
    }