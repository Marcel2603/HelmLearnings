let deployment = ../../../app/make.dhall

let MicroService = ../../../app/microservice.dhall

let kubernetes = ../../../lib/k8s/k8s.dhall

let global = ../../../app/global.dhall


let environment = {
    name: Text,
    value: Text
}

let makeEnv = \(env : environment) -> kubernetes.EnvVar::{
    name = env.name
    , value = Some env.value
}

let envVars = 
    [
        makeEnv {name= "tester", value="Service B"},
        makeEnv {name= "db_url", value= global.db_url},
        makeEnv {name= "global_url", value =global.global_url}
    ]

let service_b = MicroService::{ name = "Service B", image = "alpine:3.14", envVars = envVars }

in service_b
