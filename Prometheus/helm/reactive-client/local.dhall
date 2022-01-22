let base = ./base.dhall

let service =
      { image = "reactive-client"
      , tag = env:TAG as Text ? "1.0"
      , pullPolicy = "Always"
      , domain = "reactive-client.localhost"
      }

in  base service
