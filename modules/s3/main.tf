terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.29.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 4.10.0"
    }
  }
  required_version = ">= 1.3.0"
}
