# us-west-2 (Oregon) is one of the biggest regions with lowest cost
provider "aws" {
  assume_role {
    role_arn = var.role_arn
  }
  region = "us-west-2"
  default_tags {
    tags = local.tags
  }
}

# us-east1 is one of the biggest regions
# https://cloud.google.com/compute/docs/regions-zones
provider "google" {
  region                      = "us-east1"
  project                     = "f-development"
  impersonate_service_account = var.impersonate_sa
}

provider "google-beta" {
  region                      = "us-east1"
  project                     = "f-development"
  impersonate_service_account = var.impersonate_sa
}