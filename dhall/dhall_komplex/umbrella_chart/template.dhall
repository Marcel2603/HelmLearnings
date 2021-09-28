let deployment = ../app/make.dhall

let service_a = ../apps/service_a.dhall

let service_b = ../apps/service_b.dhall


in [deployment service_a, deployment service_b]
