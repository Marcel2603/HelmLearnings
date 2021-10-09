let base = ./base.dhall

let service =
      { image = "alpine"
      , tag = env:TAG as Text ? "3.14"
      , tester = "Tester"
      , foo = "Bar"
      , db_url = "local_url"
      }

in  base service
