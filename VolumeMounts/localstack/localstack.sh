#!/bin/bash
docker run -it -d -p 4566:4566 \
    -e SERVICES="kms" \
    -e KMS_SEED_PATH="/" \
    -e DEBUG=1 \
    -e LS_LOG="trace" \
    --mount type=bind,source="$(pwd)"/init,target=/init \
    localstack/localstack