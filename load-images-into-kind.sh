#!/usr/bin/env bash
set -euo pipefail

# Name of your kind cluster
# KIND_CLUSTER_NAME="osclimate-cluster"

NAMESPACE="dataproduct"

# KIND_CLUSTER="osclimate-cluster"
KIND_CLUSTER_NAME="zaga-cluster"
# Images to reload
IMAGES=(
  "zagaos/trino:2.0"
  "zagaos/minio:2.0"
  "quay.io/zagaos/dataproduct-dashboard:v11"
  "quay.io/zagaos/dataproduct-dashboard:latest"
  "quay.io/zagaos/dataproduct-client-api:v3"
  "quay.io/zagaos/iceberg-custom-rest:1.0"

)


# Function to delete and reload image
reload_image() {
  local image=$1
  echo "Removing old $image from nodes (if present)..."

  for node in $(kind get nodes --name "$KIND_CLUSTER_NAME"); do
    docker exec "$node" crictl rmi "$image" || echo "$image not present on $node"
  done

  echo "🔄 Loading fresh $image into kind cluster '$KIND_CLUSTER_NAME'..."
  kind load docker-image "$image" --name "$KIND_CLUSTER_NAME"
}

# Loop through and reload each image
for image in "${IMAGES[@]}"; do
  reload_image "$image"
done

echo "Images reloaded into kind cluster '$KIND_CLUSTER_NAME'."