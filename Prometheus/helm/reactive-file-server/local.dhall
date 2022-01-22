let base = ./base.dhall

let service =
      { image = "reactive-server"
      , tag = env:TAG as Text ? "1.0"
      , pullPolicy = "Always"
      , domain = "reactive-server.localhost"
      }

in  base service
