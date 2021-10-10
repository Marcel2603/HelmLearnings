let base = ./base.dhall

let service =
      { image = "devops-service"
      , tag = env:TAG as Text ? "1.0.0"
      , pullPolicy = "IfNotPresent"
      , aws_access = "Foo"
      , aws_secret = "Bar"
      , aws_bucket = "my-bucket"
      , db_url = "localhost"
      , db_user = "root"
      , db_pw = "root"
      }

in  base service
