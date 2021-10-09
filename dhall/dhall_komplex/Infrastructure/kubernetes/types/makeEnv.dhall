let k8s = ../../lib/k8s.dhall

let environment = { name : Text, value : Text }

let makeEnv =
      \(env : environment) ->
        k8s.EnvVar::{ name = env.name, value = Some env.value }

in  makeEnv
