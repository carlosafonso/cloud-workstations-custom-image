# cloud-workstations-custom-image

This is my customized Google Cloud Workstations image.

The image is automatically built with Cloud Build every week to get the latest changes to the base Code OSS image, and the Cloud Workstations configuration is updated to use the latest tag. The processed is triggered by a Cloud Scheduler rule and images are stored in an Artifact Registry repository.

This repository includes a Terraform template under `infra/` which can be used to deploy the same resources to your GCP project.
