#!/usr/bin/env bash

# Safeties on: https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euo pipefail

TRINO_TAG=zagaos/trino:2.0
MINIO_TAG=zagaos/minio:2.0
# DEFAULT_TAG=osclimate/minio:1.0
# TAG=${TAG:-$DEFAULT_TAG}

docker buildx ls | grep multiarch || docker buildx create --name multiarch --use

# docker buildx build  \
#     --platform linux/arm64 \
#     --tag "$AIRFLOW_TAG" \
#     --load \
#     .

docker buildx build  \
    -f Dockerfile-trino \
    --platform linux/arm64 \
    --tag "$TRINO_TAG" \
    --load \
    .

docker buildx build  \
    -f Dockerfile-minio \
    --platform linux/amd64 \
    --tag "$MINIO_TAG" \
    --load \
    .
docker pull quay.io/zagaos/dataproduct-dashboard:latest
docker pull quay.io/zagaos/dataproduct-dashboard:v11
``

docker pull quay.io/zagaos/dataproduct-client-api:v3


docker pull quay.io/zagaos/iceberg-custom-rest:1.0

# docker buildx build  \
#     -f Dockerfile-trino \
#     --platform linux/amd64 \
#     --tag "$TRINO_TAG" \
#     --load \
#     .

# docker buildx build  \
#     -f Dockerfile-minio \
#     --platform linux/amd64 \
#     --load \
#     --tag "$MINIO_TAG" \
#     .
# docker buildx build --push \
#     --platform linux/arm64,linux/amd64 \
#     --tag "$TAG" \
#     .