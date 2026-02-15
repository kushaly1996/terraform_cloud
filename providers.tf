terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.74.0" # Use the appropriate version
    }
  }
  required_version = ">= 1.5.5"
}

provider "tfe" {
  token = ""
}