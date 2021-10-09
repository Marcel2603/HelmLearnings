let base = ./base.dhall

let service =
      { image = "alpine"
      , tag = env:TAG as Text ? "3.14"
      , tester = "B"
      , foo = "Foo"
      , db_url = "local_url"
      }

in  base service
