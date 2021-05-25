terraform {
  required_version = ">=0.15.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.68.0, <4.0.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.43.0"
    }
  }
}
