let kubernetes = ./../../lib/k8s.dhall

in  { Type =
        { name : Text
        , appPort : Integer
        , image : Text
        , tag: Text
        , replicas : Integer
        , envVars : Optional (List kubernetes.EnvVar.Type)
        }
    , default.envVars = None (List kubernetes.EnvVar.Type)
    }
