let release =
      { name = "{{ .Release.Name }}", namespace = "{{ .Release.Namespace }}" }

let chart = { name = "{{ .Chart.Name }}", version = "{{ .Chart.Version }}" }

let utils = { Release = release, Chart = chart }

in  utils
