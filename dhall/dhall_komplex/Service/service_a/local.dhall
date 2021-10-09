let base = ./base.dhall

let infra = ./../../Infrastructure/kubernetes/package.dhall

let k8s = ../../Infrastructure/lib/k8s.dhall

let envVars =
      [ infra.makeEnv { name = "tester", value = "tester" }
      , infra.makeEnv { name = "foo", value = "bar" }
      , infra.makeEnv { name = "global_url", value = "url" }
      ]

let service_a =
      infra.microservice::{ name = "Service A", image = "alpine:3.14", envVars }

in  base service_a
