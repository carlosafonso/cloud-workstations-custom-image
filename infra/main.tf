terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.44.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.44.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

resource "random_id" "suffix" {
  byte_length = 2
}

locals {
  name = "cw-custom-img-${random_id.suffix.hex}"
}


module "project_services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 13.0"

  project_id  = var.gcp_project_id
  enable_apis = var.enable_apis

  activate_apis = [
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
  ]
  disable_services_on_destroy = false
}

resource "google_artifact_registry_repository" "main" {
  project       = var.gcp_project_id
  location      = var.gcp_region
  repository_id = local.name
  format        = "DOCKER"
}

resource "google_service_account" "cloudbuild" {
  account_id   = "${local.name}-cb"
  display_name = "${local.name} pipeline - Service Account for Cloud Build builds"
}

module "cloudbuild_svc_acct_iam_member_roles" {
  source                  = "terraform-google-modules/iam/google//modules/member_iam"
  service_account_address = google_service_account.cloudbuild.email
  project_id              = var.gcp_project_id
  project_roles = [
    # Allows reading/pushing from/to Artifact Registry.
    "roles/artifactregistry.writer",
    # Allows writing logs to Cloud Logging.
    "roles/logging.logWriter",
  ]
}

# The trigger of Cloud Build builds. Assumes that source repo is hosted on
# GitHub.
resource "google_cloudbuild_trigger" "main" {
  name            = local.name
  service_account = google_service_account.cloudbuild.id

  github {
    owner = var.github_repo_owner
    name  = var.github_repo_name
    push {
      branch = var.branch_filter_regex
    }
  }

  substitutions = {
    _ARTIFACT_REGISTRY_BASE_URL = "${var.gcp_region}-docker.pkg.dev/${var.gcp_project_id}/${google_artifact_registry_repository.main.repository_id}"
    _IMAGE_NAME                 = local.name
    _REGION                     = var.gcp_region
  }

  filename = "image/cloudbuild.yaml"
}
