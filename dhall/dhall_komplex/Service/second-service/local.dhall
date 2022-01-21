let base = ./base.dhall

let service =
      { image = "alpine"
      , tag = env:TAG as Text ? "3.15"
      , pullPolicy = "IfNotPresent"
      , tester = "B"
      , foo = "Foo"
      , db_url = "local_url"
      }

in  base service
