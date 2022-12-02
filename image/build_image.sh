#!/usr/bin/env bash

set -euo pipefail

if [ -z $REGISTRY_URL ]; then
    echo "Can't build image: \$REGISTRY_URL not defined"
    exit 1
fi

if [ -z $IMAGE_NAME ]; then
    echo "Can't build image: \$IMAGE_NAME not defined"
    exit 1
fi

SUFFIX=$(date +%Y%m%d%H%M%S)
docker build . -t "$REGISTRY_URL/$IMAGE_NAME:$SUFFIX"
docker push "$REGISTRY_URL/$IMAGE_NAME:$SUFFIX"

echo "Image built successfully: $REGISTRY_URL/$IMAGE_NAME:$SUFFIX"
