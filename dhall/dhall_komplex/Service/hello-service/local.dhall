let base = ./base.dhall

let service =
      { image = "reactive-file-server"
      , tag = env:TAG as Text ? "1.0"
      , pullPolicy = "IfNotPresent"
      , domain = "reactive-server.localhost"
      , tester = "Tester"
      , foo = "Bar"
      , db_url = "local_url"
      }

in  base service
