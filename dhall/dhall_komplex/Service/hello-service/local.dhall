let base = ./base.dhall

let service =
      { image = "hello-service"
      , tag = env:TAG as Text ? "1.0.0"
      , pullPolicy = "IfNotPresent"
      , tester = "Tester"
      , foo = "Bar"
      , db_url = "local_url"
      }

in  base service
