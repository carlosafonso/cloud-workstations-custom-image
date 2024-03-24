#!/usr/bin/env bash

set -eo pipefail

if [ -z $WORKSTATIONS_CONFIG_NAME ]; then
    echo "Can't update Workstations config: \$WORKSTATIONS_CONFIG_NAME not defined"
    exit 1
fi

if [ -z $WORKSPACE_DIR ]; then
    WORKSPACE_DIR="/tmp"
else
    WORKSPACE_DIR="/workspace"
fi

IMAGE_URL=$(cat "$WORKSPACE_DIR/data.txt")

echo "Updating Cloud Workstations config '$WORKSTATIONS_CONFIG_NAME' with image URL '$IMAGE_URL'"

gcloud workstations configs update \
    --container-custom-image="$IMAGE_URL" \
    "$WORKSTATIONS_CONFIG_NAME"

echo "Cloud Workstations config updated"
