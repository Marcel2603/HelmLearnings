#!/bin/bash

echo "Generating kubernetes yamls"
dhall-to-yaml --file cron.dhall --output templates/cronJob.yaml
helm upgrade -i "busybox-cron" .
