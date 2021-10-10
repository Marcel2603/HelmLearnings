let base = ./base.dhall

let service =
      { image = "second-service"
      , tag = env:TAG as Text ? "1.0.0"
      , pullPolicy = "IfNotPresent"
      , tester = "B"
      , foo = "Foo"
      , db_url = "local_url"
      }

in  base service
