let deployment = ./app/make.dhall

let MicroService = ./app/microservice.dhall


let test = MicroService:: {
  name = "test"
}

in deployment test
