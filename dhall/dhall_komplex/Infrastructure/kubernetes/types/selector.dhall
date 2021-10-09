let kubernetes = ../../lib/k8s.dhall

let selector =
      \(appName : Text) ->
        kubernetes.LabelSelector::{
        , matchLabels = Some (toMap { name = appName })
        }

in  selector
