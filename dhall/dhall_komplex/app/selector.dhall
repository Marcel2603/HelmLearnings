let Prelude = ../lib/k8s/prelude.dhall
let kubernetes = ../lib/k8s/k8s.dhall

let selector = \(appName: Text) -> kubernetes.LabelSelector::{
          , matchLabels = Some (toMap { name = appName })
          }

in  selector
