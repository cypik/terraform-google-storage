terraform {
  required_version = ">=1.9.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=6.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.3"
    }
  }
}