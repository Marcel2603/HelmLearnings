let k8s =
      https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/1.22/package.dhall
        sha256:889a6a252c3789b470f566985dac0706e8617b1ae001166cdcf99553b4b9e6e9

let AwsSecret =
      { apiVersion : Text
      , kind : Text
      , metadata : k8s.ObjectMeta.Type
      , spec : Optional ./AwsSecretSpec.dhall
      }

in  AwsSecret
