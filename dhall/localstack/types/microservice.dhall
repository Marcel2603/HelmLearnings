let kubernetes = ./../lib/k8s.dhall

in  { Type =
        { name : Text
        , appPort : Integer
        , image : Text
        , tag : Text
        , pullPolicy : Text
        , replicas : Integer
        , domain : Optional Text
        , envVars : Optional (List kubernetes.EnvVar.Type)
        }
    , default =
      { pullPolicy = "IfNotPresent"
      , domain = None Text
      , envVars = None (List kubernetes.EnvVar.Type)
      }
    }
