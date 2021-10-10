let kubernetes = ./../../lib/k8s.dhall

in  { Type =
        { name : Text
        , appPort : Integer
        , image : Text
        , tag : Text
        , pullPolicy : Text
        , replicas : Integer
        , envVars : Optional (List kubernetes.EnvVar.Type)
        }
    , default =
      { pullPolicy = "IfNotPresent"
      , envVars = None (List kubernetes.EnvVar.Type)
      }
    }
