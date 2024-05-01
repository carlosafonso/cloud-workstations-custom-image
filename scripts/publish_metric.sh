#!/usr/bin/env bash
#
# publish_metric.sh
#
# This script publishes a boolean value to the custom metric used to indicate
# whether the latest image build was successful.
#

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 [value (0 or 1)]"
    exit 1
fi

if [ $1 -lt 0 ] || [ $1 -gt 1  ]; then
    echo "Invalid value (must be 0 or 1)"
    exit 1
fi

GCP_PROJECT_ID=$(curl -v -H 'Metadata-Flavor: Google' http://metadata.google.internal/computeMetadata/v1/project/project-id)
if [ $? -ne 0 ]; then
    echo "Failed to retrieve GCP project ID from metadata server."
    exit 1
fi

BOOL_VALUE=$([ $1 -eq 1 ] && echo true || echo false)

curl -X POST https://monitoring.googleapis.com/v3/projects/$GCP_PROJECT_ID/timeSeries \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H 'Content-Type: application/json' \
    --data-binary @- <<EOF
{
 "timeSeries": [
  {
   "metric": {
    "type": "custom.googleapis.com/cw_custom_img/build_failed"
   },
   "resource": {
    "type": "global"
   },
   "points": [
    {
     "interval": {
      "endTime": "$(date +%FT%TZ)"
     },
     "value": {
      "boolValue": $BOOL_VALUE
     }
    }
   ]
  }
 ]
}
EOF
