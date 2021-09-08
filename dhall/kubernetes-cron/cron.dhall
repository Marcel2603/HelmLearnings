-- examples/deploymentSimple.dhall

let kubernetes =
      https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/package.dhall

let cron =
     kubernetes.CronJob:: {
      , metadata = kubernetes.ObjectMeta::{
            name = Some "hello"
         }
     , spec = Some kubernetes.CronJobSpec:: {
        jobTemplate = kubernetes.JobTemplateSpec:: {
            metadata = Some kubernetes.ObjectMeta::{ name = Some "hello" }
            ,spec = Some kubernetes.JobSpec:: {
             template = kubernetes.PodTemplateSpec::{
                        , metadata = Some kubernetes.ObjectMeta::{ name = Some "hello" }
                        , spec = Some kubernetes.PodSpec::{
                          , containers =
                            [ kubernetes.Container::{
                              , name = "hello"
                              , image = Some "busybox"
                              , command = Some [ "/bin/bash", "-c" , "date; echo Hello from the Kubernetes cluster" ]
                              }
                            ]
                            , restartPolicy = Some "OnFailure"
                          }
                        }
            }
        }
        , schedule = "*/1  * * * *"

     }
  }

in  cron